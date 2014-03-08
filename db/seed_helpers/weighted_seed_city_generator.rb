class City 
  attr_accessor :country, :name, :region, :population, :latitude, :longitude
  
  def initialize(country, name, region, population, latitude, longitude)
    @country= country
    @name= name
    @region= region
    @population= population
    @latitude= latitude 
    @longitude= longitude
  end

  def to_s
    "#{@name}, #{@region} #{@country.upcase} (pop: #{@population})"
  end 
end 


class WeightedSeedCityGenerator

  # Selects a "weighted random" city. In other words, a city with a population of 100,000
  # should be 10x more likely to be chosen than a city with a population of only 10,000.
  # This ensures a realistic distribution of locations for randomly generated members
  # than if we randomly picked cities, ignoring their relative populations

  def self.get_weighted_random_city() 
    city=nil
    while city.nil?
      city = @@cities.sample 
      city = nil if rand(0..@@total_population) > city.population
    end 
    city
  end 

  
private 
  @@cities = nil
  @@total_population = 0

  def self.load_cities(city_file_name)
    @@cities = Array.new
    File.open(city_file_name, 'r') do |f1|
      while line = f1.gets
        city_data = line.split("\t")
        @@cities << City.new(city_data[0], city_data[2], city_data[3], city_data[4].to_i, city_data[5], city_data[6])
        @@total_population += city_data[4].to_i
      end
    end
    puts "Read #{@@cities.length} cities, with a total population of #{@@total_population}."
  end
end 

=begin
WeightedSeedCityGenerator.load_cities('cities-with-population-us.txt')
puts WeightedSeedCityGenerator.get_weighted_random_city
puts WeightedSeedCityGenerator.get_weighted_random_city
puts WeightedSeedCityGenerator.get_weighted_random_city
=end