json.array!(@sample_classes) do |sample_class|
  json.extract! sample_class, :id, :description, :number_of_bloits
  json.url sample_class_url(sample_class, format: :json)
end
