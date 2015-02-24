# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(title: movie['title'], rating: movie['rating'], release_date: movie['release_date'])
  end
  # flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.

  match = /#{e1}.*#{e2}/m =~ page.body
  # e1_true = false
  # e2_true = false
  # page.body.split(' ').each do |elem|
  #   if elem == e1
  #     e1_true = true
  #   elsif elem == e2
  #     e2_true = true
  #   end

  #   if e1_true && !e2_true
  #     return true
  #   elsif e2_true && !e1_true
  #     return false
  #   end
  # end
  # flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

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
    ##step "The \"ratings_#{rating}\" checkbox should be checked"
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  all = Movie.all
  all.each do |movie|
    step "I should see \"#{movie.title}\""
  end
end