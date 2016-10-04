class Rate < ActiveRecord::Base

  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :rate, presence: true, numericality: { greater_than: 0 }

  scope :by_users, -> (users){ where(user_id: users) }
  scope :by_projects, -> (projects){ where(project_id: projects) }
  scope :by_tasks, -> (tasks){ where(task_id: tasks) }
end
