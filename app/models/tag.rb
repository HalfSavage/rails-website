class Tag < ActiveRecord::Base
  # TODO: add relation to PostTag and Post (through PostTag)
  attr_accessor :score

  scope :trending, -> {
    puts "fart"
    joins("inner join tags_trending tt on tt.tag_id = tags.id ").order("score desc")
  }


  def self.trending_in_forum(f)
    fid = (f.is_a? Forum) ? f.id : f.to_i 
    joins("inner join tags_trending_by_forum ttbf on ttbf.tag_id = tags.id and ttbf.forum_id = #{fid}")
  end 

  def self.find_by_tag_or_new(tag_text)
    tag = Tag.where('lower(tag_text)=lower(?)',tag_text.downcase).first
    if tag then 
      #puts "ok! found a tag!"
      return tag
    end 
    #puts "made a new tag 4 u d00d #{tag_text}"
    Tag.new(tag_text: tag_text)
  end 
end 