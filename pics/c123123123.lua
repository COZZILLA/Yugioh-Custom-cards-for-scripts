--Galactica Singularity
--Created by COZZILLA
local s,id=GetID()

function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- You have 3 face-up Galaxy-Type Normal Monsters
function s.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_GALAXY) and c:IsType(TYPE_NORMAL)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)==3
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end

    Duel.DiscardDeck(tp,3,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if not g or g:GetCount()<3 then return end

    local hasMonster=g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
    local hasSpell=g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
    local hasTrap=g:IsExists(Card.IsType,1,nil,TYPE_TRAP)

    if hasMonster and hasSpell and hasTrap then
        Duel.BreakEffect()
        local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,nil)
        if tg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
            and tg:IsExists(Card.IsType,1,nil,TYPE_SPELL)
            and tg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then

            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local mg=tg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=tg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SPELL)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local tg2=tg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_TRAP)

            mg:Merge(sg)
            mg:Merge(tg2)
            Duel.SendtoHand(mg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,mg)
        end
    end
end
