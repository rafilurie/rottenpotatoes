require 'debugger'
# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.

  assert match = /#{e1}.*#{e2}/m =~ page.body
  # flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  all_movies = Movie.all
  all = Movie.all_ratings
  list = rating_list.split(',')
  other = []
  
  all.each do |rating|
    if !list.include? rating
      other << rating
    end
  end
  
  if (uncheck)
    list.each do |rating|
      step "When I uncheck \"ratings_#{rating}\""
      step "Then the \"ratings_#{rating}\" checkbox should not be checked"
    end
  end

  other.each do |rating|
    step "I check \"ratings_#{rating}\""
    #step "The \"ratings_#{rating}\" checkbox should be checked"
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  all = Movie.all
  all.each do |movie|
    step "I should see \"#{movie.title}\""
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |title, dir|
  assert(Movie.find_by_title(title).director == dir, "\"#{title}\" has the wrong director.")
end