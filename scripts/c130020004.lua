--Dark Convergence
local s,id=GetID()

function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)  -- This is valid and always defined
    c:RegisterEffect(e1)

    -- DEF reduction for face-up Defense Position monsters
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_DEF)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(s.defcon)
    e2:SetTarget(s.deftg)
    e2:SetValue(s.defval)
    c:RegisterEffect(e2)
end

-- Condition: A face-down monster is on the field
function s.defcon(e)
    return Duel.IsExistingMatchingCard(Card.IsFacedown, e:GetHandlerPlayer(), LOCATION_MZONE, LOCATION_MZONE, 1, nil)
end

-- Target only face-up Defense Position monsters
function s.deftg(e,c)
    return c:IsPosition(POS_FACEUP_DEFENSE)
end

-- DEF reduction: 200 x number of DARK Galaxy monsters in both Graveyards
function s.defval(e,c)
    local ct=Duel.GetMatchingGroup(s.galaxyfilter, c:GetControler(), LOCATION_GRAVE, LOCATION_GRAVE, nil):GetCount()
    return -200 * ct
end

-- DARK Attribute + Galaxy Type filter
function s.galaxyfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(0x2000000) -- Galaxy is usually 0x2000000 in custom race ID
end
