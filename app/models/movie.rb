class Movie < ActiveRecord::Base
  def self.all_ratings
    allRatings = []
    movies = Movie.all	
    movies.each do |movie|
      if (!allRatings.include?(movie.rating))
       allRatings.push(movie.rating)
      end	      
    end
  return allRatings
  end
end
