require 'yaml'
require '../SQLite3'
require '../Connection' 

describe  MyORM::SQLite3 do 

  #create MySQL database connection
  con = MyORM::Connection.new(adapter: 'sqlite3', database:'fortests.db')
  
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

  it "adds object with given value to database" do
    params = ["tests", ["id", 1],["name", "test1"], ["active", 1]]
    MyORM::SQLite3.add_object_to_db params
    res = con.connection.execute("SELECT id, name, active FROM #{table_name}
                                WHERE id = 1")
    expect(res[0][0]).to eq 1
    expect(res[0][1]).to eq "test1"
    expect(res[0][2]).to eq 1
  end

  it "checks if table exists by given name" do
    expect(MyORM::SQLite3.table_exists? table_name).to eq true
    expect(MyORM::SQLite3.table_exists? "nqma_takova_ime").to eq false
  end

  it "gets last inserted id into table" do
    con.connection.execute("INSERT INTO #{table_name}
                          (id) VALUES (5);")
    expect(MyORM::SQLite3.get_id("id", table_name)).to eq 5
  end

  it "adds property to database" do
    params = ["tests", ["id", 3],["name", "test1"], ["active", 1]]
    MyORM::SQLite3.add_object_to_db params
    MyORM::SQLite3.add_prop_to_db "id", 3, "name", "'test'", table_name
    res = con.connection.execute("SELECT name FROM #{table_name}")
    expect(res[0][0]).to eq 'test'
  end

  it "destroys current object" do
    params = ["tests", ["id", 3],["name", "test1"], ["active", 0]]
    MyORM::SQLite3.add_object_to_db params
    MyORM::SQLite3.destroy "id", 3, table_name
    res = con.connection.execute("SELECT * FROM #{table_name}")
    expect(res.to_a).to eq []
  end

end