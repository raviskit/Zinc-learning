require 'spec_helper'
require_relative '../../lib/zinc/data_model.rb'

RSpec.describe "DataModel" do
  describe "DataModel#assign_weights" do
    it "Assigns Max weight to words" do
      data_model = DataModel.new(1, ["ford", "review"])
      expect(data_model.weight).to be_empty

      data_model.assign_weights(8)
      expect(data_model.weight).not_to be_empty
      expect(data_model.weight["ford"]).to be(8)
    end
  end
end