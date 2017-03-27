
function RemoveHealth(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_health_pct = ability:GetLevelSpecialValueFor("damage_health_pct", (ability:GetLevel() -1))/100
	local target_type = target.GetUnitLabel()

	-- Attaches the particle
	local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle,0,target:GetAbsOrigin())

	-- Play sound on target
	EmitSoundOn(keys.sound, target)

	if target_type ~= "boss"
		-- Removes hp %
		ApplyDamage({victim = target, attacker = caster, damage = target:GetHealth() * damage_health_pct, damage_type = ability:GetAbilityDamageType()})
	end
end