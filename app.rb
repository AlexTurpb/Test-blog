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

	@db.execute 'Create table if not exists "Comments"
	(
		"id" integer primary key autoincrement,
		"post_id" integer not null,
		"comment_author" text,
		"comment" text,
		"created_date" date
	)'
end


get '/' do
	@posts = @db.execute 'select * from Posts order by id'
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
	@comments = @db.execute 'select * from Comments where post_id =?', [post_id]

	post_det = @db.execute 'select * from Posts where id = ?', [post_id]
	@single_post = post_det[0]

	erb :post_details
end

post '/post-details/:post_id' do
	post_id = params[:post_id]
	comment_author = params[:comment_author]
	comment = params[:comment]
	
	@db.execute 'insert into Comments (post_id, comment_author, comment, created_date) values (?, ?, ?, datetime())', [post_id, comment_author, comment]
	redirect to('/post-details/' + post_id)
end