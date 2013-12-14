require_relative 'usernames'
require_relative 'subjects'


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# If there are less members than this, add enough members to get to this total
MINIMUM_MEMBERS_COUNT = 600    

# Some of the members will have a randomly-chosen member as their referrer
# 1.0 = 100% chance of trying to populate the member_id_referred field
# 0.0 = 0% chance of trying to populate the member_id_referred field
CHANCE_OF_MEMBER_BEING_REFERRED = 0.25

# If less than this many mods exist, we'll make this many members mods.
MINIMUM_NUMBER_OF_MODS = 15

# The random members we create will have an age between MEMBER_MAX_AGE_YEARS and MEMBER_MIN_AGE_YEARS  
MEMBER_MAX_AGE_YEARS = 45.0
MEMBER_MIN_AGE_YEARS = 18.0

# Number of threads to create 
THREADS_TO_CREATE = 25
REPLIES_PER_THREAD = [0,0,0,0,0,0,1,1,1,2,2,2,2,2,2,3,3,3,4,4,5,5,6,7,8,9,10,11,12,13,14,20,40,60,80]
POSTS_TO_MODERATE = 50

# Max number of paragraphs, and max number of sentences gener each forum post
# We specify an array instead of a simple range so we can do weighting
# Weighting is good because there should be more 1-paragraph posts than 8-paragraph posts
PARAGRAPHS_PER_FORUM_POST = [1,1,1,2,2,2,3,3,4,4,5,6,7,8]
SENTENCES_PER_FORUM_POST_PARAGRAPH = [1,2,2,3,4,5]

# Todo: get the number from the Post model rather than a hard coded constant
MAX_POST_LENGTH_CHARACTERS = 8000


def markov_text(number_of_sentences, number_of_paragraphs, markov, max_length)
  body = ''
  (1..number_of_paragraphs.sample).each { |p| 
    body << (p > 1 ? "\n\n" : '') << markov.generate_n_sentences(number_of_paragraphs.sample)
  }
  while (body.length < 10)
    # kludge! not sure why it returns too little sometimes
    body << ' ' << markov.generate_1_sentences 
  end
  body = [0..max_length-1] if body.length > max_length
  body
end

def seed_genders
  puts "Seeding genders"
  Gender.create({id: 1, gender_description: 'Male', gender_abbreviation: 'M'}) if !Gender.find(1)
  Gender.create({id: 2, gender_description: 'Female', gender_abbreviation: 'F'}) if !Gender.find(2)
  Gender.create({id: 3, gender_description: "It's complicated", gender_abbreviation: ''}) if !Gender.find(3)
end 

def seed_forums
  puts "Seeding forums"

  forums = [
    {name: 'Events', display_order: 20},
    {name: 'Look What I Made', display_order: 30},
    {name: 'Sex & Relationships', display_order: 40},
    {name: 'Video Games', display_order: 50},
    {name: 'Tabletop Gaming', display_order: 60},
    {name: 'Cooking, Baking, Dining', display_order: 70},
    {name: 'Deals', display_order: 80},
    {name: 'TV Series', display_order: 90},
    {name: 'Movies', display_order: 100},
    {name: 'Anime & Manga', display_order: 110},
    {name: 'Half Savage Coders', display_order: 120},
    {name: 'Crafting', display_order: 130},
    {name: 'Introductions', display_order: 140},
    {name: 'Confessions & Rants', display_order: 150},
    {name: 'Health & Fitness', display_order: 160},
    {name: 'Suggest New Forum', display_order: 170},
    {name: 'Site Issues / Meta', display_order: 180},
    {name: 'Moderator Discussion', display_order: 999, is_visible_to_public: false, is_moderator_only: true},
  ]

  forums.each { |f|
    Forum.create(f) if !Forum.find_by_name(f[:name])
  }
end 

