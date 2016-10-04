class Api::TasksController < Api::BaseController

  def index
    render json: Task.order(:name => :asc).all, status: :ok
  end

end
