local part = script.Parent
local light = part:FindFirstChild("PointLight")
local sound = part:FindFirstChild("LightSound") -- Asegúrate de que la Part tenga un objeto Sound llamado "LightSound"

-- Material y color cuando la luz está apagada
local materialOff = Enum.Material.Metal
local colorOff = Color3.new(0.5, 0.5, 0.5)  -- Color gris

-- Material y color cuando la luz está encendida
local materialOn = Enum.Material.Neon
local colorOn = Color3.new(1, 1, 1)  -- Color blanco

local isOn = true

-- Función para cambiar el material y color de la Part
local function updateMaterialAndColor()
	if isOn then
		part.Material = materialOn
		part.BrickColor = BrickColor.new(colorOn)
	else
		part.Material = materialOff
		part.BrickColor = BrickColor.new(colorOff)
	end
end

while true do
	-- Espera entre 10 y 15 segundos antes del parpadeo
	wait(math.random(10, 15))

	-- Apagar la luz
	light.Enabled = false
	isOn = false
	updateMaterialAndColor()

	-- Reproducir sonido si existe
	if sound then
		sound:Play()
	end

	-- Esperar entre 1 y 2 segundos antes de volver a encender
	wait(math.random(1, 2))

	-- Encender la luz
	light.Enabled = true
	isOn = true
	updateMaterialAndColor()

	-- Reproducir sonido de nuevo si existe
	if sound then
		sound:Play()
	end
end
