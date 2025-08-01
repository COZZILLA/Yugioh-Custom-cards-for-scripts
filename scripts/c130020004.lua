--Dark Convergence
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)  
    c:RegisterEffect(e1)

    -- DEF reduction effect
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

-- Condition: there must be a face-down monster on the field
function s.defcon(e)
    return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

-- Target: face-up Defense Position monsters
function s.deftg(e,c)
    return c:IsPosition(POS_FACEUP_DEFENSE)
end

-- Value: -200 DEF × number of DARK Galaxy monsters in both GYs
function s.defval(e,c)
    local g=Duel.GetMatchingGroup(function(tc)
        return tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsRace(RACE_GALAXY)
    end, c:GetControler(), LOCATION_GRAVE, LOCATION_GRAVE, nil)
    return -200 * g:GetCount()
end
