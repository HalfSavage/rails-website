# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Halfsavage::Application.initialize!

# TODO: Should configuration information really go into this file?
Rails.configuration.discussions_per_page = 20
Rails.configuration.posts_per_page = 10
Rails.configuration.discussion_slug_length = 50