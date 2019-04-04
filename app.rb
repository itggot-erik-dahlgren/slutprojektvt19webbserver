require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'byebug'
require_relative 'fil.rb'

enable :sessions

get ('/') do
    slim(:index)
end

get ('/:id/home') do
    verify_login(session[:id])
    slim(:home)
end

get ('/create_user') do
    slim(:create_user)
end

get ('/login') do
    slim(:login)
end

get ('/error') do
    slim(:error)
end

post ('/login') do
    login(params["name"], params["password"])
end

post ('/create_user/new') do
    create_user(params["re_password"], params["password"], params["name"], params["email"])
    redirect('/')
end