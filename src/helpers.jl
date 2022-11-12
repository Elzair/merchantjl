# module Helpers                 

# export dice, r1d6, r2d6, check, effect, tetra

"""
    randuint(max)

Generate a random UInt64 in the range of 1 to `max` inclusive

# Arguments
- `max` the maximum number to generate
"""
function randuint(max)
    (rand(UInt64, 1) .% max .+ 1)[1]
end

"""
    dice(num, type)

Roll `num` virtual dice with `type` sides, add them, and return
"""
function dice(num, type)
    Int64(sum(rand(UInt64, num) .% type .+ 1))
end

"""
    r1d6()

Same as `dice(1, 6)`
"""
function r1d6()
    dice(1, 6)
end

"""
    r2d6()

Same as `dice(2, 6)`
"""
function r2d6()
    dice(2, 6)
end

"""
    check(skill)

Roll 2d6 and add `skill`

# Arguments
- `skill` the number to add to 2d6
"""
function check(skill)
    r2d6() + skill
end

"""
    effect(skill[, difficulty])

Make a skill check and subtract it by the `difficulty` to get the effect of the check

# Arguments
- `skill` the level of the skill being checked
- `difficulty` the difficulty of the check
"""
function effect(skill, difficulty = 8)
    Integer(check(skill)) - difficulty
end

"""
    tetra(c)

Convert a `Char` representation of a tetratrigesimal (i.e. base-34) number to an `Integer`

# Arguments
- `c::Char` a `Char` in the range of '0'-'9' or 'A'-'H' or 'J'-'N' or 'P'-'Z' (Must be upper case)
"""
function tetra(c::Char)
    if '0' <= c <= '9'
        c - '0'
    elseif 'A' <= c <= 'H'
        c - 'A' + 10
    elseif 'J' <= c <= 'N'
        c - 'A' + 9 # Skip 'I' since it looks like '1'
    elseif 'P' <= c <= 'Z'
        c - 'A' + 8 # Skip 'O' since it looks like '0'
    else
        throw(DomainError(c, "Invalid tetratrigesimal number"))
    end
end

#end
