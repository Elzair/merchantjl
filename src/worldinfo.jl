# module WorldInfo

# using Helpers: tetra

# export UWP, World

"""
    getTradeCodes(st, si, at, hy, pop, gov, ll, tl)

Get the trade codes associated with a world with a given Universal World Profile

# Arguments
- `st::UInt8` Starport Quality
- `si::UInt8` Size of World
- `at::UInt8` Atmosphere Type
- `hy::UInt8` Hydographics
- `pop::UInt8` Population
- `gov::UInt8` Type of Government
- `ll::UInt8` Law Level
- `tl::UInt8` Tech Level
"""
function getTradeCodes(st::UInt8, si::UInt8, at::UInt8, hy::UInt8, pop::UInt8, gov::UInt8, ll::UInt8, tl::UInt8)
    tradeCodes::Vector{String} = []
    
    if 4 <= at <= 9 && 4 <= hy <= 8 && 5 <= pop <= 7
        push!(tradeCodes, "Ag")
    end
    
    if si == 0 && at == 0 && hy == 0
        push!(tradeCodes, "As")
    end
    
    if pop == 0 && gov == 0 && ll == 0
        push!(tradeCodes, "Ba")
    end
    
    if 2 <= at <= 9 && hy == 0
        push!(tradeCodes, "De")
    end
    
    if at >= 10 && hy >= 1
        push!(tradeCodes, "Fl")
    end
    
    if 6 <= si <= 8 && (at == 5 || at == 6 || at == 8) && 5 <= hy <= 7
        push!(tradeCodes, "Ga")
    end
    
    if pop >= 9
        push!(tradeCodes, "Hi")
    end
    
    if tl >= 12
        push!(tradeCodes, "Ht")
    end
    
    if (at == 0 || at == 1) && hy >= 1
        push!(tradeCodes, "Ic")
    end
    
    if ((0 <= at <= 2) || at == 4 || at == 7 || at == 9 || at == 10 || at == 11 || at == 12) && pop >= 9
        push!(tradeCodes, "In")
    end
    
    if 1 <= pop <= 3
        push!(tradeCodes, "Lo")
    end
    
    if pop >= 1 && tl <= 5
        push!(tradeCodes, "Lt")
    end
    
    if 0 <= at <= 3 && 0 <= hy <= 3 && pop >= 6
        push!(tradeCodes, "Na")
    end
    
    if 4 <= pop <= 6
        push!(tradeCodes, "Ni")
    end
    
    if 2 <= at <= 5 && 0 <= hy <= 3 
        push!(tradeCodes, "Po")
    end
    
    if (at == 6 || at == 8) && 6 <= pop <= 8 && 4 <= gov <= 9
        push!(tradeCodes, "Ri")
    end
    
    if at == 0
        push!(tradeCodes, "Va")
    end
    
    if ((3 <= at <= 9) || at >= 13) && hy >= 10
        push!(tradeCodes, "Wa")
    end
    
    tradeCodes
end


struct UWP
    Starport::UInt8
    Size::UInt8
    Atmosphere::UInt8
    Hydrographics::UInt8
    Population::UInt8
    Government::UInt8
    LawLevel::UInt8
    TechLevel::UInt8

"""
    UWP(uwpStr)

Constructor function for `UWP`

# Arguments
- `uwpStr::String` `String` representation of Universal World Profile
"""
    function UWP(uwpStr::String)
        matches = match(r"^(?<St>[A-FX0-9])(?<Si>[A0-9])(?<At>[A-F0-9])(?<Hy>[A0-9])(?<Pop>[A-C0-9])(?<Gov>[A-F0-9])(?<LL>[A-F0-9])(?:\-)?(?<TL>[A-F0-9])$", uwpStr)
        
        if matches === nothing
            throw(DomainError(uwpStr, "Argument must be a valid UWP"))
        end

        # Get UWP
        st = UInt8(tetra(only(matches["St"])))
        si = UInt8(tetra(only(matches["Si"])))
        at = UInt8(tetra(only(matches["At"])))
        hy = UInt8(tetra(only(matches["Hy"])))
        pop = UInt8(tetra(only(matches["Pop"])))
        gov = UInt8(tetra(only(matches["Gov"])))
        ll = UInt8(tetra(only(matches["LL"])))
        tl = UInt8(tetra(only(matches["TL"])))
        
        new(st, si, at, hy, pop, gov, ll, tl)
    end
end

struct World
    UWP::UWP
    Zone::String
    TradeCodes::Vector{String}

"""
    World(uwpStr[, zoneStr])

Constructor function for `World`

# Arguments
- `uwpStr::String` `String` representation of Universal World Profile

# Example
```julia-repl
julia> World("A538910-8")
World(Merchant.UWP(0x0a, 0x05, 0x03, 0x08, 0x09, 0x01, 0x00, 0x08), "None", ["Hi"])
```
"""
    function World(uwpStr::String, zoneStr::String = "None")
        uwp = UWP(uwpStr)

        # Get Trade Codes
        tradeCodes = getTradeCodes(uwp.Starport, uwp.Size, uwp.Atmosphere, uwp.Hydrographics,
                                   uwp.Population, uwp.Government, uwp.LawLevel, uwp.TechLevel)
        if zoneStr == "Red"
            push!(tradeCodes, "Rz")
        elseif zoneStr == "Amber"
            push!(tradeCodes, "Az")
        end
        
        new(uwp, zoneStr, tradeCodes)
    end
end

# end
