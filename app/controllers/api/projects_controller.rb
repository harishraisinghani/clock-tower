class Api::ProjectsController < Api::BaseController

  def index
    render json: Project.order(:name => :asc).all, status: :ok
  end

end