def add_likes_to_post(post)
  # Maybe add some likes...
  num_likes = [0,1,1,1,1,5,5,5,10,10,20].sample + rand(0..3)
  print "(#{num_likes} likes)"
  1.upto(num_likes) do 
    like = Like.new(
      post: post,
      member: Member.order("RANDOM()").first,
      created_at: Time.at((Time.now.to_f - post.created_at.to_f)*rand + post.created_at.to_f)
    )
    #debugger
    begin
      like.save
    rescue
    end
  end 

end 

####################
# Populate members #
####################

def create_member

  hs_usernames = HalfSavageUserNames.new
  
  new_member = Member.new(
    :gender => Gender.find([1,1,1,1,2,2,2,3].sample),
    :password => 'password',
    :date_of_birth => Time.now - (60*60*24*365)*rand(MEMBER_MIN_AGE_YEARS..MEMBER_MAX_AGE_YEARS),
    :created_at => Time.now - (60*60*24)*rand(1..700) # between 1 and 700 days ago
  )

  # Keep trying until we get a unique username + email
  begin 
    case new_member.gender.id 
    when 1
      new_member.username = hs_usernames.generate(:male) 
    when 2 
      new_member.username =  hs_usernames.generate(:female)
    when 3
      new_member.username = hs_usernames.generate(:neutral)
    end
    new_member.email = new_member.username.gsub(/[^a-zA-Z0-9-]/,'') + '-' + rand(1..999999).to_s + '@halfsavage.com'
  end while Member.find_by_username(new_member.username) || Member.find_by_email(new_member.email) || new_member.username.length < 5

  # For some members, give them a referring member
  if rand(0.0..1.0) <= CHANCE_OF_MEMBER_BEING_REFERRED then
    new_member.referred_by = Member.where("created_at < ?", new_member.created_at).order("RANDOM()").first  
  end
  
  if !new_member.valid? then 
    puts "\nMember can't be saved."
    puts new_member
    new_member.errors.each{|attr,err| puts "  #{attr} : #{err}" }
  else 
    new_member.save
  end   
 
  new_member
end

#####################
# Create Moderators #
#####################

def create_moderators(number_of_mods_desired)
  number_of_mods = Member.moderators.length
  puts "#{number_of_mods} mods in database; minimum desired is #{MINIMUM_NUMBER_OF_MODS}."
  if (number_of_mods) < MINIMUM_NUMBER_OF_MODS then
    print "Making #{MINIMUM_NUMBER_OF_MODS - number_of_mods} moderators... "
    new_mods = Member.where(!:is_moderator).order("RANDOM()").take(MINIMUM_NUMBER_OF_MODS - number_of_mods)
    new_mods.each { |m|
      print "#{m.username} "
      #debugger
      if (m.valid?)
        m.update(is_moderator: true)
      else 
        puts "\nMember can't be saved."
        puts m
        m.errors.each{|attr,err| puts "  #{attr} : #{err}" }
      end
    }
    puts "done"
  else 
    puts "No need to create any moderators."
  end 
  new_mods
end 


# Returns the markov dictionary
# Will open existing or create new

def initialize_markov
  dictionary_path = Rails.root.join('db').to_s + '/markov_dictionary'
  dictionary_path_full = dictionary_path + '.mmd'

  # When there are problems, MarkyMarkov leaves a 0-byte file that we should delete
  File.delete(dictionary_path_full) if File.size?(dictionary_path_full)==0

  if File.exists?(dictionary_path_full) then 
    puts "Reading existing Markov dictionary #{dictionary_path}.mmd."
    puts "If you ever want to regenerate the dictionary, delete this file and it will be repopulated on the next run."
    markov = MarkyMarkov::Dictionary.new(dictionary_path)
  else 
    puts "Generating Markov chains, saving to #{dictionary_path}.mmd"
    markov = MarkyMarkov::Dictionary.new(dictionary_path)
    Dir.glob(Rails.root.join('db','markov_training_text','*.txt')) { |f| 
      puts "...parsing #{f} "; 
      # Marky Markov can read & parse the files directly with markov.parse_file, but it doesn't handle 
      # invalid characters. So we do it "manually" and pass in the fixed string
      text = File.read(f)
      text.encode!('ASCII-8BIT','utf-8', :invalid => :replace, :undef => :replace, :replace => '')
      markov.parse_string(text) 
    }
    markov.save_dictionary!
  end 

  markov
