require 'sinatra'
require 'json'

BLOG_FILE_PATH = 'blog_posts.json'

def read_blog_post
  if File.exist?(BLOG_FILE_PATH)
    JSON.parse(File.read(BLOG_FILE_PATH))
  else
    []
  end
end

def write_blog_post(post)
  posts = read_blog_post
  posts << post
  File.open(BLOG_FILE_PATH, 'w') do |file|
    file.write(JSON.pretty_generate(posts))
  end
end

get '/' do
  @posts = read_blog_post
  erb :index
end

post '/create' do
  post = {
    title: params[:title],
    content: params[:content],
    created_at: Time.now
  }
  write_blog_post(post)
  redirect '/'
end
