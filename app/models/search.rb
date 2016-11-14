class Search < ActiveRecord::Base

  SEARCH_CLASSES = ["Question", "Answer", "Comment", "User", "ThinkingSphinx"]

  def self.return_results(search_params)
    klass(search_params[:area]).search(ThinkingSphinx::Query.escape(search_params[:query]))
  end

  private

  def self.klass(area)
    return area.classify.constantize if SEARCH_CLASSES.include?(area)
    ThinkingSphinx
  end

end
