--Galaxy Resurrector
local s,id=GetID()
function s.initial_effect(c)
    -- Send this face-up card to GY as cost, then mill 1 and add DARK Galaxy Normals
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0)) -- Optional if you use descriptions
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Cost: Send this face-up card to the GY
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsFaceup() end
    Duel.SendtoGrave(c,REASON_COST)
end

-- Effect: Mill 1, then recover DARK Galaxy Normal Monsters
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_GALAXY) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end

function s.lv7filter(c)
    return c:IsFaceup() and c:IsLevelAbove(7)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Send top card of deck to GY
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
    Duel.DisableShuffleCheck()
    Duel.SendtoGrave(Duel.GetDecktopGroup(tp,1),REASON_EFFECT)
    
    -- Count face-up Level 7+ monsters on the field
    local ct=Duel.GetMatchingGroupCount(s.lv7filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if ct==0 then return end

    -- Select DARK Galaxy Normal Monsters from GY
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
    if #g==0 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,math.min(ct,#g),nil)
    if #sg>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
