# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Halfsavage::Application.initialize!

# TODO: Should configuration information really go into this file?
Rails.configuration.forum_threads_per_page = 20
Rails.configuration.discussion_slug_length = 50