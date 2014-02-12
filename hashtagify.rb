require "debugger"

class String
  @@junk_words = %w{the a an than then he she it is such up down as for in the a one some and but or few aboard about above across after against along amid among anti around as at before behind below beneath beside besides between beyond but by concerning considering despite down during except excepting excluding following for from in inside into like minus near of off on onto opposite outside over past per plus regarding round save since than through to toward towards under underneath unlike until up upon versus via with within without}

  def junk_word?
    return true if self.length <= 2
    @@junk_words.any?{ |s| s.casecmp(self)==0 }
  end 

  def hashtagify!(chance_of_hashtagification = 0.1)
    words = self.scan(/\b(\w+?)\b/)
    words.each { |word|
      puts word[0]
      self.sub!(word[0], '#' + word[0]) if ((rand < chance_of_hashtagification) && (!word[0].junk_word?))
    }
  end 
end

FORUM_SPECIFIC_HASHTAGS = {
  'Events' => %w{halfsavagecon sausagefest wrestlemania dragoncon MAGfest katsucon otakcon},
  'Look What I Made' => %w{photoshop music video amatuerporn selfie},
  'Sex & Relationships' => %w{sex blowjobs genitalwarts dumped single casualencounters},
  'Video Games' => %w{Sony Microsoft Nintendo 3ds ps4 xbox Halo dukenukem titanfall assasinscreed graphicscards atari colecovision},
  'Tabletop Gaming' => %w{warhammer catan d20 arkhamhorror eldritchhorror hexhex numenera pathfinder kingoftokyo carcassonne munchkin},
  'Cooking, Baking, Dining' => %w{truffles paleo cupcakes cronuts potroast protein yummy},
  'Deals' => %w{bogo rebate newegg slickdeals ebay woot},
  'TV Series' => %w{homefront gameofthrones bigbangtheory killlalkill firefly doctorwho theitcrowd parksandrecreation},
  'Movies' => %w{fakemovieone fakemovietwo adventuresoffartman starwars fakemovieblahblah},
  'Half Savage Coders' => %w{csharp python ruby rails django functional haskell},
  'Crafting' =>  %w{knitting painting drawing butter-sculptures}
}

body = "I am having a shit fit today! My whale is going to the beach and wants to frolic in the ice cream. He is crazy!"
body.hashtagify!(1)
puts body


=begin
puts "Is".junk_word?
puts "fart".junk_word?
puts "he".junk_word?
puts "z".junk_word?
=end