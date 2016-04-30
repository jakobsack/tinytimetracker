class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.close_last_record_for user_id
    record = where(user_id: user_id, ended_at: nil).first
    return true unless record

    record.ended_at = Time.now
    record.save!
  end

  def duration
    return 0.0 unless ended_at
    ended_at - begun_at
  end

  def <=> other
    other.begun_at <=> begun_at
  end

  class << self
    def normalize_records records
      new_records = []
      days = get_days(records)
      total_balance = 0.0

      # balance:
      #   > 0: more normalized time than actually spent

      records.map{|r|r.project}.uniq.each do |project|
        reduced = records.select {|r|r.project_id == project.id}
        balance = 0.0

        days.each do |this|
          today = working_time(reduced, this)

          # skip empty days
          next if today == 0.0

          # continue if balance is worse than working hours
          if balance - today > 0
            balance -= today
            next
          end

          today -= balance
          balance = 0.0

          normalized = (today/900).to_i * 900
          normalized += 900 if today % 900 > 450
          normalized = 900 if normalized == 0.0

          new_records << new(begun_at: this, ended_at: this + normalized, project: project)

          balance += normalized - today
        end
        total_balance += balance
      end

      if total_balance.abs > 450.0
        diff = total_balance.abs + 450.0
        diff = ((diff/900).to_i * 900).seconds
        diff = diff * -1 if total_balance > 0

        largest = new_records.max {|a,b| a.duration <=> b.duration}
        largest.ended_at += diff if largest.duration > 900.0
      end

      new_records
    end

    def get_days records
      records.map {|r| r.begun_at.beginning_of_day}.uniq
    end

    def working_time records, day
      day_records = records.select do |r|
        r.begun_at >= day && r.begun_at < day + 1.day
      end
      day_records.inject(0.0) do |sum, r|
        sum + r.duration
      end
    end
  end
end
