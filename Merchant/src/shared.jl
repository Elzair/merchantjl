module Shared

export PassageAndFreight, TradeGood, TradeGoods

PassageAndFreight = Dict(
    "High Passage" => [9000, 14000, 21000, 34000, 60000, 210000],
    "Middle Passage" => [6500, 10000, 14000, 23000, 40000, 130000],
    "Basic Passage" => [2000, 3000, 5000, 8000, 14000, 55000],
    "Low Passage" => [700, 1300, 2200, 3900, 7200, 27000],
    "Freight" => [1000, 1600, 2600, 4400, 8500, 32000]
)

struct TradeGood
    GoodType::String
    Availability::Union{String,Vector{String}}
    Tons::Tuple{Integer, Integer}
    BasePrice::Integer
    PurchaseDM::Dict{String, Integer}
    SaleDM::Dict{String, Integer}
    Illegal::Bool
end

TradeGoods = [
    TradeGood("Common Electronics", "All", (2, 10), 20000, Dict("In" => 2, "Ht" => 3, "Ri" => 1), Dict("Ni" => 2, "Lt" => 1, "Po" => 1), false)
    TradeGood("Common Industrial Goods", "All", (2, 10), 10000, Dict("Na" => 2, "In" => 5), Dict("Ni" => 3, "Ag" => 2), false)
    TradeGood("Common Manufactured Goods", "All", (2, 10), 20000, Dict("Na" => 2, "In" => 5), Dict("Ni" => 3, "Hi" => 2), false)
    TradeGood("Common Raw Materials", "All", (2, 20), 5000, Dict("Ag" => 3, "Ga" => 2), Dict("In" => 2, "Po" => 2), false)
    TradeGood("Common Consumables", "All", (2, 20), 500, Dict("Ag" => 3, "Wa" => 2, "Ga" => 1, "As" => -4), Dict("As" => 1, "Fl" => 1, "Ic" => 1, "Hi" => 1), false)
    TradeGood("Common Ore", "All", (2, 20), 1000, Dict("As" => 4), Dict("In" => 3, "Ni" => 1), false)
    TradeGood("Advanced Electronics", ["In", "Ht"], (1, 5), 100000, Dict("In" => 2, "Ht" => 3), Dict("Ni" => 1, "Ri" => 2, "As" => 3), false)
    TradeGood("Advanced Machine Parts", ["In", "Ht"], (1, 5), 75000, Dict("In" => 2, "Ht" => 1), Dict("As" => 2, "Ni" => 1), false)
    TradeGood("Advanced Manufactured Goods", ["In", "Ht"], (1, 5), 100000, Dict("In" => 1), Dict("Hi" => 1, "Ri" => 2), false)
    TradeGood("Advanced Weapons", ["In", "Ht"], (1, 5), 150000, Dict("Ht" => 2), Dict("Po" => 1, "Az" => 2, "Rz" => 4), false)
    TradeGood("Advanced Vehicles", ["In", "Ht"], (1, 5), 180000, Dict("Ht" => 2), Dict("As" => 2, "Ri" => 2), false)
    TradeGood("Biochemicals", ["Ag", "Wa"], (1, 5), 50000, Dict("Ag" => 1, "Wa" => 2), Dict("In" => 2), false)
    TradeGood("Crystals & Gems", ["As", "De", "Ic"], (1, 5), 20000, Dict("As" => 2, "De" => 1, "Ic" => 1), Dict("In" => 3, "Ri" => 2), false)
    TradeGood("Cybernetics", ["Ht"], (1, 1), 250000, Dict("Ht" => 1), Dict("As" => 1, "Ic" => 1, "Ri" => 2), false)
    TradeGood("Live Animals", ["Ag", "Ga"], (1, 10), 10000, Dict("Ag" => 2), Dict("Lo" => 3), false)
    TradeGood("Luxury Consumables", ["Ag", "Ga", "Wa"], (1, 10), 20000, Dict("Ag" => 2, "Wa" => 1), Dict("Ri" => 2, "Hi" => 2), false)
    TradeGood("Luxury Goods", ["Hi"], (1, 1), 200000, Dict("Hi" => 1), Dict("Ri" => 4), false)
    TradeGood("Medical Supplies", ["Ht", "Hi"], (1, 5), 50000, Dict("Ht" => 2), Dict("In" => 2, "Po" => 1, "Ri" => 1), false)
    TradeGood("Petrochemicals", ["De", "Fl", "Ic", "Wa"], (1, 10), 10000, Dict("De" => 2), Dict("In" => 2, "Ag" => 1, "Lt" => 2), false)
    TradeGood("Pharmaceuticals", ["As", "De", "Hi", "Wa"], (1, 1), 100000, Dict("As" => 2, "Hi" => 1), Dict("Ri" => 2, "Lt" => 1), false)
    TradeGood("Polymers", ["In"], (1, 10), 7000, Dict("In" => 1), Dict("Ri" => 2, "Ni" => 1), false)
    TradeGood("Precious Metals", ["As", "De", "Ic", "Fl"], (1, 1), 50000, Dict("As" => 3, "De" => 1, "Ic" => 2), Dict("Ri" => 3, "In" => 2, "Ht" => 1), false)
    TradeGood("Radioactives", ["As", "De", "Lo"], (1, 1), 1000000, Dict("As" => 2, "Lo" => 2), Dict("In" => 3, "Ht" => 1, "Ni" => -2, "Ag" => -3), false)
    TradeGood("Robots", ["In"], (1, 5), 400000, Dict("In" => 1), Dict("Ag" => 2, "Ht" => 1), false)
    TradeGood("Spices", ["Ga", "De", "Wa"], (1, 10), 6000, Dict("De" => 2), Dict("Hi" => 2, "Ri" => 3, "Po" => 3), false)
    TradeGood("Textiles", ["Ag", "Ni"], (1, 20), 3000, Dict("Ag" => 7), Dict("Hi" => 3, "Na" => 2), false)
    TradeGood("Uncommon Ore", ["As", "Ic"], (1, 20), 5000, Dict("As" => 4), Dict("In" => 3, "Ni" => 1), false)
    TradeGood("Uncommon Raw Materials", ["Ag", "De", "Wa"], (1, 10), 20000, Dict("Ag" => 2, "Wa" => 1), Dict("In" => 2, "Ht" => 1), false)
    TradeGood("Wood", ["Ag", "Ga"], (1, 20), 1000, Dict("Ag" => 6), Dict("Ri" => 2, "In" => 1), false)
    TradeGood("Vehicles", ["In", "Ht"], (1, 10), 15000, Dict("In" => 2, "Ht" => 1), Dict("Ni" => 2, "Hi" => 1), false)
    TradeGood("Illegal Biochemicals", ["Ag", "Wa"], (1, 5), 50000, Dict("Wa" => 2), Dict("In" => 6), true)
    TradeGood("Cybernetics, Illegal", ["Ht"], (1, 1), 250000, Dict("Ht" => 1), Dict("As" => 4, "Ic" => 4, "Ri" => 8, "Az" => 6, "Rz" => 6), true)
    TradeGood("Drugs, Illegal", ["As", "De", "Hi", "Wa"], (1, 1), 100000, Dict("As" => 1, "De" => 1, "Ga" => 1, "Wa" => 1), Dict("Ri" => 6, "Hi" => 6), true)
    TradeGood("Luxuries, Illegal", ["Ag", "Ga", "Wa"], (1, 1), 50000, Dict("Ag" => 2, "Wa" => 1), Dict("Ri" => 6, "Hi" => 4), true)
    TradeGood("Weapons, Illegal", ["In", "Ht"], (1, 5), 150000, Dict("Ht" => 2), Dict("Po" => 6, "Az" => 8, "Rz" => 10), true)
    TradeGood("Exotics", "Special", (0, 1), 0, Dict(), Dict(), false)
]

end
