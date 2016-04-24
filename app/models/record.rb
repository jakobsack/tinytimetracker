class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.close_last_record_for user_id
    record = where(user_id: user_id, ended_at: nil).first
    return true unless record

    record.ended_at = Time.now
    record.save!
  end
end
