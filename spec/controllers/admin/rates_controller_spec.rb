describe Admin::RatesController, type: :controller do

  logged_in_user_admin

  before :each do
    @rate = create :rate
  end

  describe "GET #index" do
    it "assigns the rates to the @rates" do
      get :index
      expect(assigns(:rates)).to include @rate
    end

    it "renders the :index template" do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "assigns a new Rate to @rate" do
      get :new
      expect(assigns(:rate)).to be_a_new(Rate)
    end

    it "has all users" do
      # TODO
    end

    it "has all projects" do
      # TODO
    end

    it "has all tasks" do
      # TODO
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "valid attributes" do
      it "saves the new rate to database" do
        expect do
          post :create, rate: attributes_for(:rate)
        end.to change(Rate, :count).by(1)
      end

      it "redirects to :index page" do
        post :create, rate: attributes_for(:rate)
        expect(response).to redirect_to(admin_rates_url)
      end
    end

    context "invalid attributes" do
      it "does not save the new task to database" do
        expect do
          post :create, rate: attributes_for(:rate_at_zero)
        end.to_not change(Task, :count)
      end

      it "re-render the :new page" do
        post :create, rate: attributes_for(:rate_at_zero)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @rate = create(:rate)
    end

    it "assigns the requested Rate to @rate" do
      get :edit, id: @rate
      expect(assigns(:rate)).to eq @rate
    end

    it "renders the :edit template" do
      get :edit, id: @rate
      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    before :each do
      @new_rate = 100
      @rate = create(:rate)
    end

    it "locates the requested rate" do
      put :update, id: @rate, rate: attributes_for(:rate)
      expect(assigns(:rate)).to eq @rate
    end

    context "valid attributes" do
      it "changes @project attributes" do
        put :update, id: @rate, rate: attributes_for(:project,
          rate: @new_rate)
        @rate.reload
        expect(@rate.rate).to eq @new_rate
      end

      it "redirects to :index page" do
        put :update, id: @rate, rate: attributes_for(:rate)
        expect(response).to redirect_to(admin_rates_url)
      end
    end

    context "invalid attributes" do
      it "does not change @rate attributes" do
        put :update, id: @rate, rate: attributes_for(:rate,
          rate: 0)
        @rate.reload
        expect(@rate.rate).to eq 30
      end

      it "re-render the :edit page" do
        put :update, id: @rate, rate: attributes_for(:rate,
          rate: 0 )
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @rate = create(:rate)
    end

    it "deletes @rate" do
      expect do
        delete :destroy, id: @rate
      end.to change(Rate, :count).by(-1)
    end

    it "redirects to :index page" do
      delete :destroy, id: @rate
      expect(response).to redirect_to(admin_rates_url)
    end
  end

end
