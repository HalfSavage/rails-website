require_relative 'usernames-seeding'
require_relative 'subjects-seeding'
require_relative 'messages-seeding'

# If there are less members than this, add enough members to get to this total
MINIMUM_MEMBERS_COUNT = 600

# When we create a new fake member, their created_at will be set to 
# between 1 and MAX_MEMBER_ACCOUNT_AGE_DAYS. (So it doesn't look like 158795 members)
# joined on the same goddamn day
# N.B. - this is the age of their ACCOUNT, not their age as human beings
MAX_MEMBER_ACCOUNT_AGE_DAYS = 700

# Some of the members will have a randomly-chosen member as their referrer
# 1.0 = 100% chance of trying to populate the member_id_referred field
# 0.0 = 0% chance of trying to populate the member_id_referred field
CHANCE_OF_MEMBER_BEING_REFERRED = 0.25

# If less than this many mods exist, we'll make this many members mods.
MINIMUM_MOD_COUNT = 25

# The random members we create will have an age between MEMBER_MAX_AGE_YEARS and MEMBER_MIN_AGE_YEARS
MEMBER_MAX_AGE_YEARS = 45.0
MEMBER_MIN_AGE_YEARS = 18.0
 
# No, it's not about the quality of your bedsheets.
# If there are less than MINIMUM_THREAD_COUNT messages, 
# create enough to get up to this total
MINIMUM_THREAD_COUNT = 500

# We call .sample on this array to figure out how many fake replies get attached 
# to each fake thread. We use an array instead of a simple range because we want
# to heavily weight things towards *few* replies... most threads have only a few 
# replies; only a tiny number of threads will have a true shit load of replies.
REPLIES_PER_THREAD = [0,0,0,0,0,0,1,1,1,2,2,2,2,2,2,3,3,3,4,4,5,5,6,7,8,9,10,11,12,13,14,20,40,60,80]

# Max number of paragraphs, and max number of sentences gener each forum post
# We specify an array instead of a simple range so we can do weighting
# Weighting is good because there should be more 1-paragraph posts than 8-paragraph posts
PARAGRAPHS_PER_FORUM_POST = [1,1,1,2,2,2,3,3,4,4,5,6,7,8]
SENTENCES_PER_FORUM_POST_PARAGRAPH = [1,2,2,3,4,5]

# Todo: get the number from the Post model rather than a hard coded constant
MAX_POST_LENGTH_CHARACTERS = 8000

# How many Markov chain gibberish sentences to create. Post bodies will be populated with these.
MARKOV_SENTENCES_TO_GENERATE = 500

# If there are less private messages than this, create enough private messages to get to this total
MINIMUM_PRIVATE_MESSAGES_COUNT = 500

def markov_text(number_of_sentences, number_of_paragraphs, markov_sentences, max_length)
  body = ''
  (1..number_of_paragraphs.sample).each { |p|
    body += "\n\n" if p>1
    (1..number_of_sentences.sample).each { |s|
      body << markov_sentences.sample
    }
  }
  while (body.length < 10)
    # kludge! not sure why it returns too little sometimes
    body << ' ' << markov_sentences.sample
  end
  body = [0..max_length-1] if body.length > max_length
  body
end

def seed_post_action_types
  puts "Seeding post action types"
  PostActionType.create({id: 1, name: 'Flagged for moderator review', moderator_only: false, active: true, note_required: false}) if !PostActionType.find_by_id(1)
  PostActionType.create({id: 2, name: 'Clear moderator review flag', moderator_only: true, active: true, note_required: true}) if !PostActionType.find_by_id(2)
  PostActionType.create({id: 3, name: 'Deleted', moderator_only: true, active: true, note_required: true}) if !PostActionType.find_by_id(3)
  PostActionType.create({id: 4, name: 'Undeleted', moderator_only: true, active: true, note_required: true}) if !PostActionType.find_by_id(4)
end 

def seed_genders
  puts "Seeding genders"
  Gender.create({id: 1, gender_description: 'Male', gender_abbreviation: 'M'}) if !Gender.find_by_id(1)
  Gender.create({id: 2, gender_description: 'Female', gender_abbreviation: 'F'}) if !Gender.find_by_id(2)
  Gender.create({id: 3, gender_description: "It's complicated", gender_abbreviation: ''}) if !Gender.find_by_id(3)
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

def seed_message_types
  puts "Seeding message types"
  MessageType.create({id: 1, name: 'Private Message'}) if !MessageType.find_by_id(1)
end

def add_likes_to_post(post)
  # Maybe add some likes...
  num_likes = [0,1,1,1,1,5,5,5,10,10,20].sample + rand(0..3)
  #print "(#{num_likes} likes)"
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

