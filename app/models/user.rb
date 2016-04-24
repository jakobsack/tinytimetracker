class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.session_class = Session
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  has_many :projects
  has_many :records

  validates :username, presence: true

  def open_record
    records.where(ended_at: nil).first
  end
end
