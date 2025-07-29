--Galactica Healing
--created by COZZILLA
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetCondition(function(_,tp) return Duel.GetAttacker():IsControler(1-tp) end)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function s.cfilter(c)
    return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_GALAXY) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    --Effect
    if Duel.DiscardDeck(tp,3,REASON_EFFECT)~=3 or Duel.GetLP(tp)>100000000 then return end
        local ct=Duel.GetOperatedGroup():FilterCount(s.cfilter,nil)
        if ct>0 then
            Duel.BreakEffect()
            Duel.Recover(tp,ct*300,REASON_EFFECT)
	end
end 
