module MyORM
	class Connection

    # The constructor accepts a connection hash 
    # adapter: which database provider you will use 
    # database, host, username & password 
    def initialize(adapter:, database:,host: nil, username: nil, password: nil)
      if(adapter == "mysql2")
      	@flag = "mysql2"
        @connection = establish_connection_mysql2(database: database, host: host, username: username, password: password)
      elsif (adapter == 'sqlite3')
        @connection = establish_connection_sqlite database: database
      else
        puts "You have given this adapter: #{adapter}, which is invalid"
      end
    end

    attr_accessor :flag, :connection

    # def fill_config_file(adapter:, database:,host: nil, username: nil, password: nil)
    #   f = File.open("config.rb", "w") { |file|  }
    # end

    #Makes connection with the server
    def establish_connection_mysql2(database:,host:,username:,password:)
      Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    end 

    def establish_connection_sqlite(database:)
      SQLite3::Database.new database
    end
  end
end 