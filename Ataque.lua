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

-- Obtener ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EffectsFolder = ReplicatedStorage:FindFirstChild("Effects")

if not EffectsFolder then
	warn("⚠ No se encontró la carpeta 'Effects' en ReplicatedStorage.")
	return
end

HitRE.OnServerEvent:Connect(function(player, enemy)
	if enemy and enemy:IsA("Model") then -- Asegurar que sea un modelo (como un NPC)
		local humanoid = enemy:FindFirstChildWhichIsA("Humanoid")
		local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") -- Compatibilidad con R6 y R15

		if humanoid and rootPart then
			-- ✅ Aplicar daño al enemigo
			humanoid:TakeDamage(Damage.Value)

			-- 🔥 Agregar efecto de partículas en el NPC golpeado
			local effectTemplate = EffectsFolder:FindFirstChild("HitEffect") -- Asegurar que la partícula existe
			if effectTemplate and effectTemplate:IsA("ParticleEmitter") then
				local clonedEffect = effectTemplate:Clone() -- Clonar la partícula
				local attachment = Instance.new("Attachment") -- Crear un punto de unión
				attachment.Parent = rootPart -- Poner el Attachment en el centro del NPC
				clonedEffect.Parent = attachment -- Asignar la partícula
				clonedEffect:Emit(10) -- Emitir partículas

				-- 🕒 Eliminar la partícula después de 1 segundo
				game:GetService("Debris"):AddItem(attachment, 1)
			end
		end
	end
end)
