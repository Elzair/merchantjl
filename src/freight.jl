# module Freight

# using Helpers: dice, r1d6, r2d6
# using Shared: PassageAndFreight
# using WorldInfo:UWP, World

# export seekAllFreight

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
    seekAllFreight(checkEffect, source, destination, distance [, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM])

Return all the units of cargo (and possibly mail) going from one world to another.

# Examples
```julia-repl
julia> seekAllFreight(2, World("A53890-8"), World("A560565–8"), 2)
Dict{String, Any} with 4 entries:
  "Minor"      => [30, 15, 30, 30, 5, 5, 20, 25, 15, 20  …  10, 10, 15, 20, 30, 25, 30, 5, 15, 10]
  "Incidental" => [1, 2, 2, 6, 4, 3, 2, 2, 2, 2  …  4, 3, 4, 3, 1, 5, 2, 5, 1, 4]
  "Major"      => [60, 40, 60, 30, 50, 30, 10, 10, 50, 30, 20, 20, 60, 60, 50, 30, 50, 30, 60, 40]
  "Mail"       => 4
```

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
function seekAllFreight(checkEffect, source::World, destination::World, distance, maxNavalOrScoutRank = 0, maxSOC = 0, shipIsArmed = false, userDM = 0)    
    majorCargo = seekFreight(checkEffect, source, destination, distance, "Major", userDM)
    minorCargo = seekFreight(checkEffect, source, destination, distance, "Minor", userDM)
    incidentalCargo = seekFreight(checkEffect, source, destination, distance, "Incidental", userDM)
    mail = seekMail(checkEffect, source, destination, distance, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM)
    Dict("Major" => majorCargo, "Minor" => minorCargo, "Incidental" => incidentalCargo, "Mail" => mail)
end

# end
