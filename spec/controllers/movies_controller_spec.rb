require 'spec_helper'

describe MoviesController do

	it "renders the index template" do
		get :index
		expect(response).to render_template("index")
	end

end
