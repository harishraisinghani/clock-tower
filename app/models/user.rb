class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  has_many :time_entries
  has_many :statements
  has_many :rates

  belongs_to :location

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :password_reset_token, uniqueness: true, if: :password_reset_token

  # validate :rate_for_hourly

  scope :hourly, -> { where(hourly: true) }
  scope :by_email, -> (email){ where('lower(email) = ?', email.downcase) }
  scope :active, -> { where(active: true) }
  scope :admins_accepting_emails, -> { where(is_admin: true, receive_admin_email: true) }

  after_create :send_email_invite

  attr_accessor :creator # virtual attribute

  def fullname
    "#{firstname} #{lastname}"
  end

  def as_json(options)
    {
      id: id,
      firstname: firstname,
      lastname: lastname,
      fullname: fullname,
      email: email,
      location: location.as_json(options)
    }
  end

  ### Actual slack reminder code
  # def send_slack_reminder
  #   if slack_name && slack_reminder
  #     notify = Slack::Notifier.new "Webhook URL", channel: '#channel_name', username: 'clock-tower'
  #     notify.ping "Reminder to review your statement - http://localhost:3000/statements/#{id}"
  #   end
  # end
  ###

  
  ### For testing purposes only - using class method
  # class << self
  #   def send_slack
  #     result = 
  #   end
  # end
  ###

  private

  def send_email_invite
    UserMailer.user_invite(self, creator).deliver_now
  end

  def rate_for_hourly
    errors.add(:rate, 'Rate is required for hourly users') if hourly and (!rate or rate <= 0)
  end

end
