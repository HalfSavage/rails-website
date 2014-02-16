class Tag < ActiveRecord::Base
  # TODO: add relation to PostTag and Post (through PostTag)

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