local _G.CustomClass = game:WaitForChild("CustomClass").Value
_G.RoomThing = true
--Wanted gives you wanted parry
--Wanted parry CANNOT parry screen/gui based entities, cannot parry curses
--cannot parry Guardian ICBM and Springer.
--otherwise it can parry anything!
--Glider is just glider class. Suggested to use grappler as base
local Seed
if game.ReplicatedStorage.CodeVal.Value == "" then
	Seed = Random.new(tick())
else
  Seed = Random.new(game.ReplicatedStorage.CodeVal.Value)
end
print(Seed)
local Decorr = {
  ["hanging"] = {
	  Size = Vector3.new(5.244094848632812, 10.96673583984375, 5.331363677978516),
	  MeshId = "rbxassetid://87986911755363",
	  Color = Color3.fromRGB(255, 90, 134),
	  Material = Enum.Material.LeafyGrass,
	  Scale = Vector3.new(0.25, 0.25, 0.25)
  },
  ["randomVase"] = {
	 isRandomVase = true
  }
}
local function getSize(object)
	if object:IsA("Model") then
		return object:GetExtentsSize()
	else
		return object.Size
	end
end
local function placeOnEdge(targetPart, newPart, side, offset, dropOffset)
	offset = offset or 0
	dropOffset = dropOffset or 0

	local cf = targetPart.CFrame
	local size = targetPart.Size
	local halfNew = getSize(newPart) / 2

	local pos
	local right, up, look

	if side == "top" then
		pos = cf.Position + cf.UpVector * (size.Y/2 + halfNew.Y + offset)
		right = cf.RightVector
		up = cf.LookVector
		look = -cf.UpVector

	elseif side == "bottom" then
		pos = cf.Position - cf.UpVector * (size.Y/2 + halfNew.Y + offset)
		right = cf.RightVector
		up = -cf.LookVector
		look = cf.UpVector

	elseif side == "front" then
		pos = cf.Position + cf.LookVector * (size.Z/2 + halfNew.Z + offset)
		right = cf.RightVector
		up = cf.UpVector
		look = -cf.LookVector

	elseif side == "back" then
		pos = cf.Position - cf.LookVector * (size.Z/2 + halfNew.Z + offset)
		right = -cf.RightVector
		up = cf.UpVector
		look = cf.LookVector

	elseif side == "right" then
		pos = cf.Position + cf.RightVector * (size.X/2 + halfNew.X + offset)
		right = cf.LookVector
		up = cf.UpVector
		look = -cf.RightVector

	elseif side == "left" then
		pos = cf.Position - cf.RightVector * (size.X/2 + halfNew.X + offset)
		right = -cf.LookVector
		up = cf.UpVector
		look = cf.RightVector
	end

	local final = CFrame.fromMatrix(pos, right, up, look)

	-- push it slightly downward into the surface
	final = final - targetPart.CFrame.UpVector * dropOffset

	newPart:PivotTo(final)
