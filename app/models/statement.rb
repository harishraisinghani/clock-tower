class Statement < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  has_many :statement_transitions, autosave: false
  has_many :statement_time_entries
  has_many :time_entries, through: :statement_time_entries
  belongs_to :user

  validates :from, presence: true
  validates :to, presence: true
  validates :post_date, presence: true
  validates :user_id, presence: true

  scope :by_users, -> (users){ where(user_id: users) }
  scope :by_locations, -> (locations){ joins(:user).where(:"users.location_id" => locations)}
  scope :containing_date, -> (date){ where("statements.from <= ? AND statements.to >= ?", date, date) }

  def as_json(options)
    {
      id: id,
      locked_at: locked_at.try(:to_s, :humanly),
      created_at: created_at.to_s(:humanly),
      from: from.to_s(:humanly),
      to: to.to_s(:humanly),
      post_date: post_date.to_s(:humanly),
      state: state,
      user: user.as_json(options),
      subtotal: subtotal,
      tax_amount: tax_amount,
      hours: hours,
      total: total,
      back_dated: back_dated_entries?
    }
  end

  def back_dated_entries?
    time_entries.before(from).count > 0
  end

  def to_s
    "#{from.to_s(:humanly)} - #{to.to_s(:humanly)}"
  end

  def state
    state_machine.current_state
  end

  def transition_to(new_state)
    state_machine.transition_to(new_state)
  end

  def state_machine
    @state_machine ||= StatementStateMachine.new(self, transition_class: StatementTransition)
  end

  def tax_amount
    time_entries.where(apply_rate: true, has_tax: true).sum("duration_in_hours * rate * (tax_percent / 100)")
  end

  def subtotal
    time_entries.where(apply_rate: true).sum("duration_in_hours * rate")
  end

  def hours
    time_entries.sum("duration_in_hours")
  end

  def total
     subtotal + tax_amount
  end

  def editable?
    Statement.editable_states.include?(self.state)
  end

  class << self
    def editable_states
      ['pending', 'void']
    end

    def transition_class
      StatementTransition
    end

    def initial_state
      :pending
    end
  end
end
