require 'active_support/core_ext/string'
require 'active_support/core_ext/integer'

# Not sure if the module thing is necessary. 
# The Kernel.eval stuff wasn't working when I had it in a class
# because the @class_vars weren't in scope for the Kernel
# object. The StackOverflow answer, which I found and didn't
# quite understand, suggested this approach.

class HalfSavageSubjects
  def initialize
    @properties = ['Star Wars','Gundam','Evangelion','My Little Pony','Lord of The Rings','Pokemon','Call Of Duty','Final Fantasy','Dragon Quest','Cosby Show','Dukes of Hazzard','Twilight','Back To The Future','Sweet Valley High','Star Trek','One Piece','Hellsing', 'Trigun', 'Firefly']
    @mediums = ['comic','game','novel','memory implant chip','dildo','t-shirt collection','fan-fiction']
    @verbs_current = %w{reading eating fucking loving hating excreting secreting sexually\ obsessed\ with buying missing}
    @verbs_past = %w{fondled loved stalked touched ate shat fucked loved hated congratulated}
    @verbs_person =%w{marry punch relate\ to love neuter worship excite talk\ to touch praise yell\ at}
    @superlatives = %w{latest first worst best most\ erotic drunkest corniest most}
    @impulsive_adjectives = %w{impulse desperation}
    @instruments = %w{keytar guitar piano glockenspiel cello clarinet clavichord conga drum contrabassoon cornet cymbals double\ bass dynamophone flute glockenspiel gongs guitar harmonica harp harpsichord lute mandolin maracas metallophone musical\ box oboe piano recorder saxophone shawm snare\ drum steel\ drum tambourine theremin trombone trumpet tuba ukulele viola violin xylophone zither}
    @foods = %w{Twinkies Pocky Hot\ Pockets greasy\ convenience\ store\ food questionably-sourced\ salami scraps\ of\ lunch\ meat pork\ chops BBQ\ potato\ chips chocolate cinnamon clam\ chowder cloves peach\ cobbler coconut\ cream cream\ cheese crepe ucumber cupcakes curds currants curry custard lamb lard lasagna legumes pancakes fruity\ tropical\ bullshit pastry liver\ pate chocolate\ sprinkles french\ fries ramen\ noodles beef\ stew stir-fry strawberry Pop-Tarts teriyaki thyme toast toffee}
    @food_types = %w{pancakes sandwiches soup ice\ cream dumplings latkes paella}
    @verbs_food_cooking_current =  %w{frying baking boiling toasting deep-frying slow-roasting}
    @dogs = %w{Afghan\ hound African\ wild\ dog airedale\ terrier akita Alaskan\ malamute American\ cocker\ spaniel Australian\ cattle\ basset\ hound beagle bichon\ frise bloodhound border\ collie Boston\ terrier boxer bulldog bullmastiff bull\ terrier chihuahua chow cocker\ spaniel collie companion\ dog coon\ hound corgi samoyed scent\ hound schnauser}
    @animals = %w{unicorn dog cat hampster emu ostrich starfish kitten centipede crippled\ pet\ goat chameleon cheetah chicken chihuahua chimipanzee chinchilla dingo doberman puppy}
    @adjectives_quality = %W{awesome shitty amazing dull erotic hectic sexy enchanting unforgettable legendary fucked-up}
    @adjectives_big = %w{gargantuan giant gigantic ginormous goodly grand great immense imposing impressive piled\ high plentiful plump portly powerful prodigious swollen}
    @animal_actions = %w{clone walk groom neuter spay relate\ to breed}
    @related_person = %w{sister brother teacher doctor mom dad best\ friend neighbor weird\ uncle children classmate colleague co-worker companion best\ friend boyfriend bride brother buddy gay\ manager bro homie lover creepy\ neighbor abusive\ stepmother MMA\ opponent fuck-buddy preteen favorite\ motherfucker\ on\ Earth arch-rival roommate slave}
    @colors = %w{saffron salmon sapphire scarlet sea green secondary sepia shade shamrock sienna silver spectrum slate steel blue pale pastel peach periwinkle persimmon pewter pink primary puce pumpkin purple cardinal carmine celadon cerise cerulean charcoal chartreuse chocolate cinnamon color complementary copper coral cream crimson cyan amber amethyst apricot aqua aquamarine auburn azure}
    @body_parts = ['asshole', 'yiffhole', 'boner', 'fuckhole', 'taint', 'tits', 'dick',  'vagina', 'butthole', 'abdomen', 'Adam\'s apple', 'adenoids', 'forehead', 'anus', 'appendix', 'arm', 'artery', 'butt dimples', 'distended belly', 'belly button', 'gallbladder', 'brain', 'left titty', 'buttocks', 'fucking face', 'cervix', 'fallopian tubes', 'stretch marks', 'bush', 'liver', 'circulatory system', 'dingus', 'sexual areas', 'collar bone', 'diaphragm', 'digestive system', 'ear', 'ear lobe', 'elbow', 'endocrine system', 'esophagus', 'eye', 'eyelashes', 'eyelid', 'face', 'fallopian tubes', 'feet', 'femur', 'fibula',  'foot', 'forehead', 'gallbladder', 'groin', 'gums', 'hair', 'hand', 'head', 'aorta', 'heel', 'hip', 'humerus', 'immune system', 'instep', 'intestines', 'jaw', 'kidney', 'knee', 'larynx', 'leg', 'nasty mouth', 'lip', 'liver', 'lobe', 'lumbar vertebrae', 'lungs', 'beautiful mouth', 'face', 'everything', 'sensitive areas', 'tonsils', 'mouth', 'muscle', 'belly button', 'neck', 'nerves', 'nipple', 'nose', 'nostril', 'organs', 'ovary', 'palm', 'pancreas', 'patella', 'pelvis', 'nuts', 'pharynx', 'leaky wound', 'eyes','rectum', 'red blood cells', 'respiratory system', 'ribs', 'sacrum', 'scalp', 'scapula', 'senses', 'shin', 'shoulder', 'shoulder blade', 'skeleton', 'skin', 'skull', 'sole', 'spinal column', 'spinal cord', 'spine', 'spleen', 'sternum', 'stomach', 'forbidden anus', 'silky pleasure entrance', 'testes', 'creamy thighs', 'bottomless hole', 'throat', 'useless stumps', 'toenail', 'tongue', 'tonsils', 'teeth', 'torso', 'butt cheeks', 'urethra', 'ding-dong', 'uterus', 'uvula', 'extra nipple', 'vulva']
    @amounts = ['two', 'three', 'a whole bunch', 'about a million', 'some', 'a shitload', 'a fuckload', 'a fuckton', 'a bullshit amount', 'too many']
    @gush_or_gripe = ['gush', 'squeal', 'fangirl', 'complain', 'rage', 'orgasm', 'rave', 'bitterly express dissatisfaction', 'grumble', 'ramble incoherently']
    @personal_qualities = %w{impossibly\ well-dressed dangerously\ schizophrenic half-dead terminally\ ill hypersexual ill-tempered alcoholic phenomenally\ well-hung militantly\ Islamic stab-happy racist inappropriately\ sexual sexually\ violent violent delightful playful idiotic idle illogical imaginative sexually\ intimidating immature immodest impatient psychotic sensual imp-like impetuous impractical impressionable impressive impulsive inactive incisive incompetent inconsiderate inconsistent independent indiscreet indolent indefatigable industrious inexperienced insensitive inspiring intelligent interesting intolerant inventive irascible irritable irritating eager earnest easy-going efficient egotistical elfin emotional energetic enterprising enthusiastic evasive even-tempered exacting excellent excitable experienced passionate passive paternal paternalistic patient peaceful peevish pensive persevering persnickety petulant picky plain plain-speaking playful pleasant plucky polite popular positive powerful practical prejudiced pretty proficient proud provocative prudent punctual ugly unaffected unbalanced uncertain uncooperative undependable unemotional unfriendly unguarded unhelpful unimaginative unmotivated unpleasant unpopular unreliable unsophisticated unstable unsure unthinking unwilling}
    @exclamations = ['Well!', 'Gah...', 'Whee.', 'Grr.', 'Fuck.', 'Yes.', 'Hi.', 'Wow.', 'Speechless.', 'Shitballs.', 'Yikes.', 'Whoa.', 'Yowzers.', 'Jinkies.', 'Nuts.', 'Crap.', 'Ooooh.']
    @verbs_hitting = %w{punching kicking bodyslamming head-butting elbowing}
    @ordinal_modifiers = ['in a row', 'since this morning', 'in my entire life', 'since last week']
    @timespan = %w{year day month morning evening century}
    @advice_modifiers = ['Am I doing it right?', 'This is confusing.', 'Explain it to me.', 'You\'re my last hope, Obi-Wan.', 'I\'m scared!', '', '', '', '', '', '']
    @programming_languages = %w{COBOL Java Ruby Scala Haskell Visual\ Basic C# C++ Javascript}
    @rooms = ['sexual arena', 'filthy wine cellar', 'urine-soaked murder alley','indoor meat smoker', 'improvised slaughterhouse', 'ballroom', 'basement', 'bathroom', 'bedroom', 'boardroom', 'boiler room', 'boudoir', 'breakfast nook', 'breakfast room', 'salesroom', 'salon', 'schoolroom', 'screen porch', 'scullery', 'showroom', 'sick room', 'sitting room', 'solarium', 'staff room', 'stateroom', 'stockroom', 'storeroom', 'studio', 'study', 'suite', 'sunroom', 'panic room', 'pantry', 'parlor', 'playroom', 'pool room', 'powder room', 'prison cell']
    @furnishings = ['sofa', 'bed', 'filthy mattress', 'sex swing', 'Venetian marble fireplace', 'pinball machine', 'fuck mat', 'dart board', 'bookcase', 'scratching post', 'shit-bucket', 'urinal', 'toilet', 'anime wall scroll', 'stereo']
    @desires = ['need', 'want']
    @obtained = ['bought', 'stole', 'traded my dignity for', 'found']
    @housing = ['cabin', 'caravan', 'castle', 'chalet', 'chateau', 'condo', 'condominium', 'cottage', 'country house', 'crib', 'dojo', 'disgusting shithole', 'filthy trailer', 'terraced house', 'homeless shelter', 'townhouse', 'tract house', 'trailer home', 'treehouse', 'triplex', 'friend\'s shack', 'ranch house', 'real estate', 'residence', 'residential hall', 'rooming house', 'roundhouse', 'row house', 'palace', 'penthouse', 'pied-á-terre']
    @housing_events = ['burnt down', 'was flooded', 'got eaten by Galactus', 'exploded', 'got featured in a magazine', 'is still really shitty', 'is not a place I\'d like to live', 'is my new home']
    @housing_adjectives = %w{charming elegant filthy condemned infested cleanest}
    @most_least = %w{most\  least-}
    @places_proper = ['Beirut', 'Afghanistan', 'Poughkeepsie', 'New York', 'Iowa', 'my hood', 'Compton', 'Western Canada', 'this lousy town', 'the ghetto', 'Hell', 'outer space', 'France', 'Germany', 'Detroit', 'Philadelphia', 'Atlanta', 'the middle of the Sahara Desert', 'Texas', 'Australia', '', 'Mongolia', 'San Francisco', 'Oakland', 'Planet Telezart', 'Florida']
    @places_outdoor = %w{swamp forest desert wilderness tundra jungle lava\ field}
    @activities = ['have a quiet nipple moment', 'find love', 'get laid', 'get murdered', 'learn how to love', 'find a unicorn', 'play ice hockey', 'have the living shit kicked out of me', 'achieve inner peace', 'fuck a hole in the wall', 'get diseases', 'be homeless', 'masturbate', 'touch a hobo', 'knit sweaters until my fingers fall off']
    @activities_sexual_current = ['get a handjob', 'piss in each others\' mouths', 'dry hump', 'awkwardly masturbate', 'experiment with assplay', 'hit it doggy-style', 'explore the limits of pleasure', "go balls deep in a #{(@related_person + @animals).sample}"]
    @verbs_sexual = ['furiously blowing', 'awkwardly fondling', 'fucking', 'sucking off', 'licking', 'plowing my cock into', 'going balls-deep inside', 'blowing a load in', 'rubbing my clit on', 'getting my asshole filled by', 'getting a vagina full of']
    @game_consoles = ['Wii U', 'Atari 2600', 'Colecovision', 'Nintendo64', 'Sega Dreamcast', 'Super Nintendo', 'GameBoy Color', 'Sega Master System', 'Neo-Geo', 'Nintendo','XBox','XBox 360', 'Playstation 4', 'Wonder Swan', 'Vectrex', 'Nintendo 3DS', 'Turbografx-16', 'Sega Genesis', 'Super Nintendo', 'Gamecube', 'Wii']
    @game_console_features = ['microchips and shit', 'controller ports', 'electronic jibber-gabber', 'megaflops', 'pixels', 'sensitive areas', 'graphics chips', 'blast processing', 'optical drive', 'USB-powered rubber vagina']
    @emotions = ['anger', 'remorse', 'melancholy', 'emotions', 'regrets', 'joyousness', 'happiness']
    @diseases = ['AIDS','a prolapsed rectum','penis sores','a cold','the flu','food poisoning','cancer', 'cystic fibrosis', 'kennel cough', 'fetal alcohol syndrome', 'constant migraines', 'dehabilitating erections', 'excessivly sweaty tits', 'unruly nipples', 'chlamydia', 'angry nipples', 'hepatitis', 'retard-face', 'ass drizzle', 'body odor', 'maybe the most disgusting asshole ever']
    @person_to_person_activities = ['got high on PCP and stole a car with', 'gave a handjob to', 'cuddled with', 'explored nipple torture with', 'got a handjob from', 'smoked up with', 'rubbed nipples with', 'fucked', 'got fucked by', 'freestyle rhymed with', "discussed #{@properties.sample} with", 'brawled with', 'knocked out', 'shot a load all over', 'threw up on']
    @sexual_noun = ['prostate massage','orgasm','blowjob','handjob','fingerbang','nipplejob','load of man-batter','shoebox full of pubes','sexual ass-kicking','haymaker to the taint']
    @adjectives = ['cursed', 'clean', 'enchanted', 'filthy', 'infected', 'vomit-covered', 'flaming']
    @type_of_person = ['robot with a mysterious past', 'killer robot', 'aging liberal with a lisp', 'creepy lumberjack', 'imp', 'terrified child', 'libertarian asshole', 'confused elderly man', 'chubby nerd', 'Christian fundamentalist', 'meth addict', 'black guy', 'poet', 'biker', 'double amputee', 'Pokemon master', 'femme fatale', 'toddler', 'hobo', 'Mexican drug lord', 'frat guy', 'hipster', 'librarian', 'austistic savant']
    @personal_enhancements = ['drinking my weight in semen','discovering myself sexually','sucking dick until I pass out','getting fucked until I can\'t walk any more','gentle kissing','finding love','washing my genitals', 'allowing myself to be sexual', 'breast feeding', 'getting a sex change','taking vitamin E','snorting my mother\'s ashes', 'eating bananas until I puke', 'fucking up a stranger\'s life for no reason','shaving my ass','getting nipple implants','murdering a child','pissing all over myself']
    @adjectives_sexual = ['jackhammer','enigma','monster', 'dynamo','force','juggernaut','tyrannosaurus','beast','force to be reckoned with','disappointment','failure','disaster','hero','legend']
    @preambles = ["Even though my ass healed","Despite enjoying the sex","I don\'t care how many orgasms I had","After last night","Now that my butt is all stretched out","Despite a weekend of near-consecutive orgasms","Considering my multiple ass fractures","After a fucking like that","Now that I\'ve been acquitted on a technicality"]

    @subject_templates = [
      "I #{["can never","would like to","think we should meet up to","can\'t"].sample} #{@activities.sample} in #{@places_proper.sample} without #{@personal_enhancements.sample}.",
      "#{%w{He She I}.sample} #{["jizzed", "ejaculated", "forcefully erupted", "rubbed that dick", "threw up", "planted kisses", "sprayed orgasmic fluids", "sprinked confetti", "left sexy little notes", "jerked that midget off"].sample} everywhere. All over my #{@body_parts.sample}, all over the #{(@rooms + @furnishings + @game_consoles).sample}.",
      "I\'m #{@verbs_food_cooking_current.sample} some #{@food_types.sample} made from #{@foods.sample}. #{["Soon it will be #{@verbs_sexual.sample} my #{["taste buds","mouth","senses"].sample}.", "Is this healthy?", "Do you want any?", "What are my odds of getting laid?", "Am I doing this right?", "Supposedly this can cure #{@diseases.sample}.", "", "", ""].sample}",
      "It\'s #{["easy","tough","worth the effort","exciting","fun","sexually rewarding"].sample} to meet a #{@type_of_person.sample} and #{@activities_sexual_current.sample}, #{["although they\'ll probably have","even if you have","if you don\'t have", "but you could get"].sample} #{@diseases.sample}.",
      "#{["Do you want to", "Is $50 enough to", "Should I","Will you donate money so I can","Am I wrong to", "Am I the only one who wants to"].sample} get #{%w{my your}.sample} #{@body_parts.sample} #{["tattooed","plastered with semen","spruced up a little","sensually massaged","replaced by cybernetics","replaced with some scary robot shit","amputated for no reason at all","upgraded to a finely-tuned pleasure machine","turned into a weapon of death","bedazzled","enlarged","replaced by a chainsaw","" "slapped around by a #{@type_of_person.sample}"].sample}?",
      "#{["After #{%w{two five countless some\ deeply\ awful ten}.sample} years ","Today ","Despite nearly dying ","","","","",""].sample}I finally mastered the #{(@instruments + @game_consoles).sample}. #{["","","","","It was worth getting #{@diseases.sample}.", "I\'m bleeding and exhausted, but happy.", "Fuck the haters.","Who\'s wet?","Come at me, bro.","Time to #{@activities.sample}.","That shit was easy."].sample}",
      "I\'m really into #{["lo-fi ","boldly sexual ","explicit ","electronic ","acoustic ","","","","","","",""].sample}#{["avant-garde","acid", "seductive Aboriginal", "Scandinavian", "authentic African", "brutal German", "skinhead", "fusion", "ambient", "hip-hop", "tradional Russian", "mindblowing Egyptian"].sample} #{["Britpop", "sex music", "spoken-word poetry", "torture jazz", "space funk", "yodeling", "beatboxing", "death punk", "metal", "noise-rock", "classical music", "folk rap"].sample} #{["lately","because I\'m an asshole","because I\'m an insufferable prick","because it helps me relax","and I think you\'d like it","and it\'s fun to dance to","cuz it\'s really sexy","and my mom hates it","and you\'d hate it because you\'re a fucking moron","- it\'s really funky","because it gets me laid"].sample}.",
      "I probably have the #{@most_least.sample}#{(@adjectives+@personal_qualities).sample} #{(@animals+@related_person).sample} in #{@places_proper.sample}.",
      "#{["Are there any", "Any", "Can you talk about", "Friends,"].sample} recent releases for the #{@game_consoles.sample} you\'d #{["recommend","jizz over","want for Christmas","rather catch hepatitis than play"].sample}?",
      "#{%w{Took Coerced Seduced Tempted Invited}.sample} a real #{@adjectives_sexual.sample} back to my #{@housing.sample} so we could #{@activities_sexual_current.sample} and discovered #{%w{he she}.sample} was a #{@type_of_person.sample}.",
      "Which is more #{["metal","bad-ass","likely to get you off","acceptable on the first date"].sample}: #{@personal_enhancements.sample} or #{@verbs_sexual.sample} a #{@type_of_person.sample}?",
      "I just #{@person_to_person_activities.sample} a #{@type_of_person.sample} somewhere in #{@places_proper.sample} despite having advanced #{@diseases.sample}.",
      "#{["Do you think", "Will", "Could", "Should"].sample} #{@personal_enhancements.sample} make me #{["even more","more","more","more","less"].sample} of a sexual #{@adjectives_sexual.sample}?",
      "Post pictures of your #{(@body_parts + @animals).sample}.",
      "#{["This is my","Here is","Check out"].sample} this #{%w{video picture drawing pic}.sample} of my #{(@related_person + @animals).sample} #{["acting like","doing an impression of"].sample} a #{@personal_qualities.sample} #{@type_of_person.sample}.",
      "I\'m going to #{@gush_or_gripe.sample} about my #{@personal_qualities.sample}, #{@personal_qualities.sample} #{@related_person.sample}.",
      "#{["Anybody get", "Am I an asshole if I buy", "I\'m so hard right now. Anybody try", "Do you like", "Spurting all over here. Who else got"].sample} the new #{@properties.sample} #{@mediums.sample}?",
      "#{["Just once, I\'d like to", "In my family, we always", "This year, we\'re going to"].sample} celebrate #{["my birthday","Rosh Hashana","holidays","every sunrise","victory","Christmas"].sample} by #{["murdering", "eating", "loving", "sadistically experimenting on", "sexually arousing", "completely wiping out"].sample} our #{(@animals + @related_person).sample}.",
      "The #{@most_least.sample}#{@housing_adjectives.sample} #{@housing.sample} in #{@places_proper.sample} #{@housing_events.sample}.",
      "Can I get #{@diseases.sample} from #{@verbs_sexual.sample} a #{@adjectives.sample} #{(@furnishings + @game_consoles).sample}?",
      "What are you #{@verbs_current.sample} right now?",
      "Thread in which to #{@gush_or_gripe.sample} about #{@animals.sample.pluralize}.",
      "Anybody else enjoy #{@verbs_hitting.sample} themselves in the #{@body_parts.sample}?",
      "I just #{@verbs_past.sample} my #{rand(3..50).ordinalize} #{@animals.sample} #{@ordinal_modifiers.sample}",
      "Why your #{@timespan.sample} is #{@adjectives_quality.sample}.",
      "How can I be #{%w{more less}.sample} #{@personal_qualities.sample}?",
      "Need help... trying to #{@animal_actions.sample} my #{@dogs.sample}#{[".",".","."," using nothing but my mind."," with crude stone tools."," and I\'m super drunk."].sample}",
      "Is it #{%w{normal healthy sexy}.sample} for my #{@body_parts.sample} to be so #{@adjectives_big.sample}? #{@advice_modifiers.sample}",
      "Which is better: #{@properties.sample} or my #{@adjectives_quality.sample} #{(@related_person + @body_parts + @animals).sample}?",
      "Any other fans of #{@properties.sample}?",
      "Any other fans of #{@properties.sample} who like a good #{@sexual_noun.sample}?",
      "#{%w{Ladies Men Single\ motherfuckers People\ of\ Earth Friends Eligible\ bachelors}.sample}, I\'m into trying to #{@activities.sample} and #{["jerking off to","studying","enjoying","basing my life around"].sample} #{@properties.sample}. #{["Let\'s fall in love.","Want to meet?","Should I kill myself?","Will you let me touch you?", "", "", "", ""].sample}",
      "Is #{@places_proper.sample} a nice place to live?",
      "Moving to #{@places_proper.sample}.",
      "The #{["doctor","doctor","nurse","stupid motherfucker"].sample} told me I have #{@diseases.sample}. #{["Is that even a real thing?","But I think he was drunk.","Yay?","Can I cure that by punching myself in the dick?","","",""].sample}",
      "#{["Good idea?", "Bad idea?"].sample} Moving to #{@places_proper.sample}.",
      "#{["Home decor:","Decorating advice needed -"].sample} would this #{@furnishings.sample} look better in my #{@rooms.sample} or my #{@rooms.sample}?",
      "#{@desires.sample} a #{%w{new used filthy shiny elegant}.sample} #{@furnishings.sample} for my #{@rooms.sample}. #{@advice_modifiers.sample}",
      "My #{@housing.sample} just #{@housing_events.sample}.",
      "Is #{@places_proper.sample} a good place to #{@activities.sample}?",
      "#{["How","Why","When","Where"].sample} do I #{@activities.sample}?",
      "#{["How","Why","When","Where"].sample} do you #{@activities.sample}?",
      "#{@gush_or_gripe.sample} about your #{@housing.sample} here.",
      "#{["Did you ever", "Would you ever", "Do you want to"].sample} #{@verbs_person.sample} your #{@related_person.sample}? #{["Why?","Details, please.","",""].sample}",
      "My #{@body_parts.sample} tastes like #{@foods.sample}. #{%w{Odd. Delightful. Shocking. Erotic. Does\ yours? Should\ I\ be\ alarmed?}.sample}",
      "Can my #{(@related_person + @dogs).sample} learn #{@programming_languages.sample}?",
      "I think my #{@animals.sample} should #{@activities.sample} in a #{(@places_outdoor + @housing).sample}.",
      "My #{@body_parts.sample} is #{@adjectives_big.sample}!",
      "#{%w{My Your}.sample} #{@related_person.sample} always #{%w{looks yells drools points laughs}.sample} at my #{@body_parts.sample}. #{["Hate that.","Love it.","Makes me feel good.","Should I flirt back?","Is that sexy?","I guess they don\'t mind the battle scars."].sample}",
      "#{@foods.sample} and #{@foods.sample} #{["can cure cancer", "taste great together", "taste like shit together", "are good for hangovers", "give me a boner", "are a good pairing"].sample}.",
      "I play my #{@instruments.sample} #{["well", "loud", "all the time", "whenever I want", "at parties"].sample} and #{%w{bitches dudes ladies people punks motherfuckers}.sample} #{["love it", "hate it", "get wet", "want to fuck me"].sample}.",
      "My #{@related_person.sample} has the best #{@body_parts.sample}.",
      "#{["Ever", "Do you ever want to", "Should you ever", "Is it possible to"].sample} #{@activities_sexual_current.sample} in a #{@places_outdoor.sample}?",
      "#{@obtained.sample} a #{(@furnishings + @game_consoles).sample}. #{["Advice?", "Fuck you.", "Suck my dick.", "How do I use this thing?", "Then I set it on fire.", "I hate it.", "I think it\'s possessed.", "It gave me AIDS.", "Help me."].sample}",
      "#{["Will you","Can I","Should I","How can I"].sample} #{["fix","upgrade","clean","fuck up"].sample} the #{@game_console_features.sample} on my #{@game_consoles.sample}?",
      "#{["Confession: I ", "Surprisingly, I ", "Much to my chagrin I ", "Confusingly, I ","","","","","",""].sample}#{["felt", "had some", "went through some", "experienced"].sample} #{@emotions.sample} while #{(@verbs_sexual + @verbs_hitting).sample} my #{(@furnishings + @related_person).sample}.",
      "#{%w{best worst most\ confusing most\ enjoyable}.sample} #{%w{party Bar\ Mitzvah wedding funeral bash kegger}.sample} ever. #{@person_to_person_activities.sample.capitalize} #{["some guy","some chick","pretty much everybody","my secret crush","myself","another asshole"].sample}. #{["Still woozy.","I\'m bleeding now.","Left right before the cops showed up.","It was worth it.","Totally not worth it.","","","","",""].sample}",
      "#{["Is it", "Why is it", "I\'m told it\'s"].sample} #{%w{customary acceptable sexy}.sample} to #{@activities_sexual_current.sample} at a #{["Jewish ", "Wiccan ", "pagan ", "traditional Chinese ", "Japanese ", "no-holds-barred ", "sexual domination-themed ", "", "", "", "", ""].sample}#{%w{party Bar\ Mitzvah wedding funeral bash kegger}.sample}?",
      "#{["Medical emergency? ", "Should I see a doctor? ", "Is this normal? ", "Don\'t you hate this? ", "", "", ""].sample}My #{@body_parts.sample} just #{["exploded","tingled","disappeared","gurgled","fell off","got chewed off by a dog"].sample}.",
      "Attn #{@places_proper.sample}: #{@desires.sample} to trade a #{@sexual_noun.sample} or my #{@dogs.sample} for a #{(@instruments + @game_consoles).sample}.",
      "Got a new #{@furnishings.sample} for my #{@rooms.sample}. #{["","","","Pics inside.","Here are pictures."].sample}",
      "I\'m #{["addicted to", "in love with", "enjoying"].sample} #{@foods.sample}.",
      "I\'m #{["addicted to", "in love with", "enjoying"].sample} #{%w{pot sex drugs prison death cocaine murder death love flatulence}.sample}.",
      "#{@game_consoles.sample} sucks. #{@game_consoles.sample} has the best #{@game_console_features.sample}.",
      "What\'s your type? I always seem to #{["fall for","be smitten with","have unprotected sex with","have a crush on","flirt with"].sample} a #{@personal_qualities.sample} #{@type_of_person.sample}.",
      "#{["True story.", "Crazy story.", "Confession.", "I feel bad.", "So this happened."].sample} #{["I went off my psych meds and", "We got way too drunk and", "One day, I woke up and", "After renouncing God", "While high on PCP", "I was blackout drunk but according to security footage"].sample} I #{@person_to_person_activities.sample} #{%w{my your}.sample} #{@related_person.sample}.",
      "#{["I killed a guy", "I never bathe", "I live in my parents\'s basement", "I have no penis", "I may be a quadraplegic", "I\'m on multiple sex offender registries", "I can\'t hold a steady job"].sample}, but #{["I get laid anyway", "I have a lot of love to give", "I usually bowl around 250 on a bad day", "I can still rock your world", "you should still let me join your murder cult", "give me drugs anyway", "let\'s go on a date"].sample}. #{["Let\'s meet up.", "We should hang out.", "","","",""].sample}",
      "#{@preambles.sample}, I don\'t think I\'ll be able to #{["be friends with","love","look at","marry","sexually worship","impress","piss off","go within 100 feet of","convince anybody that I am","open my heart to"].sample} a #{(@animals + @type_of_person).sample} #{["ever again","for a while","until the next time I\'m drunk","for the rest of my life","for a long time"].sample}."
    ]
  end 

  # Test every template to make sure there are no rendering errors 
  def test_subject_templates
    @subject_templates.each { |template| 
      puts render_subject(template) 
    }
  end 

  def random_subject
    render_subject(@subject_templates.sample)
  end 

  def render_subject(template)
    begin
      subject = Kernel.eval("\"" + template + "\"")
      subject = Kernel.eval("\"" + subject + "\"")
      subject[0] = subject[0].capitalize
      subject = (@exclamations.sample + ' ' + subject) if rand(0..15)==0
    rescue Exception => e 
      puts "Couldn't render!"
      puts "Template: #{template}"
      puts "Exception: #{e}"
    end 
    subject
  end 

  def render_body_text
    raise NotImplementedError 
  end 

end 

=begin
hss = HalfSavageSubjects.new
hss.test_subject_templates
=end