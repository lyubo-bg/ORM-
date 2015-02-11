require 'yaml'
require '../MySQL2'
require '../Connection'

describe  MyORM::MySQL2 do 
	#create MySQL database connection
	con = MyORM::Connection.new(adapter: 'mysql2', database:'fortests', host:'localhost', username: 'root', password: '123123q')
	
	#create table with which the code would be tested
	con.connection.query("CREATE TABLE IF NOT EXISTS tests
												(id INT NOT NULL,
												name VARCHAR(50),
												active BIT,
												PRIMARY KEY (id))")
	MyORM::MySQL2.connection = con

	table_name = "tests"

	before :each do
		con.connection.query("DELETE FROM #{table_name}")
	end


	it "adds object with given value to database" do
		params = ["tests", ["id", 1],["name", "test1"], ["active", true]]
		MyORM::MySQL2.add_object_to_db params
		res = con.connection.query("SELECT * FROM #{table_name}
																WHERE id = 1")
		expect(res.to_a[0]["id"]).to eq 1
		expect(res.to_a[0]["name"]).to eq "test1"
		expect(res.to_a[0]["active"]).to eq "\x01"
	end

	it "gets schema from kind {Field:.., Type:...}" do
		schema = MyORM::MySQL2.get_partial_schema "tests"
		expect(schema.length).to eq 3
		expect(schema[0]["Field"]).to eq "id"
		expect(schema[0]["Type"]).to eq "int(11)"
		expect(schema[1]["Field"]).to eq "name"
		expect(schema[1]["Type"]).to eq "varchar(50)"
		expect(schema[2]["Field"]).to eq "active"
		expect(schema[2]["Type"]).to eq "bit(1)"
	end

	it "checks if table exists by given name" do
		expect(MyORM::MySQL2.table_exists? table_name).to eq true
		expect(MyORM::MySQL2.table_exists? "nqma takova ime").to eq false
	end

	it "gets last inserted id into table" do
		con.connection.query("INSERT INTO #{table_name}
													(id) VALUES (5);")
		expect(MyORM::MySQL2.get_id).to eq 5
	end

	it "adds property to database" do
		params = ["tests", ["id", 3],["name", "test1"], ["active", true]]
		MyORM::MySQL2.add_object_to_db params
		MyORM::MySQL2.add_prop_to_db "id", 3, "name", "'test'", table_name
		res = con.connection.query("SELECT name FROM #{table_name}")
		expect(res.to_a[0]["name"]).to eq 'test'
	end

	it "destroys current object" do
		params = ["tests", ["id", 3],["name", "test1"], ["active", true]]
		MyORM::MySQL2.add_object_to_db params
		MyORM::MySQL2.destroy "id", 3, table_name
		res = con.connection.query("SELECT * FROM #{table_name}")
		expect(res.to_a).to eq []
	end

end