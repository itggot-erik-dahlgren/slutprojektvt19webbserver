def create_user(re_password, password, name, email)
    db = SQLite3::Database.new("db/webshop.db")
    db.results_as_hash = true
    #result.length > 5 på både lösenord och andvändarnamn
    if re_password != password
        redirect('/')
    end

    pass = BCrypt::Password.create(password)
    if db.execute("SELECT name FROM custumers WHERE name=?", name) != true
        db.execute("INSERT INTO custumers (name, password, email) VALUES (?,?,?)", name, pass, email)
    end
end

def login(name, password)
    db = SQLite3::Database.new("db/webshop.db")
    db.results_as_hash = true
    
    result = db.execute("SELECT id, name, password, email FROM custumers WHERE name = ?", name)
    if BCrypt::Password.new(result.first["password"]) == password
        session[:name] = result.first["name"]
        session[:id] = result.first["id"]
        session[:email] = result.first["email"]
        redirect("/home")
    else
        redirect('/login')
    end
end

def verify_login(id)
    if id == nil
        redirect('/error')
    end 
end

def post_article(price, stock, title, picture)
    db = SQLite3::Database.new("db/webshop.db")
    db.results_as_hash = true

    db.execute("INSERT INTO products (price, stock, title, picture) VALUES (?,?,?,?)", price, stock, title, picture)
end