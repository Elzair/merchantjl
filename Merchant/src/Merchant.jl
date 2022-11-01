module Merchant

#greet() = print("Hello World!")

using Passenger
using Freight
using Speculative

export Passenger.seekAllPassengers, Freight.seekAllFreight, Speculative.seekGoods

end # module Merchant
