json.array!(@relationships) do |relationship|
  json.extract! relationship, :id, :member_id, :member_id
  json.url relationship_url(relationship, format: :json)
end
