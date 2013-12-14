require 'marky_markov'

class HalfSavageBodies < MarkyMarkov
  def initialize()
    puts 'this is super!'
    super 
    puts 'that was super'
    # read dictionaries 
  end   
end


foo = HalfSavageBodies.new
