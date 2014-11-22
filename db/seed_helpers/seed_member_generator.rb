require_relative "weighted_seed_city_generator"

class SeedMemberGenerator

    def self.array_from_file(path)
      a = []
      File.open(path, 'r') do |f1|
        while line = f1.gets
          a << line.chomp
        end
      end
      a
    end 

    @@male_names = array_from_file('db/seed_helpers/male_names.txt') 
    @@female_names = array_from_file('db/seed_helpers/female_names.txt') 
    @@neutral_names = array_from_file('db/seed_helpers/neutral_names.txt') 

    @@male_portraits = [1,3,5,7,8,9,10,12,15,16,17,18,19]
    @@female_portraits = [2,4,6,7,8,11,13,14,17,20]
    @@neutral_portraits = [7,8,9,17,16]
    
    def self.random_name(gender_id)
      case gender_id 
      when 1
        return @@male_names.sample
      when 2 
        return @@female_names.sample
      when 3
        return @@neutral_names.sample
      end
    end 

    def self.generate(hs_usernames, gender, min_age_years, max_age_years, max_account_age_days, chance_of_member_referral, chance_of_being_paid, chance_of_having_first_name)
      new_member = Member.new(
        :gender => gender,
        :password => 'password',
        :date_of_birth => Time.now - (60*60*24*365)*rand(min_age_years..max_age_years),
        :created_at => Time.now - (60*60*24)*rand(1..max_account_age_days) # between 1 and 700 days ago
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
      end while (new_member.username.length < 5) || (new_member.username.length > 30)

      # For some members, give them a referring member
      if rand(0.0..1.0) <= chance_of_member_referral then
        new_member.referred_by = Member.where("created_at < ?", new_member.created_at).order("RANDOM()").first
      end

      new_member.first_name = random_name(new_member.gender_id) if rand(0.0..1.0) <= chance_of_having_first_name
      new_member.paid = (rand < chance_of_being_paid)

      # 80% of them get fake portraits 
      if rand < 0.8 then 
        case new_member.gender.id 
        when 1 
          new_member.fake_portrait = @@male_portraits.sample 
        when 2 
          new_member.fake_portrait = @@female_portraits.sample 
        when 3
          new_member.fake_portrait = @@neutral_portraits.sample 
        end 
      end 

      if !new_member.valid? then
        #puts "\nMember can't be saved."
        #puts new_member
        #new_member.errors.each{|attr,err| puts "  #{attr} : #{err}" }
      else
        new_member.save
      end


      # 80% of them get addresses
      if rand < 0.8 then 
        city = WeightedSeedCityGenerator.get_weighted_random_city
        Address.create!(
          city: city.name,
          country: city.country,
          region: city.region,
          latitude: city.latitude,
          longitude: city.longitude,
          member: new_member
        )
      end 

      # 80% of them view some profiles 
      profile_view_thread = Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          if rand < 0.8 then 
            Member.order('RANDOM()').where('id<>?', new_member.id).take(rand(0..25)).each do |viewed_member| 
              pv = ProfileView.new({
                viewed_member: viewed_member,
                member: new_member,
                tally: rand(1..50),
                created_at: rand([viewed_member.created_at, new_member.created_at].max .. Time.now)
                })
              pv.updated_at = rand(pv.created_at .. Time.now) if pv.tally > 1 
              pv.save!
            end 
          end 
        end
      end

      relationship_thread = Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do

          # 50% of them get friends
          if rand < 0.5 then 
            Member.order("RANDOM()").where('id<>?', new_member.id).take(rand(1..50)).each do |other_member|
      
              begin 
                Relationship.create!({
                  member: new_member, 
                  related_member: other_member,
                  friend: true
                  })
              rescue ActiveRecord::RecordNotUnique => e
              end 

              # 50% of them should friend back
              if rand < 0.5 then 
                
                begin 
                  # some of these will fail - particularly the first 
                  # couple of hundred members because we'll get dupes... that's OK, it's just fake data
                  Relationship.create({
                    member: other_member,
                    related_member: new_member,
                    friend: true
                    })
                rescue ActiveRecord::RecordNotUnique => e
                end 
              end 

            end 
          end 
        end
      end

      profile_view_thread.join
      relationship_thread.join
      
      nil
    end

end 