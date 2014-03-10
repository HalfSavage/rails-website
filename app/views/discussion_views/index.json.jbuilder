json.array!(@discussion_views) do |discussion_view|
  json.extract! discussion_view, :id, :post_id, :member_id, :tally
  json.url discussion_view_url(discussion_view, format: :json)
end
