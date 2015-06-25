json. @nearest_metro do |metro|
  # json.title item.title
  # json.description item.description
  # json.created_at item.created_at
  json.(nearest_metro, :title, :description, :created_at)
  json.price item.display_price
end