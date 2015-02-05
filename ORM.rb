require "mysql2"
load 'Connection.rb'
load 'DatabaseManager.rb'

module MyORM
  class Base
    def initialize (connection)
      @connection = connection
      @name = self.class.name.downcase
      if make_attr_accessor
        puts "Your mapping has been done successfully!"
      else
        puts "Your mapping can't be done the table
        you have chosen probably doesn't exist!"
      end
    end

    def self.inherited subclass
      MyORM::DatabaseManager.connection = self.connection
      MyORM::DatabaseManager.flag = "mysql"
      MyORM::DatabaseManager.connection_to_db
      @@name = subclass.name.downcase
      self.create_initialize
    end

    def self.connection= con
      @@connection = con
    end

    def self.connection
      @@connection
    end

    def self.get_connection_params_from_config_file
      content_array = []
      f = File.open("config.txt", "r") or die "Unable to open config file."
      f.each_line { |line| content_array << line.chomp }
      params_hash = {}
      content_array.each do |el|
        temp = el.split(" ")
         params_hash[temp[0].to_sym] = temp[1]
      end
      params_hash
    end

    attr_accessor :connection, :name

    def make_attr_accessor
      if MyORM::DatabaseManager.table_exists? name
        schema = MyORM::DatabaseManager.get_partial_schema name
        schema.each do |column|
          create_attr(column["Field"])
        end
        return true
      end
      false
    end

    def self.add_prop_to_db name, val
      puts name
      puts val
    end

    def self.get_constructor_params
      schema = MyORM::DatabaseManager.get_full_schema @@name
      constructor_params_arr = []
      schema.each do |row| 
        temp = BaseUtils.create_initialize_param row 
        constructor_params_arr << temp
      end
      constructor_params_arr.join(", ")
    end

    def create_method( name, &block )
      self.class.send( :define_method, name, &block )
    end

    def create_attr( name )
      create_method( "#{name}=".to_sym ) do |val|
        instance_variable_set( "@" + name, val)
        MyORM::DatabaseManager.add_prop_to_db @name, name, val
      end

      create_method( name.to_sym ) do
        instance_variable_get( "@" + name ) 
      end
    end

    def self.create_initialize()
      constructor_params = get_constructor_params
      res = BaseUtils.initialize_body constructor_params
      puts res
      self.class_eval res
    end

    def call_attr_accessor
      if make_attr_accessor
           puts 'Your mapping has been done successfully!'
         else
           puts 'Your mapping cannot be done the table
           you have chosen probably does not exist!'
        end
    end

    def get
      
    end

  end

  class BaseUtils
    def self.initialize_body constructor_params
      "def initialize(#{constructor_params})
         @connection = MyORM::Base.connection
         @name = self.class.name.downcase
         schema = MyORM::DatabaseManager.get_partial_schema self.class.name.downcase
         schema.each do |row|
           if eval(row['Field'])
             MyORM::DatabaseManager.add_prop_to_db @name, row['Field'], eval(row['Field'])
           end
         end
         call_attr_accessor
       end"
    end

    def self.create_initialize_param(row) 
      if row["NULL"].equal? "NO"
        row["Field"] + ':'
      else
        row["Field"] + ": nil"
      end
    end
  end
end