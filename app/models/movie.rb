class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def Movie.all_ratings
  	['G', 'PG', 'PG-13', 'R']
  end

end
