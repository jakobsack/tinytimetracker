json.array!(@projects) do |project|
  json.extract! project, :id, :user_id, :name, :color, :parent_id
  json.url project_url(project, format: :json)
end
