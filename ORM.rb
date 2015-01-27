require "mysql2"

module MyORM
  class Connection
    def initialize(adapter:, database:,host: nil, username: nil, password: nil)
      if(adapter == "mysql2")
        @connection = establish_connection_mysql2(database: database, host: host, username: username, password: password)
      elsif (adapter == 'sqlite3')
        @connection = establish_connection_sqlite
      else
        puts "You have given this adapter: #{adapter}, which is invalid"
      end

    end

    attr_accessor :connection

    def establish_connection_mysql2(database:,host:,username:,password:)
      Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    end 

    def establish_connection_sqlite(database:,host:)
      
    end
  end

  class Base
    def initialize(connection)
      @connection = connection
      if make_attr_accessor self.class
        puts "Your mapping has been done successfully!"
      else
        puts "Your mapping can't be done the table
        you have chosen probably doesn't exist"
      end
    end

    attr_accessor :connection, :name

    def make_attr_accessor
      if table_exists? name
        schema = get_schema_by_name
        schema.each do |column|
          create_method(column["Field"])
        end
        return true
      end
      false
    end

    def create_method( name, &block )
        self.class.send( :define_method, name, &block )
    end

    def create_attr( name )
        create_method( "#{name}=".to_sym ) do |val| 
            instance_variable_set( "@" + name, val)
        end

        create_method( name.to_sym ) do 
            instance_variable_get( "@" + name ) 
        end
    end

    def get_schema_by_name()
      query_string = "SHOW COLUMNS FROM #{name}"
      result = @connection.connection.query(query_string)
      table_info = []
      result.each do | row |
        temp = {}
        temp["Field"], temp["Type"] = row["Field"], row["Type"]
        table_info << temp
      end
      table_info
    end

    def table_exists?(name)
      flag = true;
      begin
        connection.connection.query("show columns from #{name}")
      rescue => ex
        flag = false
      end
      flag
    end
  end
end