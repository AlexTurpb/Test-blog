#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/timeline' do
	erb :timeline
end

get '/new' do
	erb :new
end