def create_member(hs_usernames, gender)
  new_member = Member.new(
    :gender => gender,
    :password => 'password',
    :date_of_birth => Time.now - (60*60*24*365)*rand(MEMBER_MIN_AGE_YEARS..MEMBER_MAX_AGE_YEARS),
    :created_at => Time.now - (60*60*24)*rand(1..MAX_MEMBER_ACCOUNT_AGE_DAYS) # between 1 and 700 days ago
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
  end while Member.find_by_username(new_member.username) || Member.find_by_email(new_member.email) || (new_member.username.length < 5) || (new_member.username.length > 30)

  # For some members, give them a referring member
  if rand(0.0..1.0) <= CHANCE_OF_MEMBER_BEING_REFERRED then
    new_member.referred_by = Member.where("created_at < ?", new_member.created_at).order("RANDOM()").first
  end

  if !new_member.valid? then
    puts "\nMember can't be saved."
    puts new_member
    debugger
    new_member.errors.each{|attr,err| puts "  #{attr} : #{err}" }
  else
    new_member.save
  end
  new_member
end

###########################
# Create Private Messages #
###########################

def create_private_message(hs_messages, earliest_possible_message_time, latest_possible_message_time, should_be_reply_to_post)
  if should_be_reply_to_post then 
    post = Post.where('created_at > ? and created_at < ?', earliest_possible_message_time, latest_possible_message_time).order("RANDOM()").first 
    message_created_at = Time.at((latest_possible_message_time.to_f - [earliest_possible_message_time, post.created_at].min.to_f)*rand + [earliest_possible_message_time, post.created_at].min.to_f)

    new_message = Message.new(
      :post => post,
      :message_type => MessageType.find(1),

      :body => hs_messages.get_private_message_post_reply_body(1..5)
    )
    new_message.member_to = post.member
    new_message.member_from = Member.where('created_at > ?', message_created_at).order("RANDOM()").first
  else 
    message_created_at = Time.at((latest_possible_message_time.to_f - earliest_possible_message_time.to_f)*rand + earliest_possible_message_time.to_f)    
    # Get 2 members who created their accounts before this message
    members = Member.where('created_at > ?', message_created_at).order("RANDOM()").take(2)

    new_message = Message.new( 
      # pick a time for this message to have been "created"...
      # ...random time between earliest_possible_message_time and right now
      :created_at => message_created_at, 
      :message_type => MessageType.find(1),
      :member_from => members[0],
      :member_to => members[1],
      :body => hs_messages.get_private_message_body(1..5)
    )
  end 

  # Roll the dice. Was this message seen, and when? (Most messages should be seen already)
  if rand(5)<4 then 
    new_message.seen = Time.at((Time.now.to_f - new_message.created_at.to_f)*rand + new_message.created_at.to_f)
  end

  if new_message.member_from.is_moderator and rand(2)==0 then 
    new_message.is_moderator_voice = true
  end 

  if !new_message.valid? then 
    puts "\nMessage can't be fucking saved!"
    puts new_message
    new_message.errors.each{|attr,err| puts "  #{attr} : #{err}" }
    debugger
    puts '...sorry'
  else 
    new_message.save
  end 
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


# Returns an array of markov sentences
# Will open existing files or create new ones

def get_markov_sentences
  dictionary_path = Rails.root.join('db').to_s + '/markov_dictionary'
  dictionary_path_full = dictionary_path + '.mmd'
  sentences_path = Rails.root.join('db').to_s + '/markov_sentences.txt'

  # When there are problems, MarkyMarkov leaves a 0-byte file that we should delete
  File.delete(dictionary_path_full) if File.size?(dictionary_path_full)==0

  if File.exists?(dictionary_path_full)
    puts "Reading existing Markov dictionary #{dictionary_path}.mmd."
    puts 'If you ever want to regenerate the dictionary, delete this file and it will be repopulated on the next run.'
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

  fart=[]
  if File.exists?(sentences_path)
    File.open(sentences_path, 'r') do |f1|
      while line = f1.gets
        fart << line
      end
    end
  else
    File.open(sentences_path,'w') do |f2|
      print "Generating #{MARKOV_SENTENCES_TO_GENERATE} sentences of Markov chain text"
      (1..MARKOV_SENTENCES_TO_GENERATE).each { |i|
        print '.' if i % 10 == 0
        s = markov.generate_1_sentences
        fart << s
        f2.puts s
      }
      puts ''
    end
  end

  fart
end

# Creates & saves a single forum thread, with replies

def create_forum_thread(markov_sentences, prolific_members, moderators)

  # Get the forums
  public_forums = Forum.active_public
  mod_forums = Forum.active_moderator

  hs_subjects = HalfSavageSubjects.new

  post = Post.new({ body: '', subject: hs_subjects.random_subject })

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

  # TODO: chance of attaching a picture

  # Create a number of sentenses and paragraphs
  post.body = markov_text(SENTENCES_PER_FORUM_POST_PARAGRAPH, PARAGRAPHS_PER_FORUM_POST, markov_sentences, MAX_POST_LENGTH_CHARACTERS)
  post.save!

  # Generate replies to this thread
  num_replies = REPLIES_PER_THREAD.sample + rand(-5..5)
  num_replies = 0 if num_replies < 0
  #print " Replies: #{num_replies} "

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
        #print 'M'
      when 2
        reply.is_private_moderator_voice = true
        #print 'm'
      else
        #print '.'
      end
    else
      #print '.'
    end

    # TODO: chance of attaching a picture

    # Create a number of paragraphs & sentences. Put a couple of line breaks in front if it's the first sentence in a paragraph
    reply.created_at = Time.at((Time.now.to_f - post.created_at.to_f)*rand + post.created_at.to_f)
    reply.body = markov_text(SENTENCES_PER_FORUM_POST_PARAGRAPH, PARAGRAPHS_PER_FORUM_POST, markov_sentences, MAX_POST_LENGTH_CHARACTERS)
    reply.save!
    add_likes_to_post(reply) if rand(0..10) < 3
  }
