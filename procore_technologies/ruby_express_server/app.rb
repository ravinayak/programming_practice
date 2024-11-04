require 'sinatra'
require 'json'

items = []

get '/items' do
  content_type :json
  { status: 200, description: 'Items', items: }.to_json
end

get '/items/:id' do
  content_type :json
  item = items.find { |i| i.id == params['id'].to_i }
  if item
    { status: 200, description: 'Item Found Successfully', items: [item] }.to_json
  else
    { status: 404, description: 'Item Not Found' }.to_json
  end
end

post '/items' do
  content_type :json
  data = JSON.parse(request.body.read)
  new_item = {
    id: items.size + 1,
    name: data['name'],
    description: data['description']
  }
  items << new_item
  { status: 200, description: 'New Item Created', items: [new_item] }.to_json
end

put '/items/:id' do
  content_type :json
  data = JSON.parse(request.body.read)
  item = items.find { |i| i.id == data['id'].to_i }
  if item
    item.name = data['name'] if data['name']
    item.description = data['description'] if data['description']
    { status: 200, description: 'Item Updated Successfully', items: [item] }.to_json
  else
    { status: 404, description: 'Item Not Found' }
  end
end

delete '/items/:id' do
  content_type :json
  item = items.find { |i| i.id == params['id'].to_i }
  if item
    { status: 200, description: 'Item Deleted', items: [item] }.to_json
  else
    { status: 404, description: 'Item Not Found' }.to_json
  end
end

# Curl Requests
# 1. curl http://localhost:4565/items
# 2. curl -X POST http://localhost:4565/items -H "Content-Type: application/json" -d '{"name": "Item 1", "description": "This is the first item"}'
# 3. curl http://localhost:4565/items/1
# 4. curl -X PUT http://localhost:4565/items/1 -H "Content-Type: application/json" -d '{"name": "Item 1 Updated", "description": "Item 1 updated description"}'
# 5. curl -X DELETE http://localhost:4565/items/1
# When using curl, here are few important things:
# 1. -X => Used to Specify Http method
# 2. http method must be in caps lock => PUT, and NOT Put
# 3. -H => "Content-Type: application/json"
# 4. -d => Used to specify data => '{"name": "Item 1", "description": "Item 1 Description"}'
