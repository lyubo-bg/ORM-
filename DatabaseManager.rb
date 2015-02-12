require_relative 'MySQL2.rb'
require_relative 'SQLite3.rb'

module MyORM
	class DatabaseManager
    class << self
  		def flag= (flag)
  			@@flag = flag
  		end

  		def flag
  			@@flag
  		end

  		def connection
  			@@connection
  		end

  		def connection= connection
  			@@connection = connection
  		end

      #adds given object in a specific format into db
  		def add_object_to_db params
  			case self.flag
  			when "mysql2"
  				MySQL2.add_object_to_db params
  			when "sqlite"
  			end
  		end

      #assigns connection
  		def connection_to_db
  			case self.flag
  			when "mysql2"
  				MySQL2.connection = self.connection
  			when "sqlite"
  				SQLite3.connection = self.connection
  			else
  				puts "Your database adapter is invalid!"
  			end
  		end

      #Gets partial schmea
  		def get_partial_schema name
  			case self.flag
        when "mysql2"
          MySQL2.get_partial_schema name
        when "sqlite"
          SQLite3.get_partial_schema name
        end
      end

      #Gets full table schema by class name
      def get_full_schema name
        case self.flag
        when "mysql2"
        	MySQL2.get_full_schema name
        when "sqlite"
        	SQLite3.get_full_schema name
        end

      end

      def table_exists? name
        case self.flag
        when "mysql2"
        	MySQL2.table_exists? name
        when "sqlite"
        	SQLite3.table_exists? name
        end
      end

      def get_prop_from_db primary_key, id, name, table_name
        case self.flag
        when "mysql2"
        	MySQL2.get_prop_from_db primary_key, id, name, table_name
        when "sqlite"
        	SQLite3.table_exists? name
        end
      end

      def add_prop_to_db primary_key, id, name, value, table_name 
      	case self.flag
        when "mysql2"
        	MySQL2.add_prop_to_db primary_key, id, name, value, table_name
        when "sqlite"
        	SQLite3.add_prop_to_db primary_key, id, name, value, table_name
        end
      end

      def destroy primary_key, id, table_name
      	case self.flag
        when "mysql2"
        	MySQL2.destroy primary_key, id, table_name
        when "sqlite"
        	SQLite3.destroy primary_key, id, table_name
        end
      end

      def get_id
        case self.flag
        when "mysql2"
          MySQL2.get_id
        when "sqlite"
          SQLite3.get_id
        end
      end
    end
	end
end 