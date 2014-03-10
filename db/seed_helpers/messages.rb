
require 'active_support/core_ext/string'
require 'active_support/core_ext/integer'

class HalfSavageMessages 
  def initialize 

    @properties = ['Star Wars','Gundam','Evangelion','My Little Pony','Schindler\'s List', 'Lord of The Rings','Pokemon','Call Of Duty','Final Fantasy','Dragon Quest','the Cosby Show','Dukes of Hazzard','Twilight','Back To The Future','Sweet Valley High','Star Trek','One Piece','Hellsing', 'Trigun', 'Firefly']
    @mediums = ['comic','game','novel','memory implant chip','dildo','t-shirt collection','fan-fiction']
    @verbs_current = %w{reading eating fucking loving hating excreting secreting sexually\ obsessed\ with\ buying missing}
    @verbs_past = %w{fondled loved stalked touched ate\ out fucked loved hated congratulated gently\ fingerbanged cuddled\ with}
    @verbs_person =%w{marry punch relate\ to love neuter worship excite talk\ to touch praise yell\ at}
    @superlatives = %w{latest first worst best most\ erotic drunkest corniest most}
    @impulsive_adjectives = %w{impulse desperation}
    @vices_plural = %w{handfulls\ of\ random\ pills beers hits\ of\ crack drinks whiffs\ of\ jenkam tabs\ of\ LSD bong\ rips cosmopolitans chugs\ of\ corn\ liquor}
    @instruments = %w{keytar guitar piano glockenspiel cello clarinet clavichord conga drum contrabassoon cornet cymbals double\ bass dynamophone flute glockenspiel gongs guitar harmonica harp harpsichord lute mandolin maracas metallophone musical\ box oboe piano recorder saxophone shawm snare\ drum steel\ drum tambourine theremin trombone trumpet tuba ukulele viola violin xylophone zither}
    @foods = %w{Twinkies Pocky Hot\ Pockets greasy\ convenience\ store\ food questionably-sourced\ salami scraps\ of\ lunch\ meat pork\ chops BBQ\ potato\ chips chocolate cinnamon clam\ chowder cloves peach\ cobbler coconut\ cream cream\ cheese crepe ucumber cupcakes curds currants curry custard lamb lard lasagna legumes pancakes fruity\ tropical\ bullshit pastry liver\ pate chocolate\ sprinkles french\ fries ramen\ noodles beef\ stew stir-fry strawberry Pop-Tarts teriyaki thyme toast toffee}
    @food_types = %w{pancakes sandwiches soup ice\ cream dumplings latkes paella}
    @verbs_food_cooking_current =  %w{frying baking boiling toasting deep-frying slow-roasting}
    @dogs = %w{Afghan\ hound African\ wild\ dog airedale\ terrier akita Alaskan\ malamute American\ cocker\ spaniel Australian\ cattle\ basset\ hound beagle bichon\ frise bloodhound border\ collie Boston\ terrier boxer bulldog bullmastiff bull\ terrier chihuahua chow cocker\ spaniel collie companion\ dog coon\ hound corgi samoyed scent\ hound schnauser}
    @animals = %w{unicorn dog cat hampster emu ostrich starfish ape kitten chihuahua chimipanzee chinchilla fuckable\ teddy\ bear doberman puppy sea\ lion camel buffalo capybera shitty\ dog}
    @adjectives_quality = %W{awesome shitty amazing dull erotic hectic sexy enchanting unforgettable legendary fucked-up}
    @adjectives_big = %w{gargantuan giant gigantic ginormous goodly grand great immense imposing impressive piled\ high plentiful plump portly powerful prodigious swollen}
    @animal_actions = %w{walk groom neuter spay relate\ to breed}
    @related_person = %w{sister brother teacher doctor mom dad best\ friend neighbor classmate totally\ gay\ friend co-worker creepy\ neighbor pregnant\ cousin best\ friend boyfriend bride bridegroom brother bud buddy manager bro homie lover neighbor housekeeper sexually\ confused\ MMA\ opponent fuck-buddy rival creepy\ roommate anal\ slave}
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
    @housing = ['cabin', 'caravan', 'castle', 'pimp-ass crib at my parent\'s house', 'chateau', 'condo', 'condominium', 'co-op', 'sex cottage', 'country house', 'crib', 'dojo', 'disgusting shithole', 'filthy trailer', 'terraced house', 'homeless shelter', 'townhouse', 'tract house', 'trailer home', 'treehouse', 'triplex', 'friend\'s shack', 'ranch house', 'real estate', 'residence', 'residential hall', 'party shack', 'goddamn Italian villa', 'row house', 'palace', 'hotel room', 'life-size replica of Harry Potter\'s aunt and uncle\'s house', 'creepy log cabin', 'pup tent', 'wigwam']
    @housing_events = ['burnt down', 'was flooded', 'got eaten by Galactus', 'exploded', 'got featured in a magazine', 'is still really shitty', 'is not a place I\'d like to live', 'is my new home']
    @housing_adjectives = %w{charming elegant filthy condemned infested cleanest}
    @most_least = %w{most\  least-}
    @places_proper = ['New York', 'Iowa', 'my hood', 'Compton', 'Western Canada', 'this lousy town', 'the ghetto', 'Hell', 'outer space', 'France', 'Germany', 'Detroit', 'Philadelphia', 'Atlanta', 'the middle of the Sahara Desert', 'Texas', 'Australia', 'Tokyo', 'Mongolia', 'San Francisco', 'Oakland', 'Planet Telezart', 'Florida']
    @places_outdoor = %w{swamp forest desert wilderness tundra jungle lava\ field}
    @activities = ['have a quiet nipple moment', 'find love', 'get laid', 'get murdered', 'learn how to love', 'find a unicorn', 'cruise for dick in the Home Depot restrooms', 'have the living shit kicked out of me by gay skinheads', 'achieve inner peace', 'fuck a hole in the wall', 'make some poor life choices', 'fuck every homeless guy in town', 'masturbate like the world is ending', 'really turn some heads at the next Renn Faire swingers\' club meeting', 'knit sweaters until my fingers fall off', 'be loved by others', 'open my emotions', 'admit that I\'m a cum-hungry maniac']
    @activities_sexual_current = ['get a handjob', 'piss in each others\' mouths', 'dry hump', 'awkwardly masturbate', 'experiment with assplay', 'hit it doggy-style', 'explore the limits of pleasure', "go balls deep in a #{(@related_person + @animals).sample}"]
    @verbs_sexual = ['awkwardly fondling', 'fucking', 'sucking off', 'licking', 'plowing my cock into', 'going balls-deep inside', 'blowing a load in', 'rubbing my clit on', 'getting my asshole filled by', 'getting a vagina full of']
    @game_consoles = ['Colecovision', 'Nintendo64', 'Sega Dreamcast', 'Super Nintendo', 'GameBoy Color', 'Sega Master System', 'Neo-Geo', 'Nintendo','XBox','XBox 360', 'Playstation 4', 'Wonder Swan', 'Vectrex', 'Nintendo 3DS', 'Turbografx-16', 'Sega Genesis', 'Super Nintendo', 'Gamecube', 'Wii', 'Wii U', 'XBox One', 'Atari Jaguar']
    @game_console_features = ['controller ports', 'electronic jibber-gabber', 'megaflops', 'pixels', 'sensitive areas', 'graphics chips', 'blast processing', 'optical drive', 'USB-powered rubber vagina']
    @emotions = ['remorse', 'melancholy', 'emotions', 'regrets', 'joyousness', 'happiness']
    @diseases = ['AIDS','a prolapsed rectum','penis sores','a cold','the flu','food poisoning','cancer', 'cystic fibrosis', 'kennel cough', 'fetal alcohol syndrome', 'constant migraines', 'dehabilitating erections', 'excessivly sweaty tits', 'unruly nipples', 'chlamydia', 'angry nipples', 'hepatitis', 'retard-face', 'ass drizzle', 'body odor', 'maybe the most disgusting asshole ever']
    @person_to_person_activities = ['got high on PCP and stole a car with', 'gave a handjob to', 'cuddled with', 'explored nipple torture with', 'got a handjob from', 'smoked up with', 'rubbed nipples with', 'fucked', 'got fucked by', 'freestyle rhymed with', "discussed #{@properties.sample} with", 'got drunk and had a knife fight with', 'had sex until I lost control of my bowels all over', 'shot a load all over', 'threw up on']
    @sexual_noun = ['prostate massage','orgasm','blowjob','handjob','fingerbang','nipplejob','load of man-batter','shoebox full of pubes','sexual ass-kicking','haymaker to the taint']
    @adjectives = ['cursed', 'clean', 'enchanted', 'filthy', 'infected', 'vomit-covered', 'flaming']
    @type_of_person = ['robot with a mysterious past', 'killer robot', 'aging liberal with a lisp', 'creepy lumberjack', 'imp', 'terrified child', 'libertarian asshole', 'confused elderly man', 'chubby nerd', 'Christian fundamentalist', 'meth addict', 'black guy', 'poet', 'biker', 'double amputee', 'Pokemon master', 'femme fatale', 'toddler', 'hobo', 'Mexican drug lord', 'frat guy', 'hipster', 'librarian', 'austistic savant', 'college student', 'cowboy', 'sexually active homeless veteran', 'real tough hombre', 'lonely phone sex operator with a drinking problem']
    @personal_enhancements = ['getting fucked until I can\'t walk any more','gentle kissing','finding love','washing my genitals', 'allowing myself to be sexual', 'breast feeding a stranger', 'getting a sex change','taking vitamin E','snorting my mother\'s ashes', 'eating bananas until I puke', 'fucking up a stranger\'s life for no reason','shaving my ass','getting nipple implants','murdering a child','pissing all over myself']
    @adjectives_sexual = ['enigma','monster', 'dynamo','force','juggernaut','tyrannosaurus','beast','force to be reckoned with','disappointment','failure','disaster','hero','legend']
    @preambles = ["Despite enjoying the sex","I don\'t care how many orgasms I had","After last night","Now that my butt is all stretched out","Despite a weekend of near-consecutive orgasms","Considering my multiple ass fractures","After a fucking like that","Now that I\'ve been acquitted on a technicality"]
    @reactions = ["are still addicted to huffing glue and being a slut","weren't actually my cousin","expect me to pay for the date", "demand more than $20", "attempt to murder me first", "immediately run away, screaming", "woke up before I finished", "decide to ever find love again", "aren't afraid of my dark side", "hit me in the face with that dildo until I lose consciousness", "don't mind the fact that I'm a complete fucking loser", "have any self esteem left at all", "have anything left to live for", "don't have anything better to do", "are gullible enough to think I'm a witty intellectual", "promise not to tell my mom about it", "aren't too pregnant"]
    @academic_topics = ["Arthurian legends", "sexual folk tales", "philosophy", "math", "science", "current events", "total bullshit", "martial arts", "sexual health", "oncology", "computer science","Tibetan throat singing","massage therapy","the depths of my soul","calculus", "words that have more than one or two syllables","the kind of shit you need to know if you're ever going to be stop being a pussy and be a serious Jeopardy! contender, for fuck's sake"]
    @events = %w{Collosalcon Dragon*Con Otakon BootyCon BronyFest Katsucon MAGFest}

    @private_message_sentence_templates = [
      "#{['Saw your profile and thought I\'d say hello!', 'Hi,', 'Yo!', 'Let me introduce myself!', 'Despite what you may have heard about me,', 'Hello and fuck the haters,', 'Hello... '].sample} I'm a #{@type_of_person.sample}.",
      "#{['Dude! So','Hey...','Sorry to ask! But...','Just wondering,'].sample} are you done with my #{@game_consoles.sample} yet? I need it back before #{['I hit puberty','I fuck you up','my mom has her nipples removed','my party','I lose my mind','my prison sentence starts','people think I\'m gay'].sample}.",
      "#{['What a coincidence!','I think I know you!', 'We meet again!'].sample} I'm the person with the #{(@game_consoles + @diseases + @animals).sample} that you #{@verbs_past.sample} at #{@events.sample}#{%w{! . \ ...right?}.sample}",
      "#{['I am high on cough syrup right now', 'I enjoy getting to know people', 'Just joined this site', 'Been on this site for a while', 'I just emerged from a coma'].sample} #{['and I immediately regret it', 'and I saw your profile', 'and I have nothing left to lose since I have less than a month to live thanks to my fatal case of ' + @diseases.sample].sample} #{%w{so and}.sample} I #{['figured you\'d be an easy lay', 'wanted to introduce myself', 'was hoping we could be friends', 'decided to embarrass myself by messaging you', 'figured I should be a little more social', 'wanted to show you how awesome I am'].sample}.",
      "#{['We haven\'t talked before', 'Hi! I am nervous saying this', 'Hope you don\'t think I\'m weird', 'I know we\'re part of rival ninja clans and I killed your family'].sample} but you seem like my type of #{%w{friend pal homie lover partner\ in\ crime}.sample}!",
      "#{['You should know that', 'Just wanted to say that', 'I agree with everybody else when they say'].sample} you are #{%w{brilliant beautiful loved amazing special}.sample}. You #{['inspire me','make me feel awesome','deserve love and respect','are going to rule the world someday','are honestly the best person I have ever met'].sample}.",
      "#{['Thanks', 'Bless you', 'I can never repay you', 'Thank you', 'You are so awesome'].sample} for #{['cheering me on', 'supporting me', 'helping me cope', 'not being a total asshole', 'wiping my tears away', 'listening to me cry'].sample} when my #{(@related_person + @animals).sample} #{['was having a rough time', 'was kidnapped', 'seemed to be depressed', "went missing at #{@events.sample}", 'experienced love for the first time', 'was discovered to be the 12th Angel and was destroyed by NERV', 'reached level 70 in World of Warcraft', 'couldn\'t stop farting', 'got sad'].sample}. #{['That meant a lot to me', 'You are really as wonderful as everybody says', 'It really gave me hope', 'My nipples tingled for weeks after I read your message'].sample}.",
      "#{['So... about last ' + @timespan.sample + '.', 'We should talk.', 'Um. Okay. I\'ll just say it.', 'Hey. So, yeah.'].sample} #{@preambles.sample}, I can't believe you #{@reactions.sample}!",
      "#{['Thanks for inviting me to','I got the invitation to','I\'d love to join you at'].sample} your #{['party','dad\'s funeral','circumcision','sex club','birthday party','sad little gathering','frat house','sex mattress in the woods'].sample}, but I'll be busy #{@personal_enhancements.sample} tonight.",
      "#{%w{Whoa Damn Hey}.sample}, I was #{%w{browsing stalking looking shopping masturbating}.sample} through the profiles on this site and I was #{%w{amazed enchanted capitivated aroused delighted}.sample} by your #{@body_parts.sample}.",
      "#{['You need to', 'Please', 'Hey! Need you to'].sample} #{%w{start stop}.sample} trying to #{%w{impregnate contact write message call}.sample} me. You are #{['scary','probably contagious','my sibling','the smelliest person on Earth','a few sandwiches short of a picnic','probably a murderer','so intensely sexual that my genitals are about to combust'].sample}.",
      "I love you. Forever and always.",
      "Just wondering how things are going.",
      "#{['Honestly,','Frankly,','I have to say --','Surprisingly,','Now that we did some kissing'].sample} I'm not mad that you #{['stabbed me','dumped me','stole my car','built a life-size replica of me out of Legos','banged my friend'].sample}, even if it's a little #{%w{weird odd confusing}.sample}."
    ]

    @post_reply_sentence_templates = [
      "I #{['slowly ','eagerly ','methodically ','totally ','','',''].sample}#{['jerked off to', 'read', 'absorbed', 'read and barely understood -- yet thoroughly enjoyed --', 'consumed'].sample} #{['the latest incoherent mess you posted in the forums', 'the brilliant thing you said', 'that post you made', 'the bullshit you posted', 'the knowledge you dropped in the forums', 'the thing you said', 'your incessant blabbering'].sample} and it made me want to #{['kiss you', 'rub my nipples all over you', 'become a robot', 'have a sex change', 'touch myself in forbidden ways', 'punch myself in the face', 're-examine some things inside of myself, spiritually speaking','forget about it as soon as possible', 'travel back in time and murder you before you had a chance to post it', 'be a better person'].sample}.",
      "This post made me think about the time I #{@person_to_person_activities.sample} #{['my','your','a','somebody\'s'].sample} #{(['','','','','',''] + @personal_qualities).sample} #{@type_of_person.sample} back in #{@places_proper.sample}.",
      "It was really #{['brave','inspirational','sexual','hot','thoughtful'].sample} of you to share this in your post.",
      "#{['Sitting', 'As I ponder the end of the universe', 'Despite having only two weeks to live', 'With the help of somebody who understands big words'].sample} here in my #{@rooms.sample}#{[' and probably because I\'m really drunk', ' and even though I\'m hooked up to some kind of crazy cyborg life-saving machines', ' and even though I\'m so hungover that I think I will die',' and even though I\'m a real joyless asshole who has no emotions',' and despite giving up on life once I found every single Pokemon','','','','','',''].sample}, #{['I laughed out loud','I cried','I nearly punched my mom','tears rolled down my cheeks','I took a massive bong rip','I literally shit my pants'].sample} when I read this post#{%w{! . ??}.sample}",
      "#{%w{Thank Fuck Bless Love}.sample} you for posting this! This is the #{%w{best worst dumbest most\ brilliant}.sample} thing I've read in a while!"
    ]

    @post_reply_second_sentence_templates = [
      "#{%w{However But Alas... Fuck\ yeah Shit\ yes}.sample}, there #{['is no', 'is many a'].sample} #{%w{flaw problem boner merit}.sample} in your #{%w{reasoning premise story rambling brilliant\ monologue confused\ mumbling}.sample}.",
      "#{%w{Despite Thanks\ to Because\ of}.sample} your post, I'll probably #{['achieve enlightenment', 'get laid a little more often', 'grow my pubes out', 'join a cult', 'jerk off into my ' + @game_consoles.sample, 'marry a hooker in order to save her soul'].sample}.",
      "I always suspected you had #{@diseases.sample}, and it was courageous of you to share that.",
      "I can't wait to see what falls out of your #{@body_parts.sample} next.",
      "Reading your words was like #{['enjoying', 'having', 'missing out on', "finding out my #{@related_person.sample} had"].sample} a #{['revelation', 'messy period', 'ephipany', 'abortion', 'satisfying meal', 'delightful afternoon frolic'].sample} while #{['my dad yells at me', 'somebody hammers nails into my head', 'hang-gliding through the Grand Canyon', 'jabbing myself in the dick with a pair of scissors', 'simultaneously finding out I won the lottery'].sample}.",
      "#{['So','And','I just wanted you to know','I cherish you and'].sample} that's why I love reading your posts.",
      "Please keep posting about this stuff!",
      "What a delight your posts are."
    ]

    @post_reply_closer_templates = [
      "Keep up the good posting! #{['You crazy fucker!','You son of a bitch!','','','',''].sample}",
      "Thanks for making my #{['nipples pop','morning','day','night','heart pitter-patter'].sample}.",
      "I guess what I'm saying is that posts like this make #{['my head hurt', 'me want to kick a fucking baby', 'scrub my eyes with bleach', 'feel like a goddamn unicorn', 'want to choke on my own dick, which seems difficult', 'glad I found this amazing community', 'want to keep using these forums'].sample}.",
      "You're a real ace.",
      "I appreciate your writing a lot!",
      "You make this community great.",
      "#{["So what do you think about","Are you aroused by","Are you suprised that I'm too drunk to have any idea"].sample} what I said?",
      "And that's pretty much all I can write, before the #{%w{arousal pain}.sample} from this #{@diseases.sample} becomes #{['too much','so delightful I just want to focus on it','unbearable','too bad to allow me to continue writing, but still more enjoyable than reading your fucking posts'].sample}."    
    ]

    @private_message_second_sentence_templates = [
      "I was wondering if you'd like to #{['be my friend','see a movie sometime','cherish these charming memories','forget about the $50 I owe you','make a little money by starring in a porno','blow up an orphanage together', 'pretend we\'re robots while we have violent sex'].sample}?",
      "you should know that everybody #{['thinks you are great', 'wants to be awesome like you, because you inspire people','values your mind too, even though you are really hot','wishes they could kiss you'].sample}.",
      "I need some advice regarding my #{['overclocked ','water-cooled ','semen-powered ','jailbroken ','','','',''].sample}#{@game_consoles.sample}'s #{@game_console_features.sample} -- #{['why are they full of semen?', 'I think I need to upgrade the gigahertz?', 'gotta be USB 4.0 compatible, right?', 'because I have definitely burned my nipples trying to fix this on my own.', 'I really have my dick in a knot over this!'].sample} ",
      "I want you to know that I, too, am a #{@type_of_person.sample}.",
      "sometimes I just want to know I'm not the only one into #{@personal_enhancements.sample}.",
      "I want you to help me #{@animal_actions.sample} my #{(@animals + @dogs).sample}.",
      "I'm willing to fly you to #{@places_proper.sample}. #{['Once we\'re there, expect the ' + @sexual_noun.sample + ' of your life', 'Of course, I won\'t be there', 'It is the place of my most ' + @adjectives_quality.sample + ' memories', 'They say it is a place to fall in love or experience ' + @emotions.sample].sample}.",
      "we should #{@activities_sexual_current.sample} #{%w{tonight sometime right\ now when\ you\'re\ ready}.sample}#{['.', ' while you tell me about your ' + @properties.sample + ' fantasies.'].sample}"
    ]

    @private_message_closer_templates = [
      "So, are you into it or not? Just let me know.",
      "Let me know if this idea #{['turns you on','could lead to a parole violation for one of us','exceeds your capacity for erotic fantasies','is total bullshit','even makes sense'].sample}. #{['Can\'t wait to hear back!','I am just sitting here jerking off in the meantime, so no hurry.', 'Toodles, dickbreath.', 'Hope you agree!', 'Thanks for listening.'].sample}",
      "Hope you agree. If not, #{["we'll always be friends", "I love you anyway", "fuck you... just kidding, we're cool", "you're probably high on antifreeze", "whatever"].sample}.",
      "Oh, and I think you're #{['hot','cool','awesome','probably my mom','a real Jedi, at last', 'wonderful', 'a delight to talk to', 'a real treasure'].sample}.",
      "Peace and love forever!",
      "Talk to you soon.",
      "I guess what I'm trying to say is that you're a real #{@sexual_noun.sample}.",
      "#{["I'm sorry","I know","My mom always said"].sample} I shouldn't let things like this get my #{@body_parts.sample} in #{['an uproar','a knot','a tizzy'].sample}.",
      "I'll write more later. #{["When I'm not so high.","Toodles!","Bye for now!","After my parole hearing.","Hopefully my butt will stop bleeding by then.","Ta-ta!"].sample}",
      "I hope I can buy you a drink someday! Hopefully I'll be #{@verbs_sexual.sample} you at #{@events.sample} later this year.",
      "So yeah, no pressure. It won't be a date or anything. More like #{['the best day of your fucking life', 'a trip to the dentist\'s office, except you\'re having sex with me','your first day in a cult','an AWESOME date', '...wait, actually I have no idea what a date is. I am so lonely'].sample}. #{['Please say yes!','Consider my demands.','We will talk soon!','See ya.'].sample}"
    ]


    @sentence_templates = [
      "I saw your profile and was thinking that I could #{@activities.sample} with you, if you #{@reactions.sample}.",
      "We could #{['hang out','get drunk','get wild','get loose','be a little crazy','rip our clothes up and smear shit all over ourselves like we were homeless maniacs','fight holograms of ourselves','jerk off to art films'].sample} in my #{@housing.sample} and maybe eat #{@food_types.sample} with my #{(@animals + @related_person).sample}#{[" who has actually been dead for a while, which is pretty creepy now that I think about it", " who is so far gone on painkillers that it's not even funny", '','','','','',''].sample}.",
      "#{['Obviously,', 'Hopefully', 'Eventually,', 'Surely', 'By the will of Allah,', 'By great Odin\'s beard,', 'Pretty sure'].sample} you'll want to #{@verbs_person.sample} me.",
      "#{['Just so you know...', 'You seem cool but', 'Since I like you', 'With good looks like these, you better believe'].sample} I'm #{['not trying','trying','expecting'].sample} to #{['buy', 'beg for', 'give you probably fifty bucks for', 'earn', 'give you', 'get', 'allow you to give me'].sample} a #{@sexual_noun.sample} #{['on the first date', 'because what else are we going to do... talk? Yeah, right', 'unless I get cash up front', 'unless you\'re not into that','before we do any kissing', '...because that is the way of my people'].sample}.",
      "#{['You know I love', 'Some of my happiest memories involve', 'I really miss', 'I am totally into'].sample} #{['discussing', 'dissing', 'debating', 'pondering', 'yelling loudly about', 'jerking off to', 'laughing at'].sample} #{(@properties + @academic_topics).sample} together, especially when #{["I've","you've","we've"].sample} had #{['a few', 'countless', 'one or two', 'a near-fatal amount of', 'some'].sample} #{(@vices_plural).sample}.",
      "I've been thinking about you ever since you told me I #{['should learn more about','was a real fucking whiz at','could never hope to understand','look like the kind of asshole who\'s into'].sample} #{(@academic_topics + @programming_languages).sample} and that you #{@verbs_past.sample} my #{(@related_person + @animals).sample}#{[' in a creepy way',' after I passed out',' and got a weird skin rash','','','',''].sample}. Know what? You were #{['probably doing the right thing','so right', 'so wrong', 'a fucking prophet', 'wrong as usual', 'really insightful', 'a big inspiration for my current success'].sample}.",
      "#{['Sometimes,','Thanks to you,','On another topic,','I haven\'t told anybody this yet, but'].sample} I wonder if #{['I', 'my ' + (@dogs + @related_person).sample].sample} #{['should convert to','is obsessed with', 'should be so sexually aroused by','could have some kind of allergy to','might have a thing for'].sample} #{['Scientology', 'rough sex', 'polyamory', 'Islam','Christianity','Buddhism','being a robot','Linux'].sample}. #{['You always make it look like fun.','I would probably get laid more.','I have absolutely nothing better to do, so why not?', "It wouldn't be the weirdest thing that happened this week, that's for sure.", "", "", ""].sample}",
      "I have a lot of #{@emotions.sample}.",
      "Do you know much about #{@academic_topics.sample}? #{['I know I do.', 'I doubt it!', 'I bet you do!', 'You are amazing in a lot of little ways like that.', 'Somebody told me you do, and I called bullshit.', 'I don\'t really care, actually. I was just asking to be polite, but you can still answer if you want. (I won\'t read it though)'].sample}",
      "I enjoyed when I #{@person_to_person_activities.sample} you, and I often think about you while I'm #{@verbs_sexual.sample} #{['myself','somebody else','you in an alternate dimension'].sample}!",
      "Maybe this is why nobody likes me.",
      "It's just like... #{['WHOA','damn','hmmm','tee hee hee','hahaha'].sample}.... #{['why are we even here in this physical world?', 'what is the meaning of love, anyway?', 'can we ever truly understand another person\'s heart?', 'I wish I was banging a huge black dude right now, honestly.', 'how much vodka did I pour into my butt, anyway?', 'sometimes I wish I wasn\'t a mutant.', 'this has been a really tough year for all of us at Hogwarts.'].sample}"
    ]

    @private_message_body_templates = [
      "I know this is a lot to think about, since you're really #{['going through a lot right now', 'kind of simple', 'not that interested in whatever the fuck I\'m saying', 'desperate to fuck me', 'completely illiterate and your mom is probably reading this out loud for you', 'smart and are probably busy thinking about smart people things'].sample}.",
      "I mean, right? Everybody knows that.",
      "That's the kind of thing I've been learning about myself.",
      "Well... hmmm... eeesshhhh",
      "Ah... um....",
      "^_____^ Yayy!!!",
      "This would be easier to say in person. Could we at least Skype or Facetime or something?",
      "I feel like a #{@adjectives_big.sample} #{(@animals + @type_of_person).sample} for writing that, but it's #{["the truth","just something I made up to make you want to have sex with me","...true. All of it.", "a real fucked up situation and I totally need a " + @sexual_noun.sample].sample}.",
      "I just feel this connection with you, and I want to explore #{['our emotions', 'our bodies', 'my butthole', 'space', 'some real Indiana Jones-type shit', 'the crazy-ass time portal I found'].sample} with you.",
      "Can't believe I typed this!!!! o_O;;;",
      "We're kind of alike, aren't we?",
      "Do you think I'm an asshole?",
      "I can't believe I paid for this shitty website.",
      "....so ^^;; ....well....",
      "Yeah, yeah. I'm bad at expressing myself.",
      "Or maybe not. Whatever, dude.",
      "Wink, wink, nudge, nudge. Know what I mean?"
    ]
  end
  # Test every template to make sure there are no rendering errors 
  def test_sentence_templates
    @sentence_templates.each { |template| 
      puts render_sentence(template) 
    }
  end 

  def test_post_reply_sentence_templates
    @post_reply_sentence_templates.each { |template| 
      puts render_sentence(template) 
    }
  end 

  def test_post_reply_second_sentence_templates
    @post_reply_second_sentence_templates.each { |template| 
      puts render_sentence(template) 
    }
  end 

  def test_private_message_sentence_templates
    @private_message_sentence_templates.each { |template| 
      puts render_sentence(template) 
    }
  end 

  def test_private_message_second_sentence_templates
    @private_message_second_sentence_templates.each { |template| 
      puts render_sentence(template) 
    }
  end 

  def get_private_message_body(sentence_count_range) 
    sentence_count = (sentence_count_range).to_a.sample
    
    result = render_sentence(@private_message_sentence_templates.sample)
    return result if sentence_count == 1

    second_sentence = render_sentence(@private_message_second_sentence_templates.sample)
    second_sentence[0] = second_sentence[0].downcase unless second_sentence[0] == 'I'
    result << [" Despite that"," And that's why"," So maybe that's why"," This is a big step for us but", " I can't help but think"].sample << ' ' << second_sentence
    return result if sentence_count ==2

    result << "\n"
    (sentence_count-3).times {
      result << render_sentence((@sentence_templates + @private_message_body_templates).sample) << ' '
    }

    result << "\n" << render_sentence(@private_message_closer_templates.sample)
    result
  end 

  def get_private_message_post_reply_body(sentence_count_range) 
    sentence_count = (sentence_count_range).to_a.sample
    
    result = render_sentence(@post_reply_sentence_templates.sample)
    return result if sentence_count == 1

    
    result << ' ' << render_sentence(@post_reply_second_sentence_templates.sample)
    return result if sentence_count ==2

    result << "\n"
    @sentence_templates.sample(sentence_count-3).each { |words|
      result << render_sentence(words) << ' '
    }

    result << "\n" << render_sentence((@post_reply_closer_templates + @private_message_closer_templates).sample)
    result
  end


  def get_sentences(sentence_count_range)
    result = String.new

    rand(sentence_count_range).each {
      result << render_sentence(@sentence_templates.sample) << ' '
      result << "\n" if rand(0..3) == 0
    }
  end 

  def render_sentence(template)
    begin 
      text = Kernel.eval("\"" + template + "\"")
    rescue Exception => e
      puts "HalfSavageMessages: couldn't render! (level 1)"
      puts "Template: #{template}"
      puts "Error: #{e}"
    end 
    begin 
      text = Kernel.eval("\"" + text + "\"")
    rescue Exception => e
      puts "HalfSavageMessages: couldn't render! (level 2)"
      puts "Template: #{template}"
      puts "Error: #{e}"
    end
    text[0] = text[0].capitalize 
    text
  end 
end 





=begin
hsm = HalfSavageMessages.new 

puts "---Post replies---"
hsm.test_post_reply_sentence_templates
puts "\n---Post 2nd sentences--"
hsm.test_post_reply_second_sentence_templates
puts "\n---Private message openers--"
hsm.test_private_message_sentence_templates
puts "\n---Private message 2nd sentences--"
hsm.test_private_message_second_sentence_templates
puts "\n---Regular filler sentences---"
hsm.test_sentence_templates
(1..6).each { |x| 
  puts "\n---Private message body (~#{x} sentences)---"
  puts hsm.get_private_message_body(x..x)
}
(1..6).each { |x| 
  puts "\n---Post reply message body (~#{x} sentences)---"
  puts hsm.get_private_message_post_reply_body(x..x)
}
=end