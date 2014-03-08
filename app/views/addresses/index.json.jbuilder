json.array!(@addresses) do |address|
  json.extract! address, :id, :address_1, :address_2, :city, :region, :country, :latitude, :longitude, :member_id
  json.url address_url(address, format: :json)
end
