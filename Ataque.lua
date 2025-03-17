local tool = script.Parent
local HitRE = tool:FindFirstChild("HitRE") -- Asegurar que exista
local Damage = tool:FindFirstChild("Damage")

if not HitRE then
	warn("⚠ No se encontró el RemoteEvent 'HitRE' en la herramienta.")
	return
end

if not Damage or not Damage:IsA("NumberValue") then
	warn("⚠ 'Damage' no es un NumberValue o no existe.")
	return
end

HitRE.OnServerEvent:Connect(function(player, enemy)
	if enemy and enemy:IsA("Model") then -- Asegurar que sea un Model (como un personaje)
		local humanoid = enemy:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid:TakeDamage(Damage.Value)
			print("✅ Daño aplicado a:", enemy.Name, "con", Damage.Value, "de daño.")
		else
			warn("⚠ No se encontró un Humanoid en", enemy.Name)
		end
	else
		warn("⚠ 'enemy' no es un Model válido.")
	end
end)
