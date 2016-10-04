class ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:destroy]

  # GET /api_keys
  # GET /api_keys.json
  def index
    @api_keys = ApiKey.where(user_id: current_user.id).all
    @api_key = ApiKey.new
  end


  # POST /api_keys
  # POST /api_keys.json
  def create
    @api_key = ApiKey.new(api_key_params)
    @api_key.user = current_user
    respond_to do |format|
      if @api_key.save
        format.html { redirect_to api_keys_url , notice: 'Api key was successfully created.' }
      else
        format.html { redirect_to api_keys_url  }
      end
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.json
  def destroy
    @api_key.destroy
    respond_to do |format|
      format.html { redirect_to api_keys_url, notice: 'Api key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.where(id: params[:id], user_id: current_user.id).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      params.require(:api_key).permit(:note)
    end
end
