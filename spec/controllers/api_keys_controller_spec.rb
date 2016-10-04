RSpec.describe ApiKeysController, type: :controller do

  logged_in_user

  let(:valid_attributes) {
    {
      note: "My API Key",
      user: current_user
    }
  }

  describe "GET #index" do
    it "assigns all api_keys as @api_keys" do
      api_key = create(:api_key, user: current_user)
      get :index, {}
      expect(assigns(:api_keys)).to eq([api_key])
    end

    it "has a default empty @api_key set" do
      get :index, {}
      expect(assigns(:api_key)).to_not be_nil
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ApiKey" do
        expect {
          post :create, {:api_key => valid_attributes}
        }.to change(ApiKey, :count).by(1)
      end

      it "assigns a newly created api_key as @api_key" do
        post :create, {:api_key => valid_attributes}
        expect(assigns(:api_key)).to be_a(ApiKey)
        expect(assigns(:api_key)).to be_persisted
      end

      it "redirects to the created api_key" do
        post :create, {:api_key => valid_attributes}
        expect(response).to redirect_to('/api_keys')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested api_key" do
      api_key = create(:api_key, valid_attributes)
      expect {
        delete :destroy, {:id => api_key.id}
      }.to change(ApiKey, :count).by(-1)
    end

    it "redirects to the api_keys list" do
      api_key = create(:api_key, valid_attributes)
      delete :destroy, {:id => api_key.id}
      expect(response).to redirect_to(api_keys_url)
    end
  end

end
