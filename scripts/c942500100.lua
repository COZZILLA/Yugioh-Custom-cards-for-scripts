--Unity Pulse (example name, change as needed)
local s,id=GetID()

function s.initial_effect(c)
    --Activate as Field Spell
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    -- ATK gain based on same-name monsters on each player's field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e2:SetTarget(s.atktg)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
end

-- Applies to face-up monsters only
function s.atktg(e,c)
    return c:IsFaceup()
end

-- Calculate 500 x number of *other* monsters with same name on that player's field
function s.atkval(e,c)
    if not c:IsFaceup() then return 0 end
    local p=c:GetControler()
    local g=Duel.GetMatchingGroup(function(tc) 
        return tc:IsFaceup() and tc:IsCode(c:GetCode()) and tc~=c
    end, p, LOCATION_MZONE, 0, nil)
    return g:GetCount() * 500
end