end 

# Creates & saves a single forum thread, with replies

def create_forum_thread(markov, prolific_members)
  
  # Get the forums
  public_forums = Forum.active_public
  mod_forums = Forum.active_moderator

  post = Post.new({ body: '', subject: HalfSavageSubjects.random_subject })

  # Approx 50% of the posts will come from the group of "prolific members"
  if rand(0..1) == 1 
    post.member = prolific_members.sample
  else 
    post.member = Member.order("RANDOM()").first
  end 

  # creation time is some time between "now" and when this member joined
  post.created_at = Time.at((Time.now.to_f - post.member.created_at.to_f)*rand + post.member.created_at.to_f)

  # Choose forum. Some (not many) posts will be in more than one forum
  # If it's a mod, maybe they're posting in the mod forum?
  if post.member.is_moderator then
    post.forums << (public_forums + mod_forums).sample([1,1,1,1,1,1,1,1,2].sample)
  else 
    post.forums << public_forums.sample([1,1,1,1,1,1,1,1,2].sample)
  end

  # Create a number of sentenses and paragraphs
  post.body = markov_text(SENTENCES_PER_FORUM_POST_PARAGRAPH, PARAGRAPHS_PER_FORUM_POST, markov, MAX_POST_LENGTH_CHARACTERS)
  post.save!
  
  # Generate replies to this thread
  num_replies = REPLIES_PER_THREAD.sample + rand(-5..5)
  num_replies = 0 if num_replies < 0
  print " Replies: #{num_replies} "

  add_likes_to_post(post) if rand(0..10) < 3
  
  (1..num_replies).each { |j|
    reply = Post.new( { parent: post } )
    
    # Like above, 50% of the posts will come from the prolific members
    # TODO: Only pick members whose accounts were created after this thread was made

    if rand(0..100) < 50 
      eligible_members = prolific_members.select {|pm| pm.created_at > post.created_at}
      reply.member = eligible_members.sample
    end 

    if reply.member.nil? 
      reply.member = Member.order("RANDOM()").first
    end 

    # Some moderator replies should be in moderator voice
    if reply.member.is_moderator then 
      case rand(0..15)
      when 1  
        reply.is_public_moderator_voice = true 
        print 'm'
      when 2 
        reply.is_private_moderator_voice = true
        print 'm'
      end 
    else 
      print '.'
    end 


    # Create a number of paragraphs & sentences. Put a couple of line breaks in front if it's the first sentence in a paragraph
    reply.created_at = Time.at((Time.now.to_f - post.created_at.to_f)*rand + post.created_at.to_f)
    reply.body = markov_text(SENTENCES_PER_FORUM_POST_PARAGRAPH, PARAGRAPHS_PER_FORUM_POST, markov, MAX_POST_LENGTH_CHARACTERS)
    reply.save!
    add_likes_to_post(reply) if rand(0..10) < 3
  } 
end


##################
# Create members #
##################

puts "Currently #{Member.count} members."
if (Member.count < MINIMUM_MEMBERS_COUNT) then  
  puts "Creating #{MINIMUM_MEMBERS_COUNT-Member.count} member(s) to get up to #{MINIMUM_MEMBERS_COUNT}"
  1.upto(MINIMUM_MEMBERS_COUNT-Member.count) do |i|
  print " #{i}... " if i % 10 == 0
    create_member
  end
end

#####################
# Threads & Replies #
#####################

markov = initialize_markov

# These 10% of the members represent the most prolific posters. We also assume the mods are "prolific" 
# We do this because in reality, most posts come from a small minority of members.
prolific_members = Member.order("RANDOM()").take(Member.count / 10) + Member.moderators
  
puts "Creating #{THREADS_TO_CREATE} threads(s)"
print "Key:  . = reply   m = mod reply"
(1..THREADS_TO_CREATE).each { |i|
  print "\n[Thread #{i}] "
  create_forum_thread(markov, prolific_members)
}

puts " done creating threads and replies"
