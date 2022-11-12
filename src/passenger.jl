# module Passenger

using StatsBase: sample

# using Helpers: dice
# using Shared: PassageAndFreight
# using World: UWP, World

# export seekAllPassengers

PassengerTraffic = [0, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 7, 8, 9, 10]

RandomPassenger = [
    "Refugee - Political"
    "Refugee - Economic"
    "Starting a New Life Offworld"
    "Mercenary"
    "Spy"
    "Corporate Executive"
    "Out to See the Universe"
    "Tourist"
    "Wide-Eyed Yokel"
    "Adventurer"
    "Explorer"
    "Claustrophobic"
    "Expectant Mother"
    "Wants to Stowaway or Join the Crew"
    "Possesses Something Dangerous or Illegal"
    "Causes Trouble"
    "Unusually Pretty or Handsome"
    "Engineer"
     "Ex-Scout"
    "Wanderer"
    "Thief or Other Criminal"
    "Scientist"
    "Journalist or Researcher"
    "Entertainer"
    "Gamber"
    "Rich Noble - Complains a Lot"
    "Rich Noble - Eccentric"
    "Rich Noble - Raconteur"
    "Diplomat on a Mission"
    "Agent on a Mission"
    "Patron"
    "Alien"
    "Bounty Hunter"
    "On the Run"
    "Wants to be on Board the Travellers' Ship for Some Reason"
    "Hijacker or Pirate Agent"
]

"""
    getExcitinPassengers(numPassengers, excitingPct, passengerPct)

Make some of the passengers 'exciting' passengers to liven up a session

# Arguments
- `numPassengers` the total number of passengers
- `excitingPct` the percent chance of generating 'exciting' passengers
- `passengerPct` the percentage of passengers who are 'exciting'
"""
function getExcitingPassengers(numPassengers, excitingPct = 0.5, passengerPct = 0.2)
    excitingChance = rand(Float64, 1)[1]

    if excitingChance <= excitingPct
        numExcitingPassengers = Unsigned(round(passengerPct * numPassengers))
        sample(RandomPassenger, numExcitingPassengers)
    end
end

"""
    seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, passenger [, userDM, excitingPct, passengerPct])

Seek out passengers of a certain type for a certain route

# Arguments
- `checkEffect` the effect of a check to find passengers
- `maxStewardSkill` the maximum level of Steward possessed by the travellers
- `source::World` where the passengers are now
- `destination::World` where the passengers want to go
- `distance` the distance (in parsecs)
- `passenger` the type of passenger ("Low", "Middle", "High", or "Basic")
- `userDM` a Referee-specified Dice Modifier to add to the check for passengers
- `excitingPct` the percent chance of generating 'exciting' passengers
- `passengerPct` the percentage of passengers who are 'exciting'
"""
function seekPassengers(checkEffect, maxStewardSkill, source::World, destination::World, distance, passenger::String, userDM = 0, excitingPct = 0.5, passengerPct = 0.2)
    passengerDM = if passenger == "High"
        -4
    elseif passenger == "Low"
        1
    else
        0
    end

    sourcePopDM = if source.UWP.Population <= 1
        -4
    elseif 6 <= source.UWP.Population <= 7
        1
    elseif source.UWP.Population >= 8
        3
    else
        0
    end

    sourceZoneDM = if source.Zone == "Amber"
        1
    elseif source.Zone == "Red"
        -4
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
    
    destPopDM = if destination.UWP.Population <= 1
        -4
    elseif 6 <= destination.UWP.Population <= 7
        1
    elseif destination.UWP.Population >= 8
        3
    else
        0
    end

    destZoneDM = if destination.Zone == "Amber"
        1
    elseif destination.Zone == "Red"
        -4
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

    distanceDM = max(0, (distance-1)*-1)

    val = max(1, checkEffect + maxStewardSkill + passengerDM + sourcePopDM + sourceZoneDM +
              sourceStarportDM + destPopDM + destZoneDM + destStarportDM + distanceDM + userDM)
    numPassengers = dice(val, 6)
    
    (numPassengers, getExcitingPassengers(numPassengers))
    # numPassengers
end

"""
    seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, passenger [, noReturn, userDM, excitingPct, passengerPct])

Seek out passengers of a certain type for a certain route

# Arguments
- `checkEffect` the effect of a check to find passengers
- `maxStewardSkill` the maximum level of Steward possessed by the travellers
- `source::World` where the passengers are now
- `destination::World` where the passengers want to go
- `distance` the distance (in parsecs)
- `noReturn`: whether to return a `Dict` with the freight or print it
- `excitingPct` the percent chance of generating 'exciting' passengers
- `passengerPct` the percentage of passengers who are 'exciting'
- `userDM` a Referee-specified Dice Modifier to add to the check for passengers

# Example
```julia-repl
julia> seekAllPassengers(2, 2, World("A434934-F"), World("A560565-8"), 2)
High: #12 nothing
Middle: 45 ["Wants to Stowaway or Join the Crew", "Bounty Hunter", "Wide-Eyed Yokel", "Gamber", "Alien", "Wanderer", "Mercenary", "Engineer", "Refugee - Economic"]
Basic: 32 ["Diplomat on a Mission", "Refugee - Political", "Out to See the Universe", "Ex-Scout", "Corporate Executive", "Claustrophobic"]
Low: 39 nothing
```
"""
function seekAllPassengers(checkEffect, maxStewardSkill, source::World, destination::World, distance, noReturn=true, excitingPct = 0.5, passengerPct = 0.2, userDM = 0)
    (numHP, excHP) = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "High", userDM)
    (numMP, excMP) = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Middle", userDM)
    (numBP, excBP) = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Basic", userDM)
    (numLP, excLP) = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Low", userDM)

    if noReturn
        println("High: #", numHP, " ", excHP)
        println("Middle: ", numMP, " ", excMP)
        println("Basic: ", numBP, " ", excBP)
        println("Low: ", numLP, " ", excLP)
    else
        Dict("High" => (numHP, excHP), "Middle" => (numMP, excMP), "Basic" => (numBP, excBP), "Low" => (numLP, excLP))
    end
end

# end
