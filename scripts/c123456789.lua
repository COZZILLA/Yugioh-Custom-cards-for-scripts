--Galactica Healing
--Created by COZZILLA
local s,id=GetID()

function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end

function s.cfilter(c)
    return c:IsRace(RACE_GALAXY) and c:IsPreviousLocation(LOCATION_DECK)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.DiscardDeck(tp,3,REASON_EFFECT)~=3 then return end

    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(s.cfilter,nil)

    if ct>0 then
        Duel.BreakEffect()
        Duel.Recover(tp,ct*300,REASON_EFFECT)
        if ct==3 then
            local tc=Duel.GetAttackTarget()
            if tc and tc:IsRelateToBattle() then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
                e1:SetValue(1)
                e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
                tc:RegisterEffect(e1,true)
            end
        end
    end
end