module Helpers

export dice, r1d6, r2d6, check, effect, tetra

function randuint(max)
    (rand(UInt64, 1) .% max .+ 1)[1]
end

function dice(num, type)
    Int64(sum(rand(UInt64, num) .% type .+ 1))
end

function r1d6()
    dice(1, 6)
end

function r2d6()
    dice(2, 6)
end

function check(skill)
    r2d6() + skill
end

function effect(skill, difficulty = 8)
    Integer(check(skill)) - difficulty
end

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

end
