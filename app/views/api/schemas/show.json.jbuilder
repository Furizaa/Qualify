json.data do
  json.type 'schema'
  json.id @schema.uuid
  json.name @schema.name
  json.(@schema, :created_at, :updated_at)
  json.links do
    json.self "/schema/#{ @schema.uuid }"
  end
end
