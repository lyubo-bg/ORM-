require "../ORM.rb"

describe  MyORM::Base do
  #create MySQL database connection
  mysql_con = MyORM::Connection.new(adapter: 'mysql2', database: 'fortests', host:'localhost', username: 'root', password: '123123q')
  
  #create table with which the code would be tested
  mysql_con.connection.query("CREATE TABLE IF NOT EXISTS tests
                        (id INT NOT NULL,
                        name VARCHAR(50),
                        active BIT,
                        PRIMARY KEY (id))")

  table_name = "tests"

  context "with mysql connection" do
    before :all do
      MyORM::Base.connection = mysql_con
    end 

    before :each do
      mysql_con.connection.query("DELETE FROM #{table_name}")
      class Tests < MyORM::Base
      end
    end

    it "creates the expected class" do
      Tests.new 
      methods = Tests.instance_methods - Object.instance_methods
      expect(methods.include? :id).to eq true
      expect(methods.include? :id=).to eq true
      expect(methods.include? :name).to eq true
      expect(methods.include? :name=).to eq true
      expect(methods.include? :active).to eq true
      expect(methods.include? :active=).to eq true
    end

    it "add the expected object to the db" do
      test = Tests.new id: 1, name: "test", active: true
      expect(test.id).to eq 1
      expect(test.name).to eq "test"
      expect(test.active).to eq "\x01"
    end

    it "destroys the expected object in the db" do
      test = Tests.new id: 1, name: "test", active: true
      test.destroy
      expect(test.id).to eq nil
      expect(test.name).to eq nil
      expect(test.active).to eq nil
    end
  end

end