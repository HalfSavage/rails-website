require 'active_support/core_ext/string'

class Hash 
  def sample_gendered(gender)
    return self.take_gendered(gender).sample
  end 

  def take_gendered(gender)
    result = self[:neutral] || ['Awesome','Random','Funny']
    result += self[:male] if ((gender==:male || gender==:any) && self[:male])
    result += self[:female] if ((gender==:female || gender==:any) && self[:female])
    return result
  end 
end 
 
class HalfSavageUserNames
  @@MAX_DIE_ROLL = 160

  @@properties = {
    :neutral => ['Rescue Rangers', 'Hunter x Hunter','Star Wars','Gundam','Evangelion','My Little Pony','Lord of The Rings','Pokemon','Call Of Duty','Final Fantasy','Dragon Quest','Cosby Show','Dukes of Hazzard','Twilight','Back To The Future','Sweet Valley High','Star Trek','One Piece','Hellsing', 'Trigun', 'Firefly', 'Marvel']
  }
  @@characters = {
    :male => %w{Snape Dumbledore Naruto Lando Aragorn Draco Severus Littlefinger Batman Khal Davos Hodor Gendry Renly Theon Joffrey Han Tyrion Tywin Rock\ Lee Jabba Sasuke Akamaru Shino Choji Shikamaru Guy Spiderman Davros Sherlock Oberyn},
    :female => %w{Snow\ White Morticia Hermione Galadrial Michonne Willow Cinderella Princess\ Jasmine Mulan Ygritte Katniss Zelda Samus Daisy Wonder\ Woman Khaleesi Cersei Marceline Arya Hinata Ino Shizune Eowyn Sabrina Arwen Merida Ariel Belle Bubblegum},
    :neutral => %w{Robo} # couldn't find gender-neutral sci-fi characters! sorry!
	}
  @@relationship = {
    :male => %w{brother dad husband boyfriend},
    :female => %w{bitch mom sister wife girlfriend},
    :neutral => %w{teacher professor slut slave fuckbuddy lovechild bestie}
  }
  @@character_last_names = {
    :neutral => %w{Potter Skywalker Lovegood Targaryen Diggle Slytherin Hufflepuff Weasley Drogo Stark Greyjoy Lannister Bolton Baratheon Martell Tully Tyrell Uzumaki Martell }
  }
  @@verbs_past = {
    :neutral => ["crushing on","loving","obsessed with","masturbating to","lovesick for", "killed by", "smitten by", "bedazzled by", "fondled by", "loved by", "stalked by", "touched by", "fucked by", "loved by", "hated by"]
  }
  @@verbs_personal = {
    :neutral => %w{penetrate pimp shag screw stroke titfuck romance butter delight excite cockblock deepthroat fist masturbate bless cuddle titillate canoodle fingerbang hug comfort diddle fingerblast marry punch relate\ to love neuter worship excite gangbang jizz lubricate muffdive nippletwist touch praise yell\ at}
  }
  @@names = {
    :male => %w{Booby Hideo Akira Ichiro Masashi Yoshi Toshio Kaz Hideo Jimmy Jimbo  Jake Julian Ari Todd Angus Kendrick Finn Jordan  Boba Achilles Ned Jeremy Luke Mark Abdul Gregg Geoff Rolando Marco Yuri Zack},
    :female => %w{Akiko Eri Hitomi Sachiko Mari Kimiko Noriko Yumiko Loretta Riley Ivy Clarissa Sapphire Alice Alicia Cheri Jayla Rosie Robyn Trixie Denise Helena Margaery Sherri Scarlett Lily Sophie Sadia Arya Amelia Emma Felicia Emily Skye Elizabeth Liz  Lana Betsy Gina Annie Beth Cindy Deidre Debbie Rikki Roni Aimee },
    :neutral => %w{Dakota Justic Jaylin Jessie Jamie Casey Skyler Riley Amari River Quinn Dallas Taylor Dylan}
  }
  @@prefixes = {
    :neutral => %w{Crazy Battle Darth Knockout Killer Space Sexy Sailor Galactic Zombie Bloodthirsty Infamous Master Famous Sexyface Poke\ Trainer Drunk Sexy Sizzlin' Unruly Doctor Captain General Super Robo Ninja Dat Master Funky Mad Pope M.C. },
    :male => %w{Count Hardball Touchdown Chief King Prince Baron\ Von Duke Emperor Mister His\ Highness Cowboy Daddy},
    :female => %w{Countess Queen Abby Princess Empress Miss Cowgirl Angel Her\ Highness}
  }
  @@places = {
    :neutral => %w{Endor Bolivia Nantucket Hogwarts Houston Phoenix Austin Columbus Ohio Texas California Detroit Chicago Winterfell Highgarden Tatooine  New\ York Los\ Angeles Mars Venus Andromeda Pluto Neptune Uranus Saturn Jupiter}
  }
  @@ethnicities = { 
    :neutral => %w{Russian English Scottish Japanese Kashmiri Arabic Gaelic Bulgarian Croatian American French Turkish Tibetan Yiddish Kurdish Mandarin Mayan Greek Welsh Swedish Norweigian Icelandic Dothraki Welsh Gallifrian}
  }
  @@nouns = {
    :neutral => %w{Wombat Handjob Blowjob Neckbeard WeebleWobble Nippletwister Handjob Unicorn Microchip Crime\ Lord Heart\ Attack Samurai Reporter Swimmer Puppy Firewall Abortion Trainwreck Hobo Whippersnapper Firecracker Laser Cupcake Pulsar Vampire Jedi Ninja Psychopath Dingbat Warrior Comet Meteor Nipplekicker Bellhop Chef Dancer Drummer Firefighter MammaJamma Falconer Flutist Gardener Lunatic Student Jester Janitor Linguist Magician Locksmith Miner Monk},
    :male => %w{Guy Dude Chump He-Man Asshole Hunk General Sargeant},
    :female => %w{Girl Woman Angel Maiden Vixen Mouse Princess General Commander}
  }
  @@adjectives = {
    :neutral => %w{Sexual Spicy Flaming\ Hot Magical Negative Nasty Punctual Pepperoni-Flavored Quiet Quizzical Querulous Ribald Rip\ Roaring Rectal Relaxed Shocking Stupendous Turbulent Turgid Techno Unbeatable Unbeatable Valuable Wasteful Wistful Wonderful Whopping Masked Dangerous Golden Silver Persnickity Sexy Dirty Deep\ Dick Delightful Sleepy Fabulous Abstract Amazing Austistic Buff Crazy Cranky Crafty Dingbat Devious Diabolical Easy-Goin' Erotic Exciting Fab Fabulous Fiery Flashy Funny Gloomy Gentle Galloping Hotheaded Hella\ Cool Persnickity Peevish Sassy Saucy Sloppy Timid Testy Touchy-Feely Inglorious Icky Spicy },
    :male => %w{Brawny Dashing 'Inappropriately Erect'},
    :female => %w{Dainty Fertile Angelic Fertile Fluttering}
  }
  @@puns_and_cliches = {
    :neutral => ["Outta My Face", "Big Bad", "Shot In The Arm", "Big Fish Small Pond", "Blaze A Trail", "Bad Hair Day", "Happy As A Clam", "Bury The Hatchet", "Catch22", "Funny Farm", "Flavor Of The Month", "Fancy Pants", "Face The Music", "Go Haywire", "Axe To Grind", "Jump The Shark", "Jury Still Out", "Kangaroo Court", "Lose My Marbles", "Take The Cake", "Spin Doctor", "Spill The Beans",  "Greased Lightning", "Bad Turn", "Hooked On You", "Blue In The Face", "Time Will Tell", "In A Jiffy", "Kill Your Face", "Actions Speak Louder", "Toss Up", "Head Over Heels", "Icing On The Cake", "Hit The Books", "Hit The Sack", "Hast Makes Waste", "Out Of The Blue", "Over The Top", "Fiddlesticks", "Sick Of It", "Slam Dunk", "Poop The Bed" "Pish Posh", "Hot To Trot", "Guns Blazing", "Hell Raiser", "Just A Minute", "Last Hurrah", "Fan The Flames", "Oil And Water", "Knuckle Sandwich", "All Hands On Deck", "Abandon Ship", "Bright Side", "Nail In The Coffin", "Bits And Pieces", "All Over The Map", "Axe To Grind", "Pay Dirt", "Floats Your Boat", "Kid Gloves", "Shot In The Dark", "Skin Deep", "Half Baked", "Head Over Heels", "Hump Day", "Hunker Down", "Horse Around", "Hope Springs Eternal", "Hit The Road", "Hit The Deck", "Easy As Pie", "Up For Grabs", "Gang Bang", "Go Crazy", "Go Bananas", "Gold Digger", "Sick Of It All", "Party On", "Quitters Never Win", "Dick In A Knot", "Finger Lickin", "Rock And Roll"],
    :male => ["Ants In His Pants"]
  }
  @@instruments = {
    :neutral => %w{calliope carillon castanet chimes windchime cimbalom clarinet classical\ guitar clavichord clavier concertina conch conga\ drum contrabass cornet cowbell cymbals baby\ grand\ piano bagpipe balalaika bandoneón bandura banjo baritone\ horn bass bass\ clarinet bass\ drum bass\ guitar bassoon bell bongo\ drum bouzouki bow brass\ instruments bugle accordion acoustic\ guitar Aeolian\ harp Alphorn alto\ saxophone anvil electric\ guitar electric\ organ English\ horn euphonium fiddle fife flugelhorn flute French\ horn glockenspiel gong grand\ piano guitar hammered\ dulcimer harmonica harmonium harp harpsichord helicon horn hurdy\ gurdy pan\ pipes penny\ whistle percussion piano piccolo pipa pipe\ organ player\ piano pump\ organ saxophone sitar slide\ whistle snare\ drum spinet spoons steel\ drum tabla tambourine theramin thumb\ piano timpani tin\ whistle tom-tom\ drum triangle trombone trumpet tuba tubular\ bells}
  }
  @@jobs = {
    :neutral => %w{accountant actor actress actuary advisor aide ambassador animator archer athlete artist astronaut astronomer attorney auctioneer author babysitter baker ballerina banker barber baseball\ player basketball\ player bellhop blacksmith bookkeeper biologist bowler builder butcher butler cab\ driver calligrapher captain cardiologist caregiver carpenter cartographer cartoonist cashier catcher caterer cellist chaplain chef chemist chauffeur clerk clergyman clergywoman coach cobbler composer concierge consul contractor cook cop coroner courier cryptographer custodian dancer dentist deputy dermatologist designer detective dictator director disc\ jockey diver doctor doorman driver drummer drycleaner ecologist economist editor educator electrician empress emperor engineer entertainer entomologist entrepreneur executive explorer exporter exterminator extra\ (in\ a\ movie) falconer farmer financier firefighter fisherman flutist football\ player foreman game\ designer garbage\ man gardener gatherer gemcutter geneticist general geologist geographer golfer governor grocer guide hairdresser handyman harpist highway\ patrol hobo hunter illustrator importer instructor intern internist interpreter inventor investigator jailer janitor jeweler jester jockey journalist judge karate\ teacher laborer landlord landscaper laundress lawyer lecturer legal\ aide librarian librettist lifeguard linguist lobbyist locksmith lyricist magician maid mail\ carrier manager manufacturer marine marketer mason mathematician mayor mechanic messenger midwife miner model monk muralist musician navigator negotiator notary novelist nun nurse oboist operator ophthalmologist optician oracle orderly ornithologist painter paleontologist paralegal park\ ranger pathologist pawnbroker peddler pediatrician performer percussionist pharmacist philanthropist philosopher photographer physician physicist pianist pilot pitcher plumber poet police policeman policewoman politician president prince princess principal private private\ detective producer programmer professor psychiatrist\ psychologist publisher quarterback quilter radiologist rancher ranger real\ estate\ agent receptionist referee registrar reporter representative researcher restauranteur retailer retiree sailor salesperson samurai saxophonist scholar scientist scout scuba\ diver seamstress security\ guard senator sheriff smith singer socialite soldier spy star statistician stockbroker street\ sweeper student surgeon surveyor swimmer tailor tax\ collector taxidermist taxi\ driver teacher technician tennis\ player test\ pilot tiler toolmaker trader trainer translator trash\ collector travel\ agent treasurer truck\ driver tutor typist umpire undertaker usher valet veteran veterinarian vicar violinist waiter waitress warden warrior watchmaker weaver welder woodcarver workman wrangler writer xylophonist yodeler zookeeper zoologist}
  }
  @@vegetables = {
    :neutral => %w{acorn\ squash alfalfa artichoke arugula asparagus avocado bamboo\ shoots basil beans beets bell\ pepper black-eyed\ peas broccoli Brussels\ sprouts capers carrot cauliflower celeriac celery chard chick\ peas Chinese\ cabbage chives collard\ greens cress cucumber daikon dandelion\ greens eggplant endive fava\ bean fennel garlic ginger gourd greenbean greens hot\ chile\ peppers iceberg\ lettuce jicama kale kohlrabi leek lentils lettuce Lima\ bean maize mung\ bean mushroom mustard\ greens okra olive onion parsley parsnip pattypan\ squash pea peapod peanut peppers pickle potato pumpkin radicchio radish rhubarb rocket romaine rutabaga salad salsa scallion seaweed shallot sorrel soybean spinach sprouts salsify spuds squash string\ bean succotash sweet\ potato Swiss\ chard taro tomatillo tomato tuber turnip vegetable wasabi water\ chestnut watercress yam zucchini}
  }
  @@pokemon = {
    :neutral => %w{Bulbasaur Charmander Squirtle Caterpie Weedle Kakuna Pikachu Pansage Pansear Panpour Scatterbug Weedle Pidgey Zigzagoon Bunnelby Fletchling Scatterbug Pidgey Pikachu Goldeen Seaking Magikarp Gyarados Dunsparce Masquerain Azurill Corphish Crawdaunt Bidoof Burmy Bunnelby Fletchling Fearow Sandslash Geodude Graveler Shuckle Skarmory Lairon Torkoal Gurdurr Heatmor Durant Fearow Geodude Graveler Haunter Lickitung Ariados Shuckle Teddiursa Ursaring Skarmory Gurdurr Foongus Amoonguss Druddigon Zweilous Noibat Ekans Poliwag Poliwhirl Bellsprout Weepinbell Haunter Quagsire Barboach Whiscash Skorupi Carnivine Karrablast Shelmet Stunfisk Goomy Arbok Poliwag Poliwhirl Weepinbell Haunter Quagsire Gligar Barboach Whiscash Drapion Carnivine Karrablast Shelmet Stunfisk Sliggoo Sandslash Geodude Graveler Ariados Shuckle Aron Durant Noibat Zygarde Nidorina Nidorino Makuhita Starly Staravia Chingling Stunky Sawk Dedenne Jigglypuff Noctowl Sudowoodo Zoroark Gothorita Foongus Amoonguss Trevenant Jigglypuff Poliwag Poliwhirl Ditto Mewtwo Hoothoot Noctowl Lombre Banette Basculin Trubbish Zoroark Gothorita Foongus Amoonguss Zubat Whismur Meditite Axew Oddish Sentret Nincada Kecleon Audino Venipede Espurr Honedge Diglett Graveler Slugma Trapinch Gible Psyduck Hoppip Smeargle Volbeat Illumise Roselia Croagunk Ducklett Flab Swirlix Psyduck Farfetch'd Goldeen Seaking Magikarp Gyarados Azumarill Dunsparce Azurill Carvanha Sharpedo Bidoof Bibarel Riolu Bunnelby Diggersby Litleo Poliwag Poliwhirl Murkrow Mightyena Lombre Floatzel Skorupi Watchog Basculin Foongus Pawniard Klefki Poliwag Poliwhirl Weepinbell Murkrow Shuckle Lombre Floatzel Skorupi Basculin Foongus Klefki Phantump Pumpkaboo Poliwag Poliwhirl Scyther Dratini Dragonair Ursaring Lombre Spinda Swablu Altaria Floatzel Basculin Abra Doduo Plusle Minun Gulpin Scraggy Skiddo Pancham Furfrou Machop Onix Cubone Rhyhorn Kangaskhan Mawile Lunatone Solrock Woobat Ferroseed Tentacool Taillow Wingull Wailmer Spoink Zangoose Seviper Lunatone Solrock Absol Luvdisc Bagon Drifloon Dwebble Mienfoo Inkay Binacle Clauncher Clawitzer Tentacool Slowpoke Exeggcute Pinsir Tauros Lapras Mareep Remoraid Octillery Miltank Wingull Luvdisc Pachirisu Chatot Mantyke Dwebble Binacle Tentacool Horsea Seadra Wailmer Relicanth Dwebble Binacle Clauncher Clawitzer Tentacool Lapras Luvdisc Mantyke Tentacool Wailmer Dwebble Magnemite Magneton Voltorb Electrode Rotom Trubbish Litwick Pawniard Klefki Shellder Cloyster Heracross Larvitar Pupitar Tyranitar Electrike Manectric Purrloin Liepard Throh Spritzee Aromatisse Skrelp Dragalge Yveltal Gastly Jynx Piloswine Smoochum Vanillite Cubchoo Beartic Cryogonal Bergmite Horsea Seadra Relicanth Luvdisc Clauncher Clawitzer Staryu Starmie Qwilfish Wobbuffet Sableye Chingling Mime Roggenrola Woobat Solosis Ferroseed Carbink Eevee Yanma Snubbull Houndour Nosepass Sigilyph Emolga Golett Hawlucha Aerodactyl Snorlax Articuno Zapdos Moltres Ledyba Ralts Skitty Budew Combee Flab Chinchou Lanturn Remoraid Octillery Alomomola Marill Sneasel Delibird Snover Abomasnow Corsola Clamperl Huntail Hippopotas Sandile Helioptile Dwebble Chespin Fennekin Froakie Binacle Tyrunt Amaura Xerneas}
  }
  @@fictional_race = {
    :neutral => %w{Wookie Ewok Time\ Lord Dalek Cyberman Cylon Bajoran Klingon Romulan Headcrab}
  }
  @@vehicles = {
    :neutral => ["Speeder Bike", "Unicorns", "Star Destroyer", "X-Wing", "TIE Fighter"]
  }
  @@body_parts = {
    :neutral => %w{asshole yiffhole fuckhole taint tits butthole anus appendix butt\ dimples 
      distended\ belly belly\ button gallbladder brain buttocks face stretch\ marks bush sexual\ areas groin dingleberry},
    :male => %w{Boner Dick Dingus Tumbescence Male\ Essence},
    :female => %w{Womb Pleasure\ Cave Vulva Uterus Underboob}
  }
  @@animals = {
  :neutral => %w{unicorn dog cat hampster emu ostrich starfish ape kitten cow centipede 
      cephalpod chameleon cheetah chickadee chicken chihuahua chimipanzee chinchilla dingo 
      dinosaur diplodocus doberman puppy camel buffalo capybera caribou blue-footed\ booby kitten 
      platypus narwhal dragon dinglebird emu falcon amoeba antelope amadillo beaver buffalo
      crocodile donkey echidna hedgehog hippo hyena husky kangaroo kiwi kookaburra lobster
      macaw manatee moose musk\ ox mantis}
  }
  @@animal_jobs = {
    :neutral => %w{breeder keeper finder herder collector destroyer hugger hunter tamer}
  }
  @@emoticons = ["ಠ_ಠ", "◔_◔", "(´▽`)", "(｡･_･｡)", "ლ(ಠ_ಠ ლ)", "\(• ◡ •)/", "ಠ益ಠ", "(╯°□°）╯︵ ┻━┻"]

  def test 
    return @@adjectives.take_gendered(:male).sample
  end

  def test_all 
    # @@adjectives.sample_gendered(:female)
    0.upto(@@MAX_DIE_ROLL) { |die_roll|
      gender = [:male, :female, :male, :male, :female, :female, :neutral].sample
      print "#{die_roll} (#{gender.to_s[0]}) - "
      puts generate_for_die_roll(gender, die_roll)
    }
  end 

  def generate(gender)
    generate_for_die_roll(gender, rand(0..@@MAX_DIE_ROLL))
  end 

  # Takes a gendered_sample from hash1, and attempts to find a random element with the 
  # same letter from hash2. if no match found in hash2, just returns random element
  def alliterate(gender, hash1, hash2)
    first_word = hash1.sample_gendered(gender)
    #puts "  ...first_word: #{first_word}"
    #debugger if !first_word
    second_word_candidates = hash2.take_gendered(gender)
    #puts "  ...second_word_candidates: #{second_word_candidates.count}"
    #debugger if !second_word_candidates
    
    alliterative_matches = second_word_candidates.select { |x| x[0].upcase==first_word[0].upcase }

    if alliterative_matches.count>0
      return "#{first_word} #{alliterative_matches.sample.capitalize}"
    else 
      return "#{first_word} #{second_word_candidates.sample.capitalize}"
    end
  end 

  def generate_for_die_roll(gender, die_roll)
    titleize = true 
    #puts "Rolled a #{die_roll}"
    case die_roll 
    when 0..9
      name = alliterate(gender, @@prefixes, @@nouns)
    when 10..19
      name = "#{@@prefixes.sample_gendered(gender)} #{@@nouns.sample_gendered(gender)}"  
    when 20..29
      name = "#{@@characters.sample_gendered(gender)} #{@@character_last_names.sample_gendered(gender)}"  
    when 30..39
      name = @@puns_and_cliches.sample_gendered(gender)
    when 40..44
      name = alliterate(gender, @@ethnicities, @@pokemon)
      name = 'The ' + name if rand(1..10) > 5
    when 45..49 
      if rand(0..1)>0 then 
        name = alliterate(gender, @@ethnicities, @@vegetables)
      else 
        name = @@ethnicities.sample_gendered(:any) + ' ' + @@vegetables.sample_gendered(:any)
      end 
      name = 'The ' + name if rand(1..10) > 5
    when 50..52
      #debugger
      name = alliterate(gender, @@puns_and_cliches, @@names)
    when 52..54 
      name = alliterate(gender, @@names, @@puns_and_cliches)
    when 55..60 
      name = "#{@@verbs_past.sample_gendered(gender)} #{@@characters.sample_gendered(:any)}"
      name=name.titleize.gsub(/\s/,"")
      titleize = false
    when 60..65
      name = "#{@@verbs_past.sample_gendered(gender)} #{@@characters.sample_gendered(:any)}"
      name=name.titleize.gsub(/\s/,"")
      titleize = false
    when 66..68 
      name = "#{["StraightOutta","BornIn","Missing","MyHeartIsIn","HitchhikingTo","TicketTo"].sample}#{@@places.sample_gendered(gender).gsub(/\s/,'')}"
      titleize=false
    when 68..70
      name = "#{['The',''].sample}#{%w{Sexiest Last Loneliest Littlest}.sample}#{@@character_last_names.sample_gendered(gender)}"
    when 70..79 
      name = "#{["BonerFor","OnlyBangs","InLoveWith","FlockOf","SexWith", "CookingUpSome", "LoverOf", "FriendOf", "PileOf", "AttractedTo"].sample}#{@@fictional_race.sample_gendered(:any).pluralize.gsub("\s","")}"
      titleize = false
    when 80..85
      name = "#{["Secretly A","The Last","Married To A","Wish I Was",""].sample}#{@@fictional_race.sample_gendered(:any).gsub("\s","")}" 
    when 86..90
      name = "#{@@fictional_race.sample_gendered(:neutral)} #{@@names.sample_gendered(gender)}"
    when 91..96
      name = alliterate(gender, @@fictional_race, @@names)
    when 97..107
      name = alliterate(gender, @@places, @@nouns)
      titleize = false if rand(0..1)>0
    when 108..115
      name = ["AllAboutTha","LoveMy","Sexy","TouchMy","Fetish4","Alluring", "Seductive", "Cyborg"].sample + @@body_parts.sample_gendered(gender).titleize.gsub(/\s/,'')
      titleize = false
    when 116..126
      temp= {}
      temp[:neutral] =  @@verbs_personal[:neutral].map { |x| x.capitalize + %w{My Your That A}.sample }
      name = alliterate(gender, temp, @@pokemon).gsub(/\s/,'')
      titleize = false if rand(0..1)>0
    when 127..137
      name = alliterate(gender, @@adjectives, @@jobs).gsub(/\s/,'')
    when 138..140
      name = "#{@@animals.sample_gendered(:any)} #{@@animal_jobs.sample_gendered(:any)}"
    when 141..142
      name = "#{@@animal_jobs.sample_gendered(:any)} of #{@@animals.sample_gendered(:any).pluralize}"
    when 143..148
      name = alliterate(:any, @@adjectives, @@animals)
      case rand(0..10)
      when 1
        name = ['Much ', 'Very ', 'So ','The '].sample + name
      end 
    when 149..160
      name = "#{@@characters.sample_gendered(:any)}’s #{@@relationship.sample_gendered(gender)}"
    else
      name = alliterate(gender, @@adjectives, @@animals)
    end

    case rand(0..1)
    when 0
      name.gsub!(/\bthe\b/i,'tha')
    when 1
      name.gsub!(/\bthe\b/i,'da')  
    end

    name = name.titleize if titleize

    name.gsub!(/[\s'’]/,'') if rand(0..2)>0

    case rand(0..35)
    when 1 
      name = "#{name} #{@@emoticons.sample}"
    when 2..3 
      name="~#{name}~"
    when 4
      name="-=#{name}=-"
    when 5
      name = name.gsub(/[\s'’]/,'') + rand(1..1000).to_s
    when 6..8
      name = name.underscore
    when 9..10
      replacement = %w{☆ ♡ xx .o. :: - .. 😄 👊 💎 💩}.sample
      name = "#{replacement}#{name}#{replacement}"
    when 11 
      name = name.gsub(/[\s]/, %w{~ ^ = ★★ ☆ .}.sample)
    when 12
      name = name.gsub(/[eioO]/,'e'=>'3','i'=>'1','o'=>'0','O'=>'0')
    when 13
      name = name.gsub(/[wEBHaOo]/, 'w' => 'ẃ', 'o'=>'ŏ', 'O'=>'0', 'E'=>'ℇ', 'B'=>'ℬ', 'H'=>'ℌ', 'a'=>'ä')
    end 

    name
  end
end 

=begin
hsun = HalfSavageUserNames.new

hsun.test_all
exit
0.upto(5) {
  puts hsun.generate(:male)
  puts hsun.generate(:female)
}
=end