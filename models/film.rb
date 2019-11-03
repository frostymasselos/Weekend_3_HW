require ('PG')
require_relative ('sql_runner')
require_relative ('film')

class Film

  attr_reader :id, :title, :price
  attr_writer :id, :title, :price

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    db = PG.connect ({dbname: 'cinema', host: 'localhost'})
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2)
    RETURNING *;"
    values = [@title, @price]
    db.prepare('save', sql)
    @id = db.exec_prepared('save', values)[0]['id']
    db.close()
  end

  def update()
   db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
   sql = "UPDATE film
   SET
   (
     title,
     price
   ) =
   (
     $1, $2
   )
   WHERE id = $3"
   values = [@title, @price, @id]
   db.prepare("update", sql)
   db.exec_prepared("update", values)
   db.close
 end

  def delete()
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM film WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.film_id
    WHERE ticket_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def self.all
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "SELECT * FROM film"
    db.prepare("all", sql)
    films = db.exec_prepared("all")
    db.close()
    return films.map {|film| Film.new(film)}
  end

  def self.delete_all()
     db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM films"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

end
