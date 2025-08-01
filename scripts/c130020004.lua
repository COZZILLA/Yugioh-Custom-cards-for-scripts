--Dark Matter Voiroad
local s,id=GetID()
function s.initial_effect(c)
	-- Activate if a face-down monster exists on the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)

	-- Continuous DEF reduction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEF)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.deftg)
	e2:SetValue(s.defval)
	c:RegisterEffect(e2)
end

-- Requirement: A face-down monster is on the field
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

-- Target: Only face-up Defense Position monsters
function s.deftg(e,c)
	return c:IsDefensePos() and c:IsFaceup()
end

-- DEF reduction value: DARK Galaxy-type monsters in both GYs x -200
function s.defval(e,c)
	local ct=Duel.GetMatchingGroupCount(s.darkgalaxyfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return -ct*200
end

function s.darkgalaxyfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_GALAXY)
end
