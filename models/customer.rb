require ('PG')
require_relative ('sql_runner')
require_relative ('film')

class Customer
  attr_reader :name, :funds, :id
  attr_writer :name, :funds, :id
  def initialize (options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save
    db = PG.connect ({dbname: 'cinema', host: 'localhost'})
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2)
    RETURNING *;"
    values = [@name, @funds]
    db.prepare('save', sql)
    @id = db.exec_prepared('save', values)[0]['id']
    db.close()
  end

  def update()
   db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
   sql = "UPDATE customers
   SET
   (
     name,
     funds
   ) =
   (
     $1, $2
   )
   WHERE id = $3"
   values = [@name, @funds, @id]
   db.prepare("update", sql)
   db.exec_prepared("update", values)
   db.close
 end

  def delete()
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def self.all
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "SELECT * FROM customers"
    db.prepare("all", sql)
    customers = db.exec_prepared("all")
    db.close()
    return customers.map {|customer| Customer.new(customer)}
  end

  def self.delete_all()
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM customers"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def self.map_items(customer_data)
    result = customer_data.map { |customer| Customer.new( customer ) }
    return result
  end

end
