require 'mysql2'

module MyORM
	class MySQL2
		class << self
			def connection= con
				@@connection = con
			end

			def add_object_to_db params
				tablename = params.shift
				names, values = [], []
				params.each do |pair|
 					names << pair[0]
 					if pair[1].class == String
 						values << "'" + pair[1] + "'"
 					else
 						values << pair[1]
 					end
				end
				joined_names, joined_values = names.join(', '), values.join(', ')
				@@connection.connection.query "INSERT INTO #{tablename} (#{joined_names}) VALUES (#{joined_values})"
        get_id
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

	    def get_id
	    	res = @@connection.connection.query "SELECT LAST_INSERT_ID()"
	    	temp = []
	    	res.each { |n| temp << n }
	    	temp[0]["LAST_INSERT_ID()"]
	    end

	    def get_prop_from_db id, name, tablename
	    	res = @@connection.connection.query "select #{name} from #{tablename} where id = #{id}"
	    	result = []
	    	res.each { |n| result << n }
	    	return result[0][name]
	    end
  	end
	end
end