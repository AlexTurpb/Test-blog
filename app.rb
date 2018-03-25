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
	@info =  "test #{nickname} <br/> #{post}"
	erb :new
end
