class Admin::RatesController < Admin::BaseController

  def index
    @rates = Rate.page(params[:page]).per(25).includes(:user, :project, :task).order('users.firstname asc', 'projects.name asc', 'tasks.name asc')
    @rates = @rates.by_users(params[:users]) if params[:users].present?
    @rates = @rates.by_projects(params[:projects]) if params[:projects].present?
    @rates = @rates.by_tasks(params[:tasks]) if params[:tasks].present?
    form_data
  end

  def new
    @rate = Rate.new
    @path = admin_rates_path
    form_data
  end

  def create
    @rate = Rate.new(rate_params)

    if @rate.save
      redirect_to admin_rates_path
    else
      @path = admin_rates_path
      form_data
      render :new
    end
  end

  def edit
    @rate = Rate.find(params[:id])
    @path = admin_rate_path
    form_data
  end

  def update
    @rate = Rate.find(params[:id])

    @rate.assign_attributes(rate_params)

    if @rate.save
      redirect_to admin_rates_path
    else
      @path = admin_rate_path
      form_data
      render :edit
    end
  end

  def destroy
    @rate = Rate.find(params[:id])

    @rate.destroy
    redirect_to admin_rates_path, notice: "Rate deleted successfully"
  end

  private

  def rate_params
    params.require(:rate).permit(:user_id, :project_id, :task_id, :rate, :note)
  end

  def form_data
    @all_users = User.all
    @all_projects = Project.all
    @all_tasks = Task.all
  end

end
