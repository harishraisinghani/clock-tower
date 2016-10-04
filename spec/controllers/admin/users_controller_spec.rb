describe Admin::UsersController do

  logged_in_user_admin

  describe "GET #index" do
    it "should return a paginated array of all users with not filters" do
      users = [build(:user)]
      expect(User).to receive_message_chain(:order, :page, :per).and_return(users)
      get :index
      expect(assigns(:users)).to eq users
    end

    # TODO These filter tests are weak, should actually test the params to where
    it "should filter by location if provided" do
      users = [build(:user)]
      expect(User).to receive_message_chain(:order, :where, :page, :per).and_return(users)
      get :index, {locations: [1]}
      expect(assigns(:users)).to eq users
    end

    it "should filter by email if provided" do
      users = [build(:user)]
      expect(User).to receive_message_chain(:order, :where, :page, :per).and_return(users)
      get :index, {email: 'gmail.com'}
      expect(assigns(:users)).to eq users
    end

    it "should filter by first_name and last_name if name provided" do
      users = [build(:user)]
      expect(User).to receive_message_chain(:order, :where, :page, :per).and_return(users)
      get :index, {name: 'User'}
      expect(assigns(:users)).to eq users
    end

    it "should assign locations" do
      locations = [build(:location)]
      expect(Location).to receive(:all).and_return(locations)
      get :index
      expect(assigns(:all_locations)).to eq(locations)
    end
  end

  describe "GET #new" do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the user to the databse" do
        expect do
          post :create, user: attributes_for(:user)
        end.to change(User, :count).by(1)
      end

      it "sets the users 'password reset required to true" do
        post :create, user: attributes_for(:user)
        expect(assigns(:user).password_reset_required).to eq(true)
      end

      it "should redirect to the admin users index" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid attributes" do
      it "should not create a new user in the database" do
        expect do
          post :create, user: attributes_for(:user, email: nil)
        end.to change(User, :count).by(0)
      end

      it "should render the new template" do
        post :create, user: attributes_for(:user, email: nil)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "should load the correct User" do
      user = create(:user)
      get :edit, id: user
      expect(assigns(:user)).to eq user
    end
  end

  describe "PUT #update" do
    before :each do
      @user = create(:user)
    end

    context "with valid attributes" do
      it "should load correct user" do
        put :update, id: @user, user: attributes_for(:user)
        expect(assigns(:user)).to eq(@user)
      end

      it "should update the user with the correct values" do
        put :update, id: @user, user: attributes_for(:user, firstname: "Test_Passed")
        @user.reload
        expect(@user.firstname).to eq("Test_Passed")
      end

      it "should redirect to the admin users index" do
        put :update, id: @user, user: attributes_for(:user)
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid attributes" do
      it "should load correct user" do
        put :update, id: @user, user: attributes_for(:user, email: nil)
        expect(assigns(:user)).to eq(@user)
      end

      it "should not update the user with incorrect values" do
        put :update, id: @user, user: attributes_for(:user, firstname: nil)
        @user.reload
        expect(@user.firstname).to_not eq(nil)
      end

      it "should render the edit template" do
        put :update, id: @user, user: attributes_for(:user, firstname: nil)
        expect(response).to render_template(:edit)
      end
    end

  end
end
