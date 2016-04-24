json.array!(@records) do |record|
  json.extract! record, :id, :user_id, :project_id, :begun_at, :ended_at
  json.url record_url(record, format: :json)
end
