-----------------------------------------------------------
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local JuegoID = 109006726919237 -- Pon La ID Del Juego A Donde Seras llevado.
local NombreDelJuego = "Dia 1" -- Pon El Nombre Del Lugar Donde Quieres Ir


local PartTP = script.Parent
local TextArea = script.Parent.Parent.Part.BillboardGui.TextLabel
TextArea.Text = NombreDelJuego

-----------------------------------------------------------

PartTP.Touched:Connect(function(hit)
	
	
	if hit.Parent:FindFirstChild("Humanoid") then
		
		wait(0.5)
		TextArea.Text = "Telenstraportando A " ..NombreDelJuego
		
		local char = hit.Parent
		local Player = game.Players:GetPlayerFromCharacter(char)
		TeleportService:Teleport(JuegoID, Player)
	end
	
	wait(5) -- tiempo a restaurar el TextArea a la normalidad
	TextArea.Text = NombreDelJuego
end)

