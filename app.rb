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

get ('/home') do
    if verify_login(session[:id])
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true
        
        products = db.execute("SELECT * FROM products")
        slim(:home, locals:{
            products: products})
    end
end

get ('/create_user') do
    slim(:create_user)
end

get ('/login') do
    slim(:login)
end

get ('/logout') do
    session.clear
    redirect('/')
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

post ('/post_article') do
    if verify_login(session[:id])
        post_article(params["price"], params["stock"], params["title"], params["picture"])
        redirect('/home')
    end
end

post ('/home/:id/delete') do
    db = SQLite3::Database.new("db/webshop.db")
    db.results_as_hash = true

    result = db.execute("SELECT custumers.id FROM custumers INNER JOIN products WHERE user_id = custumers.id")
    db.execute("DELETE FROM products WHERE products.id = ?", params["id"])
    redirect('/home')
end