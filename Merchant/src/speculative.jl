module Speculative

using Shared: TradeGood, TradeGoods
using WorldInfo: UWP, World

export seekGoods

function getAvailableGoods(source::World, blackMarketSupplier = false)
    # Get all trade goods by World's Trade Codes
    function filterFunc(tradeGood)
        if tradeGood.Availability == "All"
            return true
        end

        if typeof(tradeGood.Availability) == Vector{String}
            for tradeCode in source.TradeCodes
                if tradeCode in tradeGood.Availability
                    if !tradeGood.Illegal || blackMarketSupplier
                        return true
                    end
                end
            end
        end
        
        false    
    end
    
    available1 = filter(filterFunc, TradeGoods)
    available = Dict()

    for av in available1
        available[av] = 1
    end

    # Add a number of random goods up to the World's Population Code
    numRandomGoods = source.UWP.Population

    for i in 1:numRandomGoods
        #r = TradeGoods[randuint(length(TradeGoods))]
        r = sample(TradeGoods)
        available[r] = haskey(available, r) ? available[r]+1 : 1
    end
    
    available
end

function getBuySellDMs(source::World, tradeGood::TradeGood, selling=false)
    function filterFunc((tradeCode, quantity))
        tradeCode in source.TradeCodes
    end

    buyDMs = values(filter(filterFunc, tradeGood.PurchaseDM))
    maxBuyDM = length(buyDMs) > 0 ? maximum(buyDMs) : 0
    
    sellDMs = values(filter(filterFunc, tradeGood.SaleDM))
    maxSellDM = length(sellDMs) > 0 ? maximum(sellDMs) : 0

    selling ? (maxSellDM - maxBuyDM) : (maxBuyDM - maxSellDM)
end

ModifiedPurchasePrice = [ 3, 2.5, 2, 1.75, 1.5, 1.35, 1.25, 1.2, 1.15, 1.1, 1.05, 1, .95, .9, .85, .8, .75, .7, .65, .6, .55, .5, .45, .4, .35, .3, .25, .2, .15 ]
ModifiedSellPrice = [ .1, .2, .3, .4, .5, .55, .6, .65, .7, .75, .8, .85, .9, 1, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.4, 1.5, 1.6, 1.75, 2, 2.5, 3, 4 ]

function seekGoods(source::World, travellerMaxBrokerSkill, supplierBrokerSkill=2, blackMarketSupplier=false)
    available = getAvailableGoods(source, blackMarketSupplier)
    goods = keys(available)
    multiples = values(available)

    # Add -3 to availability on low population worlds
    quantityDM = source.UWP.Population <= 3 ? -3 : 0

    function mapFunc((good, multiple))
        quantity = max(0, dice(good.Tons[1], 6) * good.Tons[2] * multiple + quantityDM)

        # Determine price of good
        priceRoll = max(min(dice(3, 6) + travellerMaxBrokerSkill + getBuySellDMs(source, good) - supplierBrokerSkill, 25), -3)
        price = good.BasePrice * ModifiedPurchasePrice[priceRoll+4]

        (good.GoodType, quantity, price)
    end
    
    map(mapFunc, zip(goods, multiples))
end


end
