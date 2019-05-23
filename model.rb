module MyModule
    # Attempts to create a new user
    #
    # @params [String] name The username
    # @params [String] password The password
    # @params [String] repeat_password The repeated password
    # @params [String] email The email
    def create_user(re_password, password, name, email)
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true
        
        if re_password != password
            redirect('/')
        end

        pass = BCrypt::Password.create(password)
        if db.execute("SELECT name FROM custumers WHERE name=?", name) != true
            db.execute("INSERT INTO custumers (name, password, email) VALUES (?,?,?)", name, pass, email)
        end
    end

    # Attempts to login into a user
    #
    # @params [String] name The username
    # @params [String] password The password
    def login(name, password)
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true
        
        result = db.execute("SELECT id, name, password, email FROM custumers WHERE name = ?", name)
        if BCrypt::Password.new(result.first["password"]) == password
            session[:name] = result.first["name"]
            session[:id] = result.first["id"]
            session[:email] = result.first["email"]
            redirect("/home") #Sådan kod ska inte vara i model.rb, skicka vidare logik till app.rb?
        else
            redirect('/login')
        end
    end

    # Function to verify that user is logged in
    #
    def verify_login(id)
        if id == nil
            redirect('/error')
        else
            true
        end
    end

    # Attempts to post a article
    #
    # @params [Integer] user_id The users id
    # @params [Integer] price The posts price
    # @params [Integer] stock The posts stock
    # @params [String] title The title of the post
    # @params [String] picture The posts picture url
    def post_article(user_id, price, stock, title, picture)
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true

        db.execute("INSERT INTO products (user_id, price, stock, title, picture) VALUES (?,?,?,?,?)", user_id, price, stock, title, picture)
    end 

    # Attempts to delete a post
    #
    # @params [Integer] id The posts id
    def post_delete(id)
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true
        user_id = db.execute("SELECT user_id FROM products WHERE id = ?", id)
        if user_id.first["user_id"] == session[:id]
            db.execute("DELETE FROM products WHERE products.id = ?", id)
        end
    end

    # Function to select sql data
    def select_products_sql()
        db = SQLite3::Database.new("db/webshop.db")
        db.results_as_hash = true
        products = db.execute("SELECT * FROM products")
    end

end