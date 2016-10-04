require 'securerandom'

class ApiKey < ActiveRecord::Base
  acts_as_paranoid column: :revoked_on

  belongs_to :user

  validates :key, uniqueness: true

  before_create :assign_api_key

  private

  def assign_api_key
    self.key = SecureRandom.uuid
  end

end
