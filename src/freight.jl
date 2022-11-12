module Freight

include("helpers.jl")
include("shared.jl")
include("worldinfo.jl")

using .Helpers: dice, r1d6, r2d6
using .Shared: PassageAndFreight
using .WorldInfo: UWP, World

export seekAllFreight

FreightTraffic = [ 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 8, 9, 10 ]

"""
    seekMail(checkEffect, source, destination, distance [, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM])

See if there is mail going to the destination

# Arguments
- `checkEffect`: the Effect of a given check to look for cargo
- `source::World`: the `World` the travellers are on
- `destination::World`: the `World` they are going to
- `distance`: the distance (in parsecs)
- `maxNavalOrScoutRank`: the highest rank in the Navy or Scouts achieved by the travellers during character creation
- `maxSOC`: the highest Social Standing Dice Modifier possessed by the travellers
- `shipIsArmed`: whether or not the travellers' ship has weapons
- `userDM`: any Dice Modifier specified by the Referee
"""
function seekMail(checkEffect, source::World, destination::World, distance, maxNavalOrScoutRank = 0, maxSOC = 0, shipIsArmed = false, userDM = 0)
    sourcePopDM = if source.UWP.Population <= 1
        -4
    elseif 6 <= source.UWP.Population <= 7
        2
    elseif source.UWP.Population >= 8
        4
    else
        0
    end

    sourceZoneDM = if source.Zone == "Amber"
        -2
    elseif source.Zone == "Red"
        -6
    else
        0
    end

    sourceStarportDM = if source.UWP.Starport == 10
        2
    elseif source.UWP.Starport == 11
        1
    elseif source.UWP.Starport == 14
        -1
    elseif source.UWP.Starport == 31
        -3
    else
        0
    end

    sourceTechLevelDM = if source.UWP.TechLevel <= 6
        -1
    elseif source.UWP.TechLevel >= 9
        2
    else
        0
    end
    
    destPopDM = if destination.UWP.Population <= 1
        -4
    elseif 6 <= destination.UWP.Population <= 7
        2
    elseif destination.UWP.Population >= 8
        4
    else
        0
    end

    destZoneDM = if destination.Zone == "Amber"
        -2
    elseif destination.Zone == "Red"
        -6
    else
        0
    end

    destStarportDM = if destination.UWP.Starport == 10
        2
    elseif destination.UWP.Starport == 11
        1
    elseif destination.UWP.Starport == 14
        -1
    elseif destination.UWP.Starport == 31
        -3
    else
        0
    end

    destTechLevelDM = if destination.UWP.TechLevel <= 6
        -1
    elseif destination.UWP.TechLevel >= 9
        2
    else
        0
    end

    distanceDM = max(0, (distance-1)*-1)

    freightTrafficDM = checkEffect + sourcePopDM + sourceZoneDM + sourceStarportDM + sourceTechLevelDM +
        destPopDM + destZoneDM + destStarportDM + destTechLevelDM + distanceDM + userDM

    mailDM = if freightTrafficDM <= -10
        -2
    elseif -9 <= freightTrafficDM <= -5
        -1
    elseif -4 <= freightTrafficDM <= 4
        0
    elseif 5 <= freightTrafficDM <= 9
        1
    elseif freightTrafficDM >= 10
        2
    end

    if source.UWP.TechLevel <= 5
        freightTrafficDM -= 4
    end

    if destination.UWP.TechLevel <= 5
        freightTrafficDM -= 4
    end

    if shipIsArmed
        freightTrafficDM += 2
    end

    roll = r2d6() + freightTrafficDM + maxNavalOrScoutRank + maxSOC

    if roll >= 12
        r1d6()
    else
        0
    end
end

