require 'mysql2'

module MyORM
	class MySQL2
		class << self
			def connection= con
				@@connection = con
			end

			def add_prop_to_db tablename, name, value
				@@connection.connection.query "INSERT INTO #{tablename}
																			 (#{name}) VALUES ('#{value}')"
			end

			def get_partial_schema name
	      query_string = "SHOW COLUMNS FROM #{name}"
	      result = @@connection.connection.query(query_string)
	      table_info = []
	      result.each do | row |
	        temp = {}
	        temp["Field"], temp["Type"] = row["Field"], row["Type"]
	        table_info << temp
	      end
	      table_info
	    end

	    def get_full_schema name
	      query_string = "SHOW COLUMNS FROM #{name}"
	      result = @@connection.connection.query(query_string)
	      result.each { |row| puts row }
    	end

    	def table_exists?(name)
	      begin
	        @@connection.connection.query("show columns from #{name}")
	      rescue => ex
	        return false
	      end
	      true
	    end
  	end
	end
end