require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require 'byebug'
require_relative 'model.rb'
include MyModule
enable :sessions

# Display Landing Page
#
get ('/') do
    slim(:index)
end

# Display home page
#
# @see MyModule#verify_login
# @see MyModule#select_products_sql
get ('/home') do
    if verify_login(session[:id])
        products = select_products_sql()
        slim(:home, locals:{
            products: products})
    end
end

# Displays site for creating new user
#
get ('/create_user') do
    slim(:create_user)
end

# Displays site for login into an account
#
get ('/login') do
    slim(:login)
end

# Function to logout of an account and redirects to '/'
#
get ('/logout') do
    session.clear
    redirect('/')
end

# Display an error message
#
get ('/error') do
    slim(:error)
end

# Inputs params to log into an account
#
# @param [String] name, The name of an account
# @param [String] password, The password of an account
#
# @see MyModule#login
post ('/login') do
    login(params["name"], params["password"])
end

# Creates a new user and redirects to '/'
#
# @param [String] re_password, re-entry of password
# @param [String] password, The password of an account
# @param [String] name, The name of an account
# @param [String] email, The email of an account
#
# @see MyModule#create_user
post ('/create_user/new') do
    create_user(params["re_password"], params["password"], params["name"], params["email"])
    redirect('/')
end

# Creates a post and redirects to '/home'
#
# @param [Integer] price, The price of a product
# @param [Integer] stock, The amount of a product in stock
# @param [String] title, The title of a post
# @param [String] picture, The picture url of a product
#
# @see MyModule#verify_login
# @see MyModule#post_article
post ('/post_article') do
    if verify_login(session[:id])
        post_article(session[:id], params["price"], params["stock"], params["title"], params["picture"])
        redirect('/home')
    end
end

# Deletes a post and redirects to '/home'
#
# @param [Integer] id, The id of an account
#
# @see MyModule#post_delete
post ('/home/:id/delete') do
    post_delete(params["id"])
    redirect('/home')
end