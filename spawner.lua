local RS = game:GetService("ReplicatedStorage")
local Npc = RS:WaitForChild("villano")
local spawner = workspace:WaitForChild("Spawner")

-- Evento para manejar la activación de la misión
local MisionEvento = RS:FindFirstChild("MisionEvento") -- Asegúrate de crear este evento en ReplicatedStorage

-- Configuración de oleadas
local maxEnemigos = 3  -- Número de enemigos por oleada
local totalEnemigos = 10 -- Total de enemigos en la oleada
local enemigosEliminados = 0
local enemigosActivos = 0
local oleadaActiva = false -- Ahora iniciará en `false` hasta que la misión esté activa
local misionActiva = false -- Controla si la misión ha sido aceptada

-- Función para activar la misión
local function activarMision()
	misionActiva = true
	oleadaActiva = true
	print("Misión activada, iniciando oleada...")
end

-- Conectar el evento para activar la misión
if MisionEvento then
	MisionEvento.OnServerEvent:Connect(activarMision)
else
	warn("MisionEvento no encontrado en ReplicatedStorage")
end

-- Función para manejar la muerte del NPC
local function enemigoMuerto(npc, player)
	enemigosActivos -= 1
	enemigosEliminados += 1
	npc:Destroy()

	-- Sumar 1 kill al jugador si el evento existe
	if MisionEvento and player then
		MisionEvento:FireServer(player, 1)  -- Enviar al servidor que sume 1 kill
	end

	-- Si se han eliminado todos los enemigos de la oleada
	if enemigosEliminados >= totalEnemigos then
		oleadaActiva = false -- Se detiene el spawner
		misionActiva = false -- Termina la misión
		print("Oleada completada, esperando la siguiente...")
	end
end

-- Función para generar NPCs de uno en uno
local function spawnEnemigos()
	while true do
		-- Solo generar enemigos si la misión está activa
		if misionActiva and oleadaActiva and enemigosEliminados < totalEnemigos and enemigosActivos < maxEnemigos then
			local clone = Npc:Clone()
			clone.Parent = workspace
			local HRP = clone:FindFirstChild("HumanoidRootPart")

			if HRP then
				HRP.CFrame = spawner.CFrame * CFrame.new(0, 5, 0)
			else
				warn("El NPC no tiene HumanoidRootPart")
			end

			enemigosActivos += 1

			-- Conectar evento de muerte
			local humanoid = clone:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Died:Connect(function()
					-- Obtener el jugador que mató al NPC (si existe)
					local tag = humanoid:FindFirstChild("creator")
					local killer = tag and tag.Value or nil
					enemigoMuerto(clone, killer)  -- Pasar el jugador al que se le sumará el kill
				end)
			end

			wait(3) -- 🔥 Aquí hacemos que salga **uno cada 3 segundos**
		end

		wait(1)  -- Revisión cada segundo para ver si se puede generar otro enemigo
	end
end

-- Iniciar el sistema de oleadas solo si la misión está activa
spawn(spawnEnemigos)
