json.data @api_keys do |api_key|
  json.type 'api_key'
  json.key api_key.key
  json.(api_key, :created_at, :updated_at)
  json.links do
    json.self "/api_keys/#{ api_key.key }"
    json.account do
      json.self "/accounts/#{ api_key.account.id }"
    end
  end
end
