json.array!(@profile_views) do |profile_view|
  json.extract! profile_view, :id, :member_id, :member_id, :tally
  json.url profile_view_url(profile_view, format: :json)
end
