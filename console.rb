require_relative('customer.rb')
require_relative('film.rb')
require_relative('ticket.rb')
require('pry-byebug')


Ticket.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Jasmine', 'funds' => 400})
customer1.save
customer2 = Customer.new({'name' => 'Julia', 'funds' => 300})
customer2.save

film1 = Film.new({'title' => 'The Room', 'price' => 5})
film1.save
film2 = Film.new({'title' => 'Joker', 'price' => 8})
film2.save
film3 = Film.new({'title' => 'Dr. Sleep', 'price' => 9})
film3.save

ticket1 = Ticket.new({'customer_id' => customer1.id,
  'film_id' => film2.id })
ticket1.save
ticket2 = Ticket.new({'customer_id' => customer2.id,
  'film_id' => film1.id })
ticket2.save
ticket3 = Ticket.new({'customer_id' => customer2.id,
  'film_id' => film2.id })
ticket3.save


binding.pry
nil
