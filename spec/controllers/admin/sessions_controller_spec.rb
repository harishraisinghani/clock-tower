RSpec.describe Admin::SessionsController, type: :controller do
  logged_in_user_admin

  before :each do
    @user = create(:user, password: 'test', email: 'test@email.com')
  end

  describe "GET #impersonate" do

    it "should set session user_id to indicated user" do
      get :impersonate, id: @user.id
      expect(session[:user_id].to_i).to eq(@user.id)
    end

    it "should set session original_user_id to previous admin user" do
      u = current_user
      get :impersonate, id: @user.id
      expect(session[:original_user_id].to_i).to eq(u.id)
    end
  end

end
