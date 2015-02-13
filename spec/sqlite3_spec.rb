require 'yaml'
require '../SQLite3'
require '../Connection' 

describe  MyORM::SQLite3 do 
  #create MySQL database connection
  con = MyORM::Connection.new(adapter: 'sqlite3', database:'fortests')
  
  #create table with which the code would be tested
  con.connection.execute("CREATE TABLE IF NOT EXISTS tests
                        (id INT NOT NULL PRIMARY KEY,
                        name VARCHAR(50),
                        active INT)")
  MyORM::SQLite3.connection = con

  table_name = "tests"

  before :each do
    con.connection.execute("DELETE FROM #{table_name};")
  end

  # it "adds object with given value to database" do
  #   params = ["tests", ["id", 1],["name", "test1"], ["active", true]]
  #   MyORM::SQLite3.add_object_to_db params
  #   res = con.connection.query("SELECT * FROM #{table_name}
  #                               WHERE id = 1")
  #   expect(res.to_a[0]["id"]).to eq 1
  #   expect(res.to_a[0]["name"]).to eq "test1"
  #   expect(res.to_a[0]["active"]).to eq 1
  # end

  it "gets schema from kind {Field:.., Type:...}" do
    MyORM::SQLite3.get_full_schema "tests"
  end

  # it "checks if table exists by given name" do
  #   expect(MyORM::SQLite3.table_exists? table_name).to eq true
  #   expect(MyORM::SQLite3.table_exists? "nqma takova ime").to eq false
  # end

  # it "gets last inserted id into table" do
  #   con.connection.query("INSERT INTO #{table_name}
  #                         (id) VALUES (5);")
  #   expect(MyORM::SQLite3.get_id).to eq 5
  # end

  # it "adds property to database" do
  #   params = ["tests", ["id", 3],["name", "test1"], ["active", true]]
  #   MyORM::SQLite3.add_object_to_db params
  #   MyORM::SQLite3.add_prop_to_db "id", 3, "name", "'test'", table_name
  #   res = con.connection.query("SELECT name FROM #{table_name}")
  #   expect(res.to_a[0]["name"]).to eq 'test'
  # end

  # it "destroys current object" do
  #   params = ["tests", ["id", 3],["name", "test1"], ["active", true]]
  #   MyORM::SQLite3.add_object_to_db params
  #   MyORM::SQLite3.destroy "id", 3, table_name
  #   res = con.connection.query("SELECT * FROM #{table_name}")
  #   expect(res.to_a).to eq []
  # end

end