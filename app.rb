#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
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
			@info =  "#{nickname} your post #{post} added to db"
			return erb :new
	end
end
