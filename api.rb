require 'sinatra'
require 'json'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins 'http://localhost:8080'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

tasks = []

post '/api/v1/tasks' do
  request_body = JSON.parse(request.body.read)
  new_task = { id: Time.now.to_i, title: request_body['title'], description: request_body['description'] }
  tasks << new_task
  status 201
  content_type :json
  new_task.to_json
end

get '/api/v1/tasks' do
  content_type :json
  tasks.to_json
end

get '/api/v1/tasks/:id' do |task_id|
  task = tasks.find { |t| t[:id].to_s == task_id }
  if task
    content_type :json
    task.to_json
  else
    status 404
  end
end

put '/api/v1/tasks/:id' do |task_id|
  task = tasks.find { |t| t[:id].to_s == task_id }
  if task
    request_body = JSON.parse(request.body.read)
    task[:title] = request_body['title']
    task[:description] = request_body['description']
    status 200
    content_type :json
    task.to_json
  else
    status 404
  end
end

delete '/api/v1/tasks/:id' do |task_id|
  task = tasks.find { |t| t[:id].to_s == task_id }
  if task
    tasks.delete(task)
    status 204
  else
    status 404
  end
end
