-- Interstelliar
-- Scripted by ChatGPT

local s,id=GetID()

function s.initial_effect(c)
    -- Effect: Change name and gain LP
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

-- Only usable if this card is face-up on your field (handled by default)
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return true
end

-- Cost: Send top card of Deck to GY
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
    Duel.DiscardDeck(tp,1,REASON_COST)
end

-- Operation: Change name and gain LP
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    -- Name becomes "Interstellime" 
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(160311018) 
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)

    -- Gain 400 LP
    Duel.Recover(tp,400,REASON_EFFECT)
end
