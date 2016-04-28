class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.close_last_record_for user_id
    record = where(user_id: user_id, ended_at: nil).first
    return true unless record

    record.ended_at = Time.now
    record.save!
  end

  def self.normalize_records records, day
    new_records = []
    total_balance = 0.0

    records.map{|r|r.project}.uniq.each do |project|
      reduced = records.select {|r|r.project_id == project.id}
      total = reduced.inject(0.0) {|sum,r| sum + r.duration}
      balance = 0.0

      7.times do |i|
        this = day + i.days
        today = reduced.select{|r| r.begun_at >= this && r.begun_at < this + 1.day}.inject(0.0) {|sum,r| sum + r.duration}

        next if today == 0.0
        if balance + today < 0
          balance += today
          next
        end
        today -= balance
        balance = 0.0

        normalized = (today/900).to_i * 900
        if today % 900 > 300
          normalized += 900
        end
        normalized = 900 if normalized == 0.0
        balance += today - normalized

        new_records << new(begun_at: this, ended_at: this + normalized, project: project)
      end
      total_balance += balance
    end

    if total_balance.abs > 600.0
      diff = total_balance.abs + 300.0
      diff = ((diff/900).to_i * 900).seconds
      diff = diff * -1 if total_balance < 0
      largest = new_records.max {|a,b| a.duration <=> b.duration}

      largest.ended_at += diff if largest.duration > 900.0
    end

    new_records
  end

  def duration
    return 0.0 unless ended_at
    ended_at - begun_at
  end

  def <=> other
    other.begun_at <=> begun_at
  end
end
