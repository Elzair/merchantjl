module Merchant

include("worldinfo.jl")
include("freight.jl")
include("passenger.jl")
include("speculative.jl")

using .Passenger: seekAllPassengers
using .Freight: seekAllFreight
using .Speculative: seekGoods
using .WorldInfo: World

export World, UWP, seekAllPassengers, seekAllFreight, seekGoods

end