"""
    seekFreight(checkEffect, source, destination, distance, cargo [, userDM])
Seek out any cargo of the given type for a given source and desintation

# Arguments
- `checkEffect`: the Effect of a given check to look for cargo
- `source::World`: the `World` the travellers are on
- `destination::World`: the `World` they are going to
- `distance`: the distance (in parsecs)
- `cargo::String`: 'Major', 'Minor', or 'Incidental'
- `userDM`: any Dice Modifier specified by the Referee
"""
function seekFreight(checkEffect, source::World, destination::World, distance, cargo::String, userDM = 0)
    cargoDM = if cargo == "Major"
        -4
    elseif cargo == "Incidental"
        1
    else
        0
    end

    sourcePopDM = if source.UWP.Population <= 1
        -4
    elseif 6 <= source.UWP.Population <= 7
        2
    elseif source.UWP.Population >= 8
        4
    else
        0
    end

    sourceZoneDM = if source.Zone == "Amber"
        -2
    elseif source.Zone == "Red"
        -6
    else
        0
    end

    sourceStarportDM = if source.UWP.Starport == 10
        2
    elseif source.UWP.Starport == 11
        1
    elseif source.UWP.Starport == 14
        -1
    elseif source.UWP.Starport == 31
        -3
    else
        0
    end

    sourceTechLevelDM = if source.UWP.TechLevel <= 6
        -1
    elseif source.UWP.TechLevel >= 9
        2
    else
        0
    end
    
    destPopDM = if destination.UWP.Population <= 1
        -4
    elseif 6 <= destination.UWP.Population <= 7
        2
    elseif destination.UWP.Population >= 8
        4
    else
        0
    end

    destZoneDM = if destination.Zone == "Amber"
        -2
    elseif destination.Zone == "Red"
        -6
    else
        0
    end

    destStarportDM = if destination.UWP.Starport == 10
        2
    elseif destination.UWP.Starport == 11
        1
    elseif destination.UWP.Starport == 14
        -1
    elseif destination.UWP.Starport == 31
        -3
    else
        0
    end

    destTechLevelDM = if destination.UWP.TechLevel <= 6
        -1
    elseif destination.UWP.TechLevel >= 9
        2
    else
        0
    end

    distanceDM = max(0, (distance-1)*-1)

    val = max(1, checkEffect + cargoDM + sourcePopDM + sourceZoneDM + sourceStarportDM + sourceTechLevelDM + destPopDM + destZoneDM + destStarportDM + destTechLevelDM + distanceDM + userDM)
    numLots = dice(val, 6)

    if cargo == "Major"
        map(_ -> r1d6()*10, 1:numLots)
    elseif cargo == "Minor"
        map(_ -> r1d6()*5, 1:numLots)
    elseif cargo == "Incidental"
        map(_ -> r1d6(), 1:numLots)
    end
end

"""
    seekAllFreight(checkEffect, source, destination, distance [, noReturn, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM])

Return all the units of cargo (and possibly mail) going from one world to another.

# Arguments
- `checkEffect`: the Effect of a given check to look for cargo
- `source::World`: the `World` the travellers are on
- `destination::World`: the `World` they are going to
- `distance`: the distance (in parsecs)
- `noReturn`: whether to return a `Dict` with the freight or print it
- `maxNavalOrScoutRank`: the highest rank in the Navy or Scouts achieved by the travellers during character creation
- `maxSOC`: the highest Social Standing Dice Modifier possessed by the travellers
- `shipIsArmed`: whether or not the travellers' ship has weapons
- `userDM`: any Dice Modifier specified by the Referee


# Example
```julia-repl
julia> seekAllFreight(2, World("A434934-F"), World("A560565-8"), 2)
Major: [30, 60, 20, 50, 60, 50, 20, 10, 40, 10, 40, 30, 30, 60, 60, 30, 50, 10, 30, 20, 60, 20, 10, 50, 10, 50, 20, 30, 10, 20, 50]
Minor: [10, 20, 10, 30, 15, 10, 10, 10, 10, 5, 30, 10, 25, 30, 15, 15, 30, 25, 20, 15, 30, 25, 15, 15, 15, 30, 20, 25, 15, 5, 20, 5, 5, 5, 20, 30, 20, 30, 25, 5, 30, 10, 5, 5]
Incidental: [3, 2, 3, 3, 6, 1, 5, 6, 4, 6, 6, 6, 1, 1, 1, 6, 6, 4, 4, 3, 1, 3, 4, 4, 3, 3, 5, 6, 3, 4, 2, 3, 3, 2, 1, 6, 4, 2, 1, 6, 1, 5, 5, 3, 5, 1, 3, 4, 5, 1]
Mail: 5
```
"""
function seekAllFreight(checkEffect, source::World, destination::World, distance, noReturn=true, maxNavalOrScoutRank = 0, maxSOC = 0, shipIsArmed = false, userDM = 0)    
    majorCargo = seekFreight(checkEffect, source, destination, distance, "Major", userDM)
    minorCargo = seekFreight(checkEffect, source, destination, distance, "Minor", userDM)
    incidentalCargo = seekFreight(checkEffect, source, destination, distance, "Incidental", userDM)
    mail = seekMail(checkEffect, source, destination, distance, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM)

    if noReturn
        println("Major: ", majorCargo)
        println("Minor: ", minorCargo)
        println("Incidental: ", incidentalCargo)
        println("Mail: ", mail)
    else
        Dict("Major" => majorCargo, "Minor" => minorCargo, "Incidental" => incidentalCargo, "Mail" => mail)
    end
end

end
