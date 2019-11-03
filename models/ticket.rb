require ('PG')
require_relative ('customer')
require_relative ('film')

class Ticket
  attr_reader :id, :customer_id, :film_id
  attr_writer :id, :customer_id, :film_id

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @customer_id = options ['customer_id'].to_i
    @film_id = options ['film_id'].to_i
  end

  def save
    db = PG.connect ({dbname: 'cinema', host: 'localhost'})
    sql = "INSERT INTO tickets (customer_id, film_id)
    VALUES ($1, $2)
    RETURNING id;"
    values = [@customer_id, @film_id]
    db.prepare('save', sql)
    @id = db.exec_prepared('save', values)[0]['id']
    db.close()
  end


  def update()
   db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
   sql = "UPDATE tickets
   SET
   (
     customer_id,
     film_id
   ) =
   (
     $1, $2
   )
   WHERE id = $3"
   values = [@customer_id, @film_id, @id]
   db.prepare("update", sql)
   db.exec_prepared("update", values)
   db.close
 end

  def delete()
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def self.all
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "SELECT * FROM tickets"
    db.prepare("all", sql)
    tickets = db.exec_prepared("all")
    db.close()
    return tickets.map {|ticket| Ticket.new(ticket)}
  end

  def self.delete_all()
    db = PG.connect( { dbname: 'cinema', host: 'localhost' } )
    sql = "DELETE FROM tickets"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

end
