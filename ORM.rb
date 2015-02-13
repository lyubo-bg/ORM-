require "mysql2"
require_relative 'Connection.rb'
require_relative 'DatabaseManager.rb'

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

    attr_accessor :connection, :name

    def destroy 
      MyORM::DatabaseManager.destroy @primary_key_name, @id, @name
    end

    def call_make_attr_accessor
      if make_attr_accessor
           puts 'Your mapping has been done successfully!'
         else
           puts 'Your mapping cannot be done the table
           you have chosen probably does not exist!'
        end
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

    def self.create_initialize()
      constructor_params = get_constructor_params
      res = BaseUtils.initialize_body constructor_params
      self.class_eval res
    end

    def self.inherited subclass
      MyORM::DatabaseManager.connection = self.connection
      MyORM::DatabaseManager.flag = self.connection.flag
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

    private

    def make_attr_accessor
      if MyORM::DatabaseManager.table_exists? name
        schema = MyORM::DatabaseManager.get_partial_schema name
        schema.each do |column|
          create_attr column["Field"]
        end
        return true
      end
      false
    end

    def create_method name, &block 
      self.class.send( :define_method, name, &block )
    end

    def create_attr name
      create_method( "#{name}=".to_sym ) do |val|
        instance_variable_set( "@" + name, val)
        MyORM::DatabaseManager.add_prop_to_db @primary_key_name, id, @name, name, val
      end

      create_method( name.to_sym ) do
        MyORM::DatabaseManager.get_prop_from_db @primary_key_name, @id, name, @name
      end
    end
  end

  class BaseUtils
    def self.initialize_body constructor_params
      "def initialize(#{constructor_params}, has_one: nil, has_many: nil, belongs_to:nil)
         @connection = MyORM::Base.connection
         @name = self.class.name.downcase

         filled_params = []
         filled_params << @name

         schema = MyORM::DatabaseManager.get_full_schema self.class.name.downcase
         
         schema.each do |row|
           @primary_key_name = row['Field'] if row['Key'] == 'PRI'
           if eval(row['Field'])
             filled_params << [row['Field'], eval(row['Field'])]
           end
         end

         MyORM::DatabaseManager.add_object_to_db filled_params
         @id = MyORM::DatabaseManager.get_id
         call_make_attr_accessor
       end"
    end

    def self.create_initialize_param(row) 
      puts row["Field"], row["Extra"]
      return row["Field"] + ":" if row["Null"] == "NO" && row["Extra"] == "" && row["KEY"] == "PRY"
      row["Field"] + ": nil" 
    end

  end
end