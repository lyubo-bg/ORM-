require 'sqlite3'

module MyORM
	class SQLite3
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
        @@connection.connection.execute "INSERT INTO #{tablename} (#{joined_names}) VALUES (#{joined_values})"
        get_id
      end

      def get_full_schema name
        query_string = ".schema #{name}"
        puts query_string
      end

      def table_exists?(name)
        begin
          @@connection.connection.execute("show columns from #{name}")
        rescue => ex
          return false
        end
        true
      end

      def get_id
        res = @@connection.connection.execute "SELECT LAST_INSERT_ID()"
        temp = []
        res.each { |n| temp << n }
        temp[0]["LAST_INSERT_ID()"]
      end

      def get_prop_from_db primary_key, id, name, table_name
        s = "SELECT #{name} FROM #{table_name} WHERE #{primary_key} = #{id}"
        res = @@connection.connection.execute s
        result = []
        res.each { |n| result << n }
        begin
          result[0][name]
        rescue Exception => e
          nil
        end
        
      end

      def destroy primary_key, id, table_name
        @@connection.connection.execute "DELETE FROM #{table_name} WHERE #{primary_key} = #{id}"
      end

      def add_prop_to_db primary_key, id, prop_name, value, table_name
        @@connection.connection.execute "UPDATE #{table_name}
                                       SET #{prop_name} = #{value}
                                       WHERE #{primary_key} = #{id}"
      end
    end
	end
end 