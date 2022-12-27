local NotifyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notifier = NotifyLibrary.Notify

-- Anti Reload

if getgenv().ViperLoaded then
        Notifier({
            Description = "Viper Already Executed",
            Title = "Error",
            Duration = 5
        })
    return
end

pcall(function()
    getgenv().ViperLoaded = true
end)

-- Variables, Casts, and Objects

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.Camera
local Storage = game:GetService("ReplicatedStorage")
local ChatEvent = Storage.DefaultChatSystemChatEvents.SayMessageRequest
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player.Backpack
local PlaceId = game.PlaceId
local JobId = game.JobId

-- Viper Configurations

getgenv().ViperPrefix = "-" -- Set the prefix to whichever you prefer
getgenv().ViperWalkSpeed = 16
getgenv().ViperJumpOffset = -0.2
getgenv().ViperReach = 30
getgenv().ViperAmplifier = 10
getgenv().SpawnDistance = 25
getgenv().ViperKillDelay = 0.11
getgenv().ViperColor = 100, 0, 0
getgenv().ViperWhitelist = {}
getgenv().ViperTick = tick()
getgenv().ViperAutoSwing = false
getgenv().ViperAutoToxic = false
getgenv().ViperVisualizer = true

function Shorten(Username)
    local PlayerList = {}
    for i,plrs in pairs(Players:GetPlayers()) do
        if plrs.Name:lower():sub(1, #Username) == Username:lower() then
            table.insert(PlayerList,plrs)
        end
    end
    return PlayerList
end

if PlaceId == 5278850819 then
    local ACANDSTAFF = loadstring(game:HttpGet("https://raw.githubusercontent.com/OptioniaI/AntiBan-RejoinKick/main/Script"))()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
    local WindowOne = Library:CreateWindow("Viper")
    local PageOne = WindowOne:CreateFolder("Blatant")
    local PageTwo = WindowOne:CreateFolder("Visuals")
    local PageThree = WindowOne:CreateFolder("Miscellaneous")

    local RandomMessage = Random.new()
    local Remotes = Storage["Remotes"]
    local KillEvent = Remotes["StudEvent"]
    local Gifts = Workspace.Gifts
    local Structure = Workspace.Structure
    local Spawn = Structure.SpawnLocation

    -- Page One Configurations

    PageOne:Slider("Reach", {
        min = 0,
        max = 30,
        precise = false
    },
    function(Value)
        getgenv().ViperReach = tonumber(Value)
    end)

    PageOne:Slider("Damage", {
        min = 0,
        max = 10,
        precise = false
    },
    function(Value)
        getgenv().ViperAmplifier = tonumber(Value)
    end)

    PageOne:Slider("WalkSpeed", {
        min = 16,
        max = 55,
        precise = false
    },
    function(Value)
        getgenv().ViperWalkSpeed = tonumber(Value)
    end)

    PageOne:Toggle("Auto Swing", function(Value)
        getgenv().ViperAutoSwing = Value
    end)

    PageOne:Toggle("Auto Toxic", function(Value)
        getgenv().ViperAutoToxic = Value
    end)

    PageOne:Toggle("Reach Visualizer", function(Value)
        getgenv().ViperVisualizer = Value
    end)

    PageOne:Box("Kill", "string", function(Value)
        for _, TargetKill in pairs(Shorten(Value)) do
            if TargetKill.Character.Humanoid.Health > 0 and not table.find(getgenv().ViperWhitelist, TargetKill.UserId) then
                pcall(function()
                    local Old = Player.Character:WaitForChild("HumanoidRootPart").CFrame
                    local Distance = (Player.Character.HumanoidRootPart.Position - TargetKill.Character.HumanoidRootPart.Position).Magnitude
                    local Speed = Distance/tonumber(math.huge)
                    local Tween = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = TargetKill.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)})
                    Tween:Play()
                    task.wait(getgenv().ViperKillDelay)
                    Player.Character.HumanoidRootPart.CFrame = Old
                end)
            end
        end
    end)

    PageOne:Box("Goto", "string", function(Value)
        for _, TargetGoto in pairs(Shorten(Value)) do
            if TargetGoto.Character.Humanoid.Health > 0 then
                local TweenLoop
                local TouchLoop
                TweenLoop = RunService.RenderStepped:Connect(function()
                    pcall(function()
                        local Distance = (Player.Character.HumanoidRootPart.Position - TargetGoto.Character.HumanoidRootPart.Position).Magnitude
                        local Speed = Distance/tonumber(55)
                        local Tween = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {CFrame = TargetGoto.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)})
                        Tween:Play()
                        TouchLoop = TargetGoto.Character.HumanoidRootPart.Touched:Connect(function()
                            TweenLoop:Disconnect()
                            TouchLoop:Disconnect()
                        end)
                    end)
                end)
            end
        end
    end)

    -- Page Two Configurations

    PageTwo:Box("Sword Position", "string", function(Value)
        pcall(function()
            if Player.Character:FindFirstChildOfClass("Tool") then
                Player.Character.Humanoid:UnequipTools()
            end
            Backpack:FindFirstChildOfClass("Tool").GripPos = Vector3.new(Value, 0, 0)
            task.wait(0.01)
            Player.Character.Humanoid:EquipTool(Backpack:FindFirstChildOfClass("Tool"))
        end)
    end)

    -- Page Three Configurations

    PageThree:Slider("Kill Delay", {
        min = 0.1,
        max = 0.5,
        precise = true
    },
    function(Value)
        getgenv().ViperKillDelay = tonumber(Value)
    end)

    PageThree:ColorPicker("ColorPicker", Color3.fromRGB(100, 0, 0), function(ColorValue)
        getgenv().ViperColor = ColorValue
    end)

    PageThree:Button("Rejoin", function()
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
    end)

    PageThree:Button("Server Hop", function()
        local ServerTables = {}
        for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
        	    ServerTables[#ServerTables + 1] = v.id
            end
        end
        if #ServerTables > 0 then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, ServerTables[math.random(1, #ServerTables)])
            end)
        else
            Notifier({
                Description = "No Servers Found",
                Title = "Error",
                Duration = 5.75
            })
        end
    end)

    local Messages = {
        "{v} has been put to eternal rest",
        "{v} is now deceased",
        "36 hub be gone!",
        "{v} has departed away"
    }

    RunService.RenderStepped:Connect(function()
        pcall(function()
            for _, FindPlayer in pairs(Players:GetPlayers()) do
                if FindPlayer ~= Player and not table.find(getgenv().ViperWhitelist, FindPlayer.UserId) then
                    if FindPlayer.Character.Humanoid.Health > 0 then
                        if math.floor((FindPlayer.Character.HumanoidRootPart.Position - Spawn.Position).Magnitude) > getgenv().SpawnDistance then
                            if (FindPlayer.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < getgenv().ViperReach then
                                for _, TargetParts in pairs(FindPlayer.Character:GetChildren()) do
                                    if table.find(getgenv().ViperWhitelist, FindPlayer.UserId) then
                                        return
                                    end
                                    if TargetParts:IsA("BasePart") then
                                        if FindPlayer.Character:FindFirstChild("LLeft Aarm") then
                                            FindPlayer.Character:FindFirstChild("LLeft Aarm"):Destroy()
                                        end
                                        if math.abs(tick() - getgenv().ViperTick) < 0 then
                                            return
                                        end
                                        getgenv().ViperTick = tick()
                                        firetouchinterest(Player.Character:FindFirstChildOfClass("Tool").Handle, TargetParts, 0)
                                        firetouchinterest(Player.Character:FindFirstChildOfClass("Tool").Handle, TargetParts, 1)
                                        for Amplify = 1, getgenv().ViperAmplifier do
                                            firetouchinterest(Player.Character:FindFirstChildOfClass("Tool").Handle, TargetParts, 0)
                                            firetouchinterest(Player.Character:FindFirstChildOfClass("Tool").Handle, TargetParts, 1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        pcall(function()
            for _, Time in pairs(Gifts:GetChildren()) do
                if Time:IsA("BasePart") then
                    if (Time.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 30 then
                        firetouchinterest(Time, Player.Character.HumanoidRootPart, 0)
                        firetouchinterest(Time, Player.Character.HumanoidRootPart, 1)
                    end
                end
            end
        end)
        pcall(function()
            Player.Character:FindFirstChildOfClass("Tool").Handle.Massless = true
        end)
        pcall(function()
            if getgenv().ViperAutoSwing then
                Player.Character:FindFirstChildOfClass("Tool"):Activate()
            end
        end)
        pcall(function()
            Player.Character.HumanoidRootPart.Velocity = Vector3.new(Player.Character.Humanoid.MoveDirection.X * getgenv().ViperWalkSpeed, Player.Character.HumanoidRootPart.Velocity.Y + getgenv().ViperJumpOffset, Player.Character.Humanoid.MoveDirection.Z * getgenv().ViperWalkSpeed)
        end)
    end)

    function ViperEquip()
        Player.Character.ChildAdded:Connect(function(Tool)
            pcall(function()
                if Tool:FindFirstChild("Handle") then
                    local ViperCompiler = Instance.new("Folder", Camera)
                    local ViperPart = Instance.new("Part", ViperCompiler)
                    local ViperHolder = Instance.new("Weld", ViperCompiler)
                    local ViperVisualizer = Instance.new("SelectionSphere", ViperCompiler)
                    -- Viper Compiler
                    ViperCompiler.Name = "ViperCompiler"
                    -- Viper Part
                    ViperPart.Name = "ViperPart"
                    ViperPart.Massless = true
                    ViperPart.CanCollide = false
                    ViperPart.CastShadow = false
                    ViperPart.Material = "SmoothPlastic"
                    ViperPart.Shape = "Ball"
                    ViperPart.Color = Color3.fromRGB(0, 0, 0)
                    ViperPart.Transparency = 1
                    -- Viper Weld
                    ViperHolder.Name = "ViperHolder"
                    ViperHolder.Part0 = ViperPart
                    ViperHolder.Part1 = Player.Character.HumanoidRootPart
                    -- Viper Reach
                    ViperVisualizer.Name = "ViperVisualizer"
                    ViperVisualizer.Adornee = ViperPart
                    ViperVisualizer.Transparency = 1
                    ViperVisualizer.SurfaceTransparency = 0.75
                    -- Loop Configuration
                    RunService.RenderStepped:Connect(function()
                        pcall(function()
                            ViperPart.Size = Vector3.new(getgenv().ViperReach, getgenv().ViperReach, getgenv().ViperReach)
                            ViperVisualizer.Visible = getgenv().ViperVisualizer
                            ViperVisualizer.Color3 = getgenv().ViperColor
                            ViperVisualizer.SurfaceColor3 = getgenv().ViperColor
                        end)
                    end)
                end
            end)
        end)
    end

    function ViperUnequip()
        Player.Character.ChildRemoved:Connect(function(Tool)
            pcall(function()
                if Tool:FindFirstChild("Handle") then
                    for _, Decompile in pairs(Camera:GetChildren()) do
                        if Decompile.Name == "ViperCompiler" then
                            Decompile:Destroy()
                        end
                    end
                end
            end)
        end)
    end

    ViperEquip()
    ViperUnequip()

    Player.CharacterAdded:Connect(ViperEquip)
    Player.CharacterAdded:Connect(ViperUnequip)

    function VWLANDVUNWL()
        Player.Chatted:Connect(function(Message)
            Message = Message:lower()
            if string.sub(Message,1, 3) == "/e " then
            	Message = string.sub(Message, 4)
            end
            if string.sub(Message, 1, 1) == getgenv().ViperPrefix then
            	local cmd
            	local space = string.find(Message," ")
            	if space then
            		cmd = string.sub(Message, 2, space - 1)
            	else
            		cmd = string.sub(Message, 2)
            	end
                if cmd == "ws" or cmd == "walkspeed" then
                    local String = string.sub(Message, space +1)
                    getgenv().ViperWalkSpeed = tonumber(String)
                end
                if cmd == "k" or cmd == "kill" then
                    local String = string.sub(Message, space +1)
                    for _, TargetKill in pairs(Shorten(String)) do
                        if TargetKill.Character.Humanoid.Health > 0 and not table.find(getgenv().ViperWhitelist, TargetKill.UserId) then
                            pcall(function()
                                local Old = Player.Character:WaitForChild("HumanoidRootPart").CFrame
                                local Distance = (Player.Character.HumanoidRootPart.Position - TargetKill.Character.HumanoidRootPart.Position).Magnitude
                                local Speed = Distance/tonumber(math.huge)
                                local Tween = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = TargetKill.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)})
                                Tween:Play()
                                task.wait(getgenv().ViperKillDelay)
                                Player.Character.HumanoidRootPart.CFrame = Old
                            end)
                        end
                    end
                end
                if cmd == "to" or cmd == "goto" then
                    local String = string.sub(Message, space +1)
                    for _, TargetGoto in pairs(Shorten(String)) do
                        if TargetGoto.Character.Humanoid.Health > 0 then
                        local TweenLoop
                        local TouchLoop
                        TweenLoop = RunService.RenderStepped:Connect(function()
                                pcall(function()
                                    local Distance = (Player.Character.HumanoidRootPart.Position - TargetGoto.Character.HumanoidRootPart.Position).Magnitude
                                    local Speed = Distance/tonumber(55)
                                    local Tween = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {CFrame = TargetGoto.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)})
                                    Tween:Play()
                                    TouchLoop = TargetGoto.Character.HumanoidRootPart.Touched:Connect(function()
                                        TweenLoop:Disconnect()
                                        TouchLoop:Disconnect()
                                    end)
                                end)
                            end)
                        end
                    end
                end
                if cmd == "wl" or cmd == "whitelist" then
                    local String = string.sub(Message, space +1)
                    for i,v in pairs(Shorten(String)) do
                        pcall(function()
            		        if v ~= nil and v ~= Player and v ~= i and not table.find(getgenv().ViperWhitelist, v.UserId) then
            		        	table.insert(getgenv().ViperWhitelist, v.UserId)
            		        end
                        end)
                    end
                end
                if cmd == "unwl" or cmd == "unwhitelist" then
                    function UnWhitelist(plr)
                        for num, user in pairs(getgenv().ViperWhitelist) do
                        	if user == plr then
                        		table.remove(getgenv().ViperWhitelist, num)
                        	end
                        end
                    end
                    local String = string.sub(Message, space +1)
                    for i,v in pairs(Shorten(String)) do
                        pcall(function()
                            UnWhitelist(v.UserId)
                        end)
                    end
                end
                if cmd == "cwl" or cmd == "clearwhitelist" then
                    table.clear(getgenv().ViperWhitelist)
                end
                if cmd == "rj" or cmd == "rej" or cmd == "rejoin" then
                    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
                end
                if cmd == "sh" or cmd == "hop" or cmd == "serverhop" then
        	        local ServerTables = {}
        	        for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
        	            if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= JobId then
        	        	    ServerTables[#ServerTables + 1] = v.id
        	            end
        	        end
        	        if #ServerTables > 0 then
                        pcall(function()
        	                TeleportService:TeleportToPlaceInstance(PlaceId, ServerTables[math.random(1, #ServerTables)])
                        end)
        	        else
        	            Notifier({
                            Description = "No Servers Found",
                            Title = "Error",
                            Duration = 5.75
                        })
        	        end
                end
            end
        end)
    end

    for _, EveryPlayer in pairs(Players:GetPlayers()) do
        VWLANDVUNWL(EverPlayer)
    end

    Players.PlayerAdded:Connect(function(AddedPlayer)
        VWLANDVUNWL(AddedPlayer)
    end)

    KillEvent.OnClientEvent:Connect(function(Victim, Suspect)
        if typeof(Victim) == "Instance" and typeof(Suspect) == "Instance" then
            if Victim:IsA("Player") and Suspect:IsA("Player") and Suspect == Player then
                if getgenv().ViperAutoToxic then
                    local Message = Messages[RandomMessage:NextInteger(1, #Messages)]
                    Message = Message:gsub("{p}", Player.Name);
                    Message = Message:gsub("{v}", Victim.Name);
                    ChatEvent:FireServer(Message, "All")
                end
            end
        end
    end)
else
    Notifier({
        Description = "Incorrect Game",
        Title = "Error",
        Duration = 5
    })
end
