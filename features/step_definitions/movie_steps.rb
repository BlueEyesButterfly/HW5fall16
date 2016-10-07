# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

# When /^I press: (.*?)$/ do |button|
#   click_button(button)
# end


Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  #pending  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    Movie.create!(movie)
  end
end


When /^I have opted to see movies rated: "(.*?)"$/ do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  #pending  #remove this statement after implementing the test step
  Movie.all_ratings.each do |rating|
      uncheck "ratings_#{rating}"
  end  
  rating_list.split(', ').each do |rating|
      check "ratings_#{rating}"
  end
end 

When /^(?:|I )press "([^\"]*)"$/ do |button|
  click_button(button)
end

Then /^I should see only movies rated: "(.*?)"$/ do |rating_list|
  #pending  #remove this statement after implementing the test step
  step "I press \"Refresh\""
  ratings = rating_list.split(", ")
  ratings.each do |r|
    regex = Regexp.new("(^#{r}$)")
    page.should have_xpath('//td',:text=>regex)
  end
  unratings=Movie.all_ratings-ratings
  unratings.each do |r|
    #regex = Regexp.new("(^#{r}$)")
    page.should_not have_xpath('//td',:text=>/^(#{r})$/)
  end
end

Then /^I should see all of the movies$/ do
  #pending  #remove this statement after implementing the test step
    Movie.all_ratings.each do |rating|
    step "I have opted to see movies rated: \"#{rating}\"" 
  end
end

When /^(?:|I )press link "([^\"]*)"$/ do |link|
  click_link(link)
end


And /^I should see "([^"]*)" before "([^"]*)"$/ do |phrase_1, phrase_2|
  first_position = page.body.index(phrase_1)
  second_position = page.body.index(phrase_2)
  first_position.should < second_position
end