end
local function createDecor(decorName)
	local data = Decorr[decorName]
	if not data then
		warn("decor not found:", decorName)
		return nil
	end
    if data.isRandomVase then
		local vasePool = {}
		for i,v in game.ReplicatedStorage.Lobby:GetDescendants() do
			if string.find(v.Name, "vase") then
				table.insert(vasePool, v)
			end
		end
		local vase = vasePool[Seed:NextInteger(1,#vasePool)]:Clone()
		return vase
	end
	local part = Instance.new("Part")

	-- apply size if present
	if data.Size then
		part.Size = data.Size
	end
    if data.Color then
		part.Color = data.Color
	end
	if data.Material then
		part.Material = data.Material
	end
	-- apply mesh id
	if data.MeshId then
	    local SpecialMesh = Instance.new("SpecialMesh")
		SpecialMesh.Parent = part
		SpecialMesh.MeshId = data.MeshId
		if data.Scale then
			SpecialMesh.Scale = data.Scale
		end
	end

	-- optional defaults (you can tweak/remove these)
	part.Anchored = true
	part.CanCollide = false

	return part
end
local conns = {}
local Mesh = Instance.new("CylinderMesh")
Mesh.Parent = workspace.Beacon
workspace.CurrentCamera.FieldOfView = 85
conns.descend = workspace.DescendantAdded:Connect(function(c)
if c.Name == "GrapplePoint" then
    local db = false
    local char = game.Players.LocalPlayer.Character
    c.Color = Color3.fromRGB(255, 144, 253)
	c.Size = Vector3.new(c.Size.X * 1.4, c.Size.Y * 1.4, c.Size.Z * 1.4)
	c.Material = Enum.Material.ForceField
	local cClone = c:Clone()
	cClone.Parent = c
	cClone.Name = "Lesmall"
	cClone.Size = Vector3.new(c.Size.X * 0.75, c.Size.Y * 0.75, c.Size.Z * 0.75)
	cClone.Material = Enum.Material.Neon
	for i,v in c:GetChildren() do
		if v:IsA("Texture") then
			v:Destroy()
		end
	end
	c.Touched:Connect(function(hit)
    if hit.Parent == char and not db and _G.CustomClass == "Glider" then
		db = true
		task.delay(0.5, function()
		db = false
		end)
		char.HumanoidRootPart.CFrame = c.CFrame + Vector3.new(0, 15, 0)
	end
	end)
end
end)
conns.sign = workspace.ChildAdded:Connect(function(c) ---
   if c.Name == "Select" then
	   workspace.Select:WaitForChild("Sign").Billboard.TextLabel.Font = Enum.Font.Garamond
local Description = workspace.Select.Sign.Billboard.TextLabel:Clone()
Description.Parent = workspace.Select.Sign.Billboard
Description.Name = "Description"
Description.Position = UDim2.new(0, 0, 0.6, 0)
Description.Size = UDim2.new(1, 0, 0.1, 0)
Description.TextColor3 = Color3.fromRGB(255, 255, 255)
if Description:FindFirstChild("UIStroke") then
	Description.UIStroke:Destroy()
end
local DescriptionStroke = Instance.new("UIStroke")
DescriptionStroke.Parent = Description
DescriptionStroke.Thickness = 5
local Sign = workspace.Select.Sign.Billboard.TextLabel
local SignStroke = Instance.new("UIStroke")
SignStroke.Parent = Sign
SignStroke.Transparency = 1
SignStroke.Thickness = 2.25
 if Sign.Text == "ENEMIES" or Sign.Text == "Enemies" then
	   Sign.Text = "Enemies"
	   Sign.TextColor3 = Color3.fromRGB(255, 154, 154)
	   Description.Text = "Choose an adversary."
	   SignStroke.Transparency = 0
	   SignStroke.Color = Color3.fromRGB(255, 0, 70)
   elseif Sign.Text == "CURSES" or Sign.Text == "Curses" then
	   Sign.Text = "Curses"
	   Sign.TextColor3 = Color3.fromRGB(255, 204, 237)
	   Description.Text = "Become accursed."
	   SignStroke.Transparency = 0
	   SignStroke.Color = Color3.fromRGB(128, 0, 128)
   elseif Sign.Text == "GREATER CURSES" or Sign.Text == "Greater Curses" then
	   Sign.Text = "Greater Curses"
	   Sign.TextColor3 = Color3.fromRGB(242, 157, 126)
	   Description.Text = "Become further hexed."
	   SignStroke.Transparency = 0
	   SignStroke.Color = Color3.fromRGB(247, 103, 87)
   elseif Sign.Text == "UPGRADES" or Sign.Text == "Upgrades" then
	   Sign.Text = "Upgrades"
	   Sign.TextColor3 = Color3.fromRGB(200, 200, 255)
	   Description.Text = "Receive an enhancement."
	   SignStroke.Transparency = 0
	   SignStroke.Color = Color3.fromRGB(153, 240, 255)
   else 
       SignStroke.Transparency = 1
	   Sign.TextColor3 = Color3.fromRGB(255, 255, 255)
	   Description.Text = "what"
   end
   end
end)
------------------------[]
conns.heartbeat = game:GetService("RunService").Heartbeat:Connect(function() ---

end)
------------
conns.rooms = workspace.CurrentRooms.ChildAdded:Connect(function(room) ---
if not _G.RoomThing then return end
local Decor = Instance.new("Folder")
Decor.Parent = room
for i,v in room:GetChildren() do
	if v:IsA("BasePart") and v.Transparency == 0 then
	    if v.Material == Enum.Material.Ice then
		    local bountiful = v:Clone()
			bountiful.Parent = Decor
		    local cMesh = Instance.new("CylinderMesh")
			cMesh.Parent = bountiful
			bountiful.Size = Vector3.new(v.Size.X * 1.6, v.Size.Y - 0.4, v.Size.Z * 1.6)
			bountiful.Transparency = 0.32
			bountiful.CanCollide = false
			continue
		end
		v.MaterialVariant = "4"
	    --down extension
	    local Patch5_Extension = v:Clone()
		Patch5_Extension.Parent = Decor
        Patch5_Extension.Size = Vector3.new(v.Size.X, v.Size.Y + 4, v.Size.Z)
		Patch5_Extension.Position = Vector3.new(v.Position.X, v.Position.Y - 6, v.Position.Z)
		Patch5_Extension.Name = "Extension"
		Patch5_Extension.CanCollide = false
	    -------------------------------
		--sides
		local Patch5_Sides = v:Clone()
		Patch5_Sides.Parent = Decor
		if v:IsA("UnionOperation") then
			Patch5_Sides.UsePartColor = true
		end
		Patch5_Sides.Color = Color3.fromRGB(170, 170, 170)
		Patch5_Sides.Material = Enum.Material.Plastic
		Patch5_Sides.MaterialVariant = "tile"
		Patch5_Sides.Size += Vector3.new(3, -1, 2)
		Patch5_Sides.Name = "Sides"
		Patch5_Sides.CanCollide = false
		local Patch5_Sides2 = Patch5_Sides:Clone()
		Patch5_Sides2.MaterialVariant = "2"
		Patch5_Sides2.Size = Vector3.new(Patch5_Sides2.Size.X - 0.5, Patch5_Sides2.Size.Y, Patch5_Sides2.Size.Z - 0.5)
		Patch5_Sides2.Position = Vector3.new(Patch5_Sides2.Position.X, Patch5_Sides2.Position.Y - Patch5_Sides.Size.Y + 0.25, Patch5_Sides2.Position.Z)
		Patch5_Sides2.Parent = Decor
		Patch5_Sides2.Name = "Sides2"
		Patch5_Sides2.CanCollide = false
		local Patch5_Sides3 = Patch5_Sides2:Clone()
		Patch5_Sides3.Name = "Sides3"
		Patch5_Sides3.Parent = Decor
		Patch5_Sides3.Position = Vector3.new(Patch5_Sides3.Position.X, Patch5_Sides3.Position.Y - (Patch5_Sides2.Size.Y * 2), Patch5_Sides3.Position.Z)
		Patch5_Sides3.CanCollide = false
		-------------------------------------------
		--decor
		if Seed:NextInteger(1,2) == 2 then
		local decorn = createDecor("hanging")
		decorn.Parent = Decor
		decorn.Name = "Leaves"
		decorn.CFrame = Patch5_Sides.CFrame
		if Seed:NextInteger(1,2) == 1 then
		
		placeOnEdge(Patch5_Sides, decorn, "left", -4.5, 6.5)
		else
		placeOnEdge(Patch5_Sides, decorn, "right", -4.5, 6.5)
		end
		end
		if Seed:NextInteger(1,5) == 1 then
		--vases
		local vase = createDecor("randomVase")
		vase.Parent = Decor
		vase.Name = "Vase"
		local direction = "left"
		if Seed:NextInteger(1,2) == 2 then
			direction = "right"
		end
		placeOnEdge(Patch5_Sides, vase, direction, -6.5, -6)
		end
	end
end
end)
------------WANTED--------------------
if _G.CustomClass == "Wanted" then
	local CAS = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local temporaryInterests = Instance.new("Folder")
temporaryInterests.Parent = game.ReplicatedStorage
temporaryInterests.Name = "Temp_Interests"

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local function playHighlight(model: Model)
	if not model then return end
    task.spawn(function()
	local highlight = Instance.new("Highlight")
	highlight.Adornee = model
	highlight.FillColor = Color3.fromRGB(120, 120, 120)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1

	highlight.Parent = model

	local fadeInInfo = TweenInfo.new(
		0.225,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local fadeOutInfo = TweenInfo.new(
		0.225,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In
	)

	local fadeInGoal = {
		FillTransparency = 0.5,
		OutlineTransparency = 0
	}

	local fadeOutGoal = {
		FillTransparency = 1,
		OutlineTransparency = 1
	}

	local tweenIn = TweenService:Create(highlight, fadeInInfo, fadeInGoal)
	local tweenOut = TweenService:Create(highlight, fadeOutInfo, fadeOutGoal)

	tweenIn:Play()
	tweenIn.Completed:Wait()

	if highlight.Parent then
		tweenOut:Play()
		tweenOut.Completed:Wait()
	end

	if highlight then
		highlight:Destroy()
	end
	end)
end
local function parryPop(character, strength)
    task.spawn(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- remove current vertical momentum so it feels consistent
	local velocity = hrp.AssemblyLinearVelocity
	hrp.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)

	-- upward impulse scaled by mass so it feels consistent across rigs
	local mass = hrp.AssemblyMass
	local upForce = Vector3.new(0, strength * mass, 0)

	hrp:ApplyImpulse(upForce)
	end)
end
local function playWhiteFade(fadeTime, shakeIntensity)
    task.spawn(function()
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local camera = workspace.CurrentCamera

	-- defaults
	fadeTime = fadeTime or 2
	shakeIntensity = shakeIntensity or 0.3

	-- create gui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FadeGui"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- create frame
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	-- store original camera cframe
	local originalCFrame = camera.CFrame

	-- fade + shake loop
	local startTime = tick()
	while true do
		local elapsed = tick() - startTime
		local alpha = elapsed / fadeTime

		-- fade
		frame.BackgroundTransparency = math.clamp(alpha, 0, 1)

		-- shake (strong at start, fades out)
		local strength = (1 - alpha) * shakeIntensity
		local offset = Vector3.new(
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2,
			(math.random() - 0.5) * 2
		) * strength

		camera.CFrame = originalCFrame * CFrame.new(offset)

		if alpha >= 1 then
			break
		end

		RunService.RenderStepped:Wait()
	end

	-- reset camera
	camera.CFrame = originalCFrame

	-- cleanup
	screenGui:Destroy()
	end)
end
local parryCD = false
local parryStreak = 0
task.spawn(function()
while task.wait(4.75) do
	if parryStreak > 0 then
		parryStreak -= 1
	end
end
end)
local function handleParry(actionName, inputState, inputObject)
	if inputState ~= Enum.UserInputState.Begin then return end
	if parryCD then return end
	parryCD = true
	task.delay(1.5, function()
    parryCD = false
	end)
	print("parrying")
    playHighlight(player.Character)
	for _, v in pairs(workspace.Enemies:GetChildren()) do
		if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
			print("foundEnemy")

			task.spawn(function()
				v.CanTouch = false
				
				local duration = 0.65
				local startTime = tick()
				
				local conn
				conn = RunService.Heartbeat:Connect(function()
					if not v or not v.Parent then
						conn:Disconnect()
						return
					end
					
					-- detect parts inside this enemy part
					local parts = workspace:GetPartBoundsInBox(v.CFrame, v.Size)
					
					for _, part in pairs(parts) do
						if part.Parent == player.Character then
							print("parried")
							parryCD = false
							parryStreak += 1
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry1"
							Sound.SoundId = "rbxassetid://93190478790141"
							Sound:Play()
							Sound.Volume = 1
							game.Debris:AddItem(Sound, Sound.TimeLength * 15)
							end)
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry2"
							Sound.SoundId = "rbxassetid://135509455058010"
							Sound:Play()
							game.Debris:AddItem(Sound, Sound.TimeLength * 15)
							end)
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry3"
							Sound.SoundId = "rbxassetid://132596270805754"
							Sound:Play()
							game.Debris:AddItem(Sound, Sound.TimeLength * 15)
							end)
							parryPop(player.Character, 35 + parryStreak * 20)
							playWhiteFade(0.5)
							v.Parent = game.ReplicatedStorage
							task.delay(0.95, function()
							v.Parent = workspace.Enemies
							v.CanTouch = true
							end)
							conn:Disconnect()
							return
						end
					end
					
					-- timeout
					if tick() - startTime >= duration then
						conn:Disconnect()
						if v then
							v.CanTouch = true
						end
					end
				end)
			end)
		end
	end
for _, v in pairs(workspace.Skinwalkers:GetDescendants()) do
		if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
			print("foundEnemy")

			task.spawn(function()
				v.CanTouch = false
				
				local duration = 0.65
				local startTime = tick()
				
				local conn
				conn = RunService.Heartbeat:Connect(function()
					if not v or not v.Parent then
						conn:Disconnect()
						return
					end
					
					-- detect parts inside this enemy part
					local parts = workspace:GetPartBoundsInBox(v.CFrame, v.Size)
					
					for _, part in pairs(parts) do
						if part.Parent == player.Character then
							print("parried")
							parryCD = false
							parryStreak += 1
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry1"
							Sound.SoundId = "rbxassetid://93190478790141"
							Sound:Play()
							Sound.Volume = 1
							game.Debris:AddItem(Sound, Sound.TimeLength * 2)
							end)
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry2"
							Sound.SoundId = "rbxassetid://135509455058010"
							Sound:Play()
							game.Debris:AddItem(Sound, Sound.TimeLength * 2)
							end)
							task.spawn(function()
							local Sound = Instance.new("Sound")
							Sound.Parent = game.Players.LocalPlayer.PlayerGui
							Sound.Name = "Parry3"
							Sound.SoundId = "rbxassetid://132596270805754"
							Sound:Play()
							game.Debris:AddItem(Sound, Sound.TimeLength * 2)
							end)
							parryPop(player.Character, 35 + parryStreak * 20)
							playWhiteFade(0.5)
							task.delay(0.95, function()
							v.CanTouch = true
							end)
							conn:Disconnect()
							return
						end
					end
					
					-- timeout
					if tick() - startTime >= duration then
						conn:Disconnect()
						if v then
							v.CanTouch = true
						end
					end
				end)
			end)
		end
	end	
	return Enum.ContextActionResult.Sink 
end

CAS:BindAction("ParryAction", handleParry, false, Enum.KeyCode.E)

end
------------GLIDER---------------------
if _G.CustomClass == "Glider" then
--// services
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// player
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local Anim = char.Humanoid.Animator:LoadAnimation(game:GetService("ReplicatedStorage").Animations.Instances.Default.GliderLoop)
--// settings
local BASE_SPEED = 35
local MAX_SPEED = 85
local MOMENTUM_BUILD_RATE = 1.2
local TURN_PENALTY = 3
local FALL_SPEED = -8

local MAX_GLIDE_TIME = 9
local COOLDOWN = 2

--// state
local gliding = false
local lastToggle = 0
local glideConnection

local glideStartTime = 0
local momentum = 0
local lastLook = nil
local canGlide = true

--// helper
local function isInAir()
	return humanoid.FloorMaterial == Enum.Material.Air
end

local function onLanded()
	canGlide = true
end

--// stop glide
local function stopGlide()
	if not gliding then return end
	char.Humanoid:SetAttribute("UsingAbility", false)
	gliding = false
    Anim:Stop()
	if char:FindFirstChild("DefaultGlider") then
		char:FindFirstChild("DefaultGlider"):Destroy()
	end
	if glideConnection then
		glideConnection:Disconnect()
		glideConnection = nil
	end

	humanoid.AutoRotate = true
end

--// start glide
local function startGlide()
	if gliding then return end
	if not isInAir() then return end
	if not canGlide then return end
	char.Humanoid:SetAttribute("UsingAbility", true)
	local glider = game:GetService("ReplicatedStorage").Movement.Instances.DefaultGlider:Clone()
	glider.Parent = char
	glider.GliderWeld.Part0 = glider
	glider.GliderWeld.Part1 = char.HumanoidRootPart
	glider.GliderWeld.C0 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	glider.GliderWeld.C1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    Anim:Play()
	gliding = true
	canGlide = true
	glideStartTime = tick()
	momentum = 0
	lastLook = root.CFrame.LookVector

	humanoid.AutoRotate = false

	glideConnection = RunService.RenderStepped:Connect(function(dt)
		if not char or not root then return end


		if not isInAir() then
			stopGlide()
			onLanded()
			glideStartTime = tick()
			return
		end

		if tick() - glideStartTime >= MAX_GLIDE_TIME then
			stopGlide()
			glideStartTime = tick()
			return
		end


		local camLook = camera.CFrame.LookVector

		-- prevent looking UP
		local clampedY = math.min(camLook.Y, 5) -- caps at 0 (no upward)
		local look = Vector3.new(camLook.X, clampedY, camLook.Z).Unit

	
		local targetCF = CFrame.lookAt(root.Position, root.Position + look, Vector3.new(0,1,0))
		root.CFrame = root.CFrame:Lerp(targetCF, 0.2)


		local flatLook = Vector3.new(look.X, 0, look.Z).Unit
		local lastFlat = Vector3.new(lastLook.X, 0, lastLook.Z).Unit

		local dot = flatLook:Dot(lastFlat)

		if dot > 0.98 then
			momentum = math.min(momentum + dt * MOMENTUM_BUILD_RATE, 1)
		else
			momentum = math.max(momentum - dt * TURN_PENALTY, 0)
		end

		lastLook = look

		local speed = BASE_SPEED + (MAX_SPEED - BASE_SPEED) * momentum

		-- apply velocity
-- dive factor (0 = flat, 1 = straight down)
local diveFactor = math.clamp(-look.Y, 0, 1)

-- dynamic fall speed
local dynamicFall = FALL_SPEED - (diveFactor * 40)

root.Velocity = Vector3.new(
	look.X * speed,
	dynamicFall,
	look.Z * speed
)
	end)
end

local CAS = game:GetService("ContextActionService")

local function handleGlide(actionName, inputState, inputObject)
	if inputState ~= Enum.UserInputState.Begin then return end

	-- cooldown check


	if gliding then
		stopGlide()
	else
		if tick() - lastToggle < COOLDOWN then return Enum.ContextActionResult.Sink end
	    lastToggle = tick()
		startGlide()
	end

	return Enum.ContextActionResult.Sink 
end
CAS:BindAction("GlideAction", handleGlide, false, Enum.KeyCode.E)




player.CharacterAdded:Connect(function(newChar)
	char = newChar
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
    Anim = char.Humanoid.Animator:LoadAnimation(game:GetService("ReplicatedStorage").Animations.Instances.Default.GliderLoop)
	stopGlide()
	canGlide = true
	glideStartTime = tick()
end)
end
---------------------------------------------------
local folder = Instance.new("Folder")
folder.Parent = game
folder.Name = "ScriptTest_Conn"
folder.Destroying:Once(function()
print("disconnecfted")
Mesh:Destroy()
workspace.CurrentCamera.FieldOfView = 70
if _G.CustomClass == "Glider" then
	 local CAS = game:GetService("ContextActionService")

CAS:UnbindAction("GlideAction")
end
if _G.CustomClass == "Wanted" then
	 local CAS = game:GetService("ContextActionService")

CAS:UnbindAction("ParryAction")
end
for i,v in conns do
	v:Disconnect()
end
end)
