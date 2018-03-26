#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'Create table if not exists "Posts"
	(
		"id" integer primary key autoincrement,
		"author" text,
		"post" text,
		"created_date" date
	)'
end


get '/' do
	@posts = @db.execute 'select * from Posts'
	erb :timeline
end


get '/new' do
	erb :new
end

post '/new' do
	nickname = params[:nickname]
	post = params[:post]

	hh = {:nickname => 'Enter name', :post => 'Enter post'}

	@error = hh.select { |key,_| params[key] == ""}.values.join(", ")

	if
		@error != ""
		return erb :new
	else 
		@db.execute 'insert into Posts (post, author, created_date) values (?, ?, datetime())', [post, nickname]		
		@info =  "#{nickname} your post added to Timeline. You will be automaticaliy redirected in 2 sec."
		redirect to '/'
	end
end

get '/post-details/:post_id' do
	post_id = params[:post_id]
	erb :post_details
end