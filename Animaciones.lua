local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildWhichIsA("Humanoid")

if not humanoid then
	warn("No se encontró Humanoid")
	return
end

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
	warn("No se encontró Animator, creando uno nuevo.")
	animator = Instance.new("Animator")
	animator.Parent = humanoid
end

local tool = script.Parent
local HitRE = tool:FindFirstChild("HitRE")

if not HitRE then
	warn("HitRE no encontrado en el tool.")
end

local Animations = tool:FindFirstChild("Animations")
if not Animations then
	warn("No se encontró el folder Animations.")
	return
end

local HitAnim = Animations:FindFirstChild("Hit")
local IdleAnim = Animations:FindFirstChild("Idle")

if not HitAnim or not IdleAnim then
	warn("Las animaciones no se encontraron. HitAnim:", HitAnim, "IdleAnim:", IdleAnim)
	return
end

local IdleTrack = animator:LoadAnimation(IdleAnim)
local HitTrack = animator:LoadAnimation(HitAnim)

-- Asegurar que la animación tenga prioridad
HitTrack.Priority = Enum.AnimationPriority.Action
IdleTrack.Priority = Enum.AnimationPriority.Idle

local Blade = tool:FindFirstChild("Blade")
if not Blade then
	warn("No se encontró Blade en el tool.")
	return
end

local HitSound = Blade:FindFirstChild("Sound")
if not HitSound then
	warn("No se encontró Sound en Blade.")
end

local debounce = false
local canHit = true

tool.Equipped:Connect(function()
	IdleTrack:Play()
end)

tool.Unequipped:Connect(function()
	if IdleTrack.IsPlaying then
		IdleTrack:Stop()
	end
end)

tool.Activated:Connect(function()
	if debounce then return end
	debounce = true

	-- Detener la animación de idle antes de atacar
	if IdleTrack.IsPlaying then
		IdleTrack:Stop()
	end

	-- Intentar reproducir la animación de ataque
	if HitTrack then
		HitTrack:Play()
	else
		warn("No se encontró HitTrack")
	end

	-- 🔥 Activar partículas en el momento exacto del ataque
	for _, effect in pairs(Blade:GetChildren()) do
		if effect:IsA("ParticleEmitter") then
			effect.Enabled = true -- Activar partículas
			effect:Emit(5) -- Emitir partículas en el golpe
		end
	end

	-- ⏳ Esperar un momento y desactivar partículas nuevamente
	task.wait(0.2)
	for _, effect in pairs(Blade:GetChildren()) do
		if effect:IsA("ParticleEmitter") then
			effect.Enabled = false -- Desactivar partículas
		end
	end

	task.wait(0.5)
	debounce = false
	IdleTrack:Play()
end)


-- 🛠 **Nuevo Código para Detectar Golpes y Enviar al Servidor**
Blade.Touched:Connect(function(hit)
	if canHit and hit and hit.Parent then
		local enemy = hit.Parent
		local enemyHumanoid = enemy:FindFirstChildWhichIsA("Humanoid")

		-- Evitar golpear al propio jugador
		if enemyHumanoid and enemy ~= character then
			canHit = false
			print("🔥 Cliente: Golpe detectado en", enemy.Name)

			if HitRE then
				HitRE:FireServer(enemy) -- Enviar golpe al servidor
			else
				warn("⚠ No se pudo enviar el golpe, HitRE no existe.")
			end

			task.wait(0.5)
			canHit = true
		end
	end
end)