end


#######################
# Seed various tables #
#######################

puts "*** Seeding Random Bullshit ***"
seed_forums
seed_genders
seed_message_types
seed_post_action_types
puts ""

##################
# Create members #
##################

puts '*** Seeding fake members ***'
puts "Currently have #{Member.count} members; we'd like to have at least #{MINIMUM_MEMBERS_COUNT}."
puts "Change MINIMUM_MEMBERS_COUNT in db/seeds.rb if you'd like a different value here."
if (Member.count >= MINIMUM_MEMBERS_COUNT) then
  puts "Ok, we have plenty of fake members. Moving along."
else
  puts "Creating #{MINIMUM_MEMBERS_COUNT-Member.count} member(s) to get up to #{MINIMUM_MEMBERS_COUNT}"
  male = Gender.find(1)
  female = Gender.find(2)
  complicated = Gender.find(3)
  hs_usernames = HalfSavageUserNames.new
  1.upto(MINIMUM_MEMBERS_COUNT-Member.count) do |i|
  hs_usernames = HalfSavageUserNames.new if i % 50 == 0
  print " #{i}... " if i % 10 == 0
    create_member hs_usernames, [male, male, male, female, female, female, complicated].sample
  end
end
current_moderator_count = Member.moderators.count 
if (current_moderator_count >= MINIMUM_MOD_COUNT)
  puts "Okay, we have plenty of mods (#{current_moderator_count} of #{MINIMUM_MOD_COUNT}). Moving along."
else
  some_losers = Member.where("is_moderator=false").order("RANDOM()").take(MINIMUM_MOD_COUNT - current_moderator_count)
  print "Making #{some_losers.count} into mods... "
  some_losers.each { |loser| 
    loser.is_moderator = true
    loser.save!
  }
  puts "done"
end 

#####################
# Threads & Replies #
#####################

puts '\n*** Seeding fake forum threads & replies ***'
current_thread_count = Post.threads.count 
puts "Currently have #{current_thread_count} threads; we'd like to have at least #{MINIMUM_THREAD_COUNT}."
puts "Change MINIMUM_THREAD_COUNT in db/seeds.rb if you'd like a different value here."

if (current_thread_count >= MINIMUM_THREAD_COUNT) then 
  puts "Ok, we have plenty of fake threads. Moving along."
else
  puts "Creating #{MINIMUM_THREAD_COUNT - current_thread_count} threads."
  markov_sentences = get_markov_sentences
  
  # These 10% of the members represent the most prolific posters. We also assume the mods are "prolific"
  # We do this because in reality, most posts come from a small minority of members.
  prolific_members = Member.order("RANDOM()").take(Member.count / 10) + Member.moderators

  #print "Key:  . = reply   m = mod reply"
  (1..(MINIMUM_THREAD_COUNT - current_thread_count)).each { |i|
    #print "\n[Thread #{i}] "
    print "#{i}... " if i % 10 == 0
    create_forum_thread(markov_sentences, prolific_members, Member.moderators)
  }
  puts " done creating threads and replies"
end

####################
# Private Messages #
####################

puts '\n*** Seeing fake private messages ***'
current_message_count = Message.count 

puts "Currently have #{current_message_count} private messages; we'd like to have at least #{MINIMUM_PRIVATE_MESSAGES_COUNT}."
puts "Change MINIMUM_PRIVATE_MESSAGES_COUNT in db/seeds.rb if you'd like a different value here."

if (current_message_count >= MINIMUM_PRIVATE_MESSAGES_COUNT) then 
  puts "Ok, we have plenty of fake private messages."
else 
  puts "Creating #{MINIMUM_PRIVATE_MESSAGES_COUNT - current_message_count} fake private messages."
  hs_messages = HalfSavageMessages.new 
  # the earliest time at which the fake messages' created_at time should be set
  # take the 5th-oldest account's created_at time.... yeah this is arbitrary
  # and will throw an error if there are less than 5 member accounts
  earliest_message_time = Member.order("created_at").take(5)[4].created_at  
  latest_message_time = Member.order("created_at desc").take(5)[4].created_at
  
  (1..(MINIMUM_PRIVATE_MESSAGES_COUNT - current_message_count)).each { |i|
    print "#{i}... " if (i == 1) || (i % 10 == 0) 
    hs_messages = HalfSavageMessages.new  if (i % 25 == 0)
    create_private_message(hs_messages, earliest_message_time, latest_message_time, (rand(4)==0))
  }
  puts " done creating fake messages"
end 
puts ''
