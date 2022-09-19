require 'spec_helper'
require_relative '../../lib/zinc/search_engine'

RSpec.describe 'SearchEngine' do

  describe "#calculate_page_value" do
    it "Calculates page value based on query" do
      response = SearchEngine.new

      expect(response.total_pages).to be(6)
      expect(response.total_queries).to be(6)
    end
  end

end