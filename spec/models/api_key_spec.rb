# require 'rails_helper'

RSpec.describe ApiKey, type: :model do

  describe "creation" do

    it "create unique api key on creation" do
      api = create(:api_key)
      expect(api.key).not_to be_nil
    end
  end
end
