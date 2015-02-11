require "../ORM"

describe  MyORM::Base do 
	#create MySQL database connection
	mysql_con = MyORM::Connection.new(adapter: 'mysql2', database:'fortests', host:'localhost', username: 'root', password: '123123q')
	
	#create SQLite3 database connection

	#create table with which the code would be tested
	con.connection.query("CREATE TABLE IF NOT EXISTS tests
												(id INT NOT NULL,
												name VARCHAR(50),
												active BIT,
												PRIMARY KEY (id))")
	MyORM::Base.connection = mysql_con

	table_name = "tests"

	before :each do
		con.connection.query("DELETE FROM #{table_name}")
	end

	it "creates the expected class with attr_accessor methods" do
		class Tests < MyORM::Base
		end
		
	end

end