require 'sinatra'
require 'json'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins 'http://localhost:8080'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

helpers do
  def parse_json_body
    raw_body = request.body.read
    return {} if raw_body.strip.empty?

    JSON.parse(raw_body)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON payload.' }.to_json
  end

  def validate_task_payload!(payload)
    unless payload.is_a?(Hash)
      halt 400, { error: 'Request body must be a JSON object.' }.to_json
    end

    title = payload['title']
    description = payload['description']
    errors = []

    if !title.is_a?(String) || title.strip.empty?
      errors << 'Title is required.'
    elsif title.strip.length > 255
      errors << 'Title must be 255 characters or fewer.'
    end

    if !description.is_a?(String) || description.strip.empty?
      errors << 'Description is required.'
    elsif description.strip.length > 1000
      errors << 'Description must be 1000 characters or fewer.'
    end

    return { title: title.strip, description: description.strip } if errors.empty?

    halt 400, { error: 'Invalid task data.', details: errors }.to_json
  end

  def find_task!(task_id)
    task = tasks.find { |t| t[:id].to_s == task_id }
    halt 404, { error: 'Task not found.' }.to_json unless task

    task
  end
end

tasks = []

post '/api/v1/tasks' do
  payload = parse_json_body
  sanitized_task = validate_task_payload!(payload)

  new_task = {
    id: Time.now.to_i,
    title: sanitized_task[:title],
    description: sanitized_task[:description]
  }

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
  task = find_task!(task_id)
  content_type :json
  task.to_json
end

put '/api/v1/tasks/:id' do |task_id|
  task = find_task!(task_id)
  payload = parse_json_body
  sanitized_task = validate_task_payload!(payload)

  task[:title] = sanitized_task[:title]
  task[:description] = sanitized_task[:description]
  status 200
  content_type :json
  task.to_json
end

delete '/api/v1/tasks/:id' do |task_id|
  task = find_task!(task_id)
  tasks.delete(task)
  status 204
end
