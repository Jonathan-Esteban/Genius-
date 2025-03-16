local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear el RemoteEvent si no existe
if not ReplicatedStorage:FindFirstChild("MisionCompletada") then
	local MisionCompletada = Instance.new("RemoteEvent")
	MisionCompletada.Name = "MisionCompletada"
	MisionCompletada.Parent = ReplicatedStorage
end

local MisionCompletadaEvent = ReplicatedStorage:FindFirstChild("MisionCompletada")

-- Crear leaderstats cuando un jugador se une
game.Players.PlayerAdded:Connect(function(player)
	-- Crear carpeta de estadísticas
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Crear la estadística de Monedas
	local monedas = Instance.new("IntValue")
	monedas.Name = "Monedas"
	monedas.Value = 0 -- Valor inicial
	monedas.Parent = leaderstats

	-- Crear la estadística de Misiones Completadas
	local misionesCompletadas = Instance.new("IntValue")
	misionesCompletadas.Name = "Oleadas Completas"
	misionesCompletadas.Value = 0 -- Valor inicial
	misionesCompletadas.Parent = leaderstats
end)

-- Escuchar evento para actualizar leaderstats
MisionCompletadaEvent.OnServerEvent:Connect(function(player, recompensaMonedas, misionesCompletadas)
	-- Asegurarse de que el jugador tiene leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		-- Sumar monedas
		local monedas = leaderstats:FindFirstChild("Kills")
		if monedas then
			monedas.Value = monedas.Value + recompensaMonedas
		end

		-- Sumar misiones completadas
		local misiones = leaderstats:FindFirstChild("MisionesCompletadas")
		if misiones then
			misiones.Value = misiones.Value + misionesCompletadas
		end
	end
end)
