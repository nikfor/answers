class SearchController < ApplicationController

  skip_authorization_check

  def index
    respond_with (@result = Search.return_results(params[:search]) )
  end

end
