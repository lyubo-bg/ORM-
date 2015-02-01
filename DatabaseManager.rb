load 'MySQL2.rb'
load 'SQLite3.rb'
load 'ORM.rb'

module MyORM
	class DatabaseManager

		def self.flag= (flag)
			@@flag = flag
		end

		def self.flag
			@@flag
		end

		def self.connection
			@@connection
		end

		def self.connection= connection
			@@connection = connection
		end

		def self.connection_to_db
			case self.flag
			when "mysql"
				MySQL2.connection = self.connection
			when "sqlite"
				SQLite3.connection = self.connection
			else
				puts "Your database adapter is invalid!"
			end
		end

		def self.get_partial_schema name
			if(flag == "mysql")
				MySQL2.get_partial_schema name
			elsif (flag == "sqlite")
				SQLite3.get_partial_schema name
			end
    end

    #Gets full table schema by class name
    def self.get_full_schema name
      case self.flag
      when "mysql"
      	MySQL2.get_full_schema name
      when "sqlite"
      	SQLite3.get_full_schema name
      end
    end

    def self.table_exists? name
      case self.flag
      when "mysql"
      	MySQL2.table_exists? name
      when "sqlite"
      	SQLite3.table_exists? name
      end
    end
	end
end