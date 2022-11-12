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
- `excitingPct` the percent chance of generating 'exciting' passengers
- `passengerPct` the percentage of passengers who are 'exciting'
- `userDM` a Referee-specified Dice Modifier to add to the check for passengers

# Example
```julia-repl
julia> seekAllPassengers(2, 2, World("A434934-F"), World("A560565-8"), 2)
Dict{String, Tuple{Int64, Any}} with 4 entries:
  "Low"    => (42, ["Spy", "Scientist", "Possesses Something Dangerous or Illegal", "On the Run", "Causes Trouble", "Rich Noble - Complains a Lot", "Spy", "Bounty Hunter"])
  "Middle" => (45, nothing)
  "High"   => (17, ["Mercenary", "Gamber", "Refugee - Political"])
  "Basic"  => (37, ["Wanderer", "Thief or Other Criminal", "Rich Noble - Eccentric", "Gamber", "Refugee - Political", "Alien", "Entertainer"])
```
"""
function seekAllPassengers(checkEffect, maxStewardSkill, source::World, destination::World, distance, excitingPct = 0.5, passengerPct = 0.2, userDM = 0)
    highPassengers = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "High", userDM)
    middlePassengers = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Middle", userDM)
    basicPassengers = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Basic", userDM)
    lowPassengers = seekPassengers(checkEffect, maxStewardSkill, source, destination, distance, "Low", userDM)

    Dict("High" => highPassengers, "Middle" => middlePassengers, "Basic" => basicPassengers, "Low" => lowPassengers)
end

# end
