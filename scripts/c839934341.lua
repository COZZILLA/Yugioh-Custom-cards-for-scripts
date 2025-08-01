--Dark Galaxy Conversion
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.reqcon)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Check if opponent has any face-up cards
function s.reqcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
end

-- Check for DARK Galaxy-Type monster
function s.galaxyfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_GALAXY) and c:IsAbleToGraveAsCost()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local count=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
    if chk==0 then
        return count>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=count and
            Duel.GetMatchingGroup(s.galaxyfilter,tp,LOCATION_HAND,0,nil):GetCount()>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local g=hand:Select(tp,count,count,nil)
    if not g:IsExists(s.galaxyfilter,1,nil) then
        -- enforce sending 1 DARK Galaxy Type monster
        Duel.Hint(HINT_SELECTMSG,tp,"Select 1 DARK Galaxy-Type monster")
        local galaxy=Duel.SelectMatchingCard(tp,s.galaxyfilter,tp,LOCATION_HAND,0,1,1,nil)
        g:RemoveCard(galaxy:GetFirst())
        g:AddCard(galaxy:GetFirst())
    end
    e:SetLabel(g:GetCount()) -- store number sent to GY
    Duel.SendtoGrave(g,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct>0 then
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
