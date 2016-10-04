class Project < ActiveRecord::Base
  belongs_to :creator, class_name: :User, foreign_key: "user_id"
  belongs_to :location
  has_many :rates

  validates :name, presence: true, uniqueness: true
  validates :creator, presence: true

  def as_json(options)
    {
      id: id,
      name: name,
    }
  end
end
