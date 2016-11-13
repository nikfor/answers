class SearchController < ApplicationController

  skip_authorization_check

  def index
    respond_with (@result = klass.search(params[:search][:query]))
  end

  private

  def klass
    if params[:search][:area] == "All"
      return "ThinkingSphinx".classify.constantize
    else
      params[:search][:area].classify.constantize
    end
  end

end
