class Admin::Reports::SummaryController < Admin::Reports::BaseController

  def show
    @time_entries = TimeEntry.query(
      report_params[:from],
      report_params[:to],
      report_params[:users],
      report_params[:projects],
      report_params[:tasks],
      report_params[:locations]
    )

    @from = report_params[:from].present? ? Date.parse(report_params[:from]) : Date.today.beginning_of_week
    @to = report_params[:to].present? ? Date.parse(report_params[:to]) : Date.today
    @total_duration = @time_entries.sum(:duration_in_hours)

    respond_to do |format|
      format.html {
        @time_entries = @time_entries.includes(:user, :task, :project)
        @time_entries = @time_entries.page(params[:page]).per(25).order(entry_date: :desc, id: :asc)
        render
      }
      format.csv {
        @time_entries = @time_entries.includes(user: [:location], task: [], project: []).order(entry_date: :desc, id: :asc)
        send_data @time_entries.to_csv, filename: "summary-#{Date.today}.csv"
      }
    end
  end

  private

  def report_params
    params.permit(:from, :to, users: [], projects: [], tasks: [], locations: [])
  end

  def total_duration(entries)
    entries.inject(0) { |sum, entry| sum + entry.duration_in_hours }
  end

end
