module Freight

using Helpers: dice, r1d6, r2d6
using Shared: PassageAndFreight
using WorldInfo UWP, World

export seekAllFreight

FreightTraffic = [ 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 8, 9, 10 ]

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

function seekAllFreight(checkEffect, source::World, destination::World, distance, maxNavalOrScoutRank = 0, maxSOC = 0, shipIsArmed = false, userDM = 0)    
    majorCargo = seekFreight(checkEffect, source, destination, distance, "Major", userDM)
    minorCargo = seekFreight(checkEffect, source, destination, distance, "Minor", userDM)
    incidentalCargo = seekFreight(checkEffect, source, destination, distance, "Incidental", userDM)
    mail = seekMail(checkEffect, source, destination, distance, maxNavalOrScoutRank, maxSOC, shipIsArmed, userDM)
    Dict("Major" => majorCargo, "Minor" => minorCargo, "Incidental" => incidentalCargo, "Mail" => mail)
end

end
