-- Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ========== Variabel ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidroot = character:WaitForChild("HumanoidRootPart")
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidroot = newChar:WaitForChild("HumanoidRootPart")
end)
local function GetDriveSeat()
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        return humanoid.SeatPart
    end
    return nil
end

-- ========== Window ==========
local Window = WindUI:CreateWindow({
    Title = "The Ride",
    Icon = "rbxassetid://133739520556173", 
    Author = "NusantaBlox",
    Folder = "Nusantablox",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
    },
})


Window:EditOpenButton({
    Title = "Menu",
    Icon = "minimize-2",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( 
        Color3.fromHex("FFFFFF"), 
        Color3.fromHex("000000")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local version = "2.2" 
local fps = 0
local ping = 0

local StatsTag = Window:Tag({
    Title = "Loading...",
    Color = Color3.fromHex("#30FF6A"),
    Radius = 13, 
})

local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local now = os.clock()
    
    if now - last >= 1 then
        fps = frames
        frames = 0
        last = now
        
        
        local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
        if item then
            ping = math.floor(item:GetValue())
        end
        
        
        StatsTag:SetTitle(string.format("v%s | Ping: %d | FPS: %d", version, ping, fps))
    end
end)

Window:Tag({
    Title = "Release",
    Color = Color3.fromHex("#30FF6A"),
    Radius = 13, 
})

WindUI:Notify({
    Title = "Connection Info!",
    Content = "Script Succesfuly Loaded!",
    Duration = 3.8, 
    Icon = "cloud-check",
})

-- AntiAFK
local VirtualUser = game:GetService("VirtualUser")
local AntiAFK_Enabled = true

player.Idled:Connect(function()
    if AntiAFK_Enabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    else
    end
end)

-- ========== Tabs ==========
local AboutTab = Window:Tab({
    Title = "About",
    Icon = "info", 
    Locked = false,
})
Window:Divider()
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "crown", 
    Locked = false,
})
local BikeTab = Window:Tab({
    Title = "Bike",
    Icon = "motorbike", 
    Locked = false,
})
-- Auto Select
AboutTab:Select()

-- ========== About Tab ==========
local InviteCode = "6AKuWmAgw7"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
    Url = DiscordAPI,
    Method = "GET",
    Headers = {
        ["User-Agent"] = "RobloxBot/1.0",
        ["Accept"] = "application/json"
    }
}).Body)

if Response and Response.guild then
    local DiscordInfo = AboutTab:Paragraph({
        Title = "NusantaBlox | Indonesia Hub",
        Desc = 
            ' <font color="#52525b">•</font> Member Count : ' .. tostring(Response.approximate_member_count) .. 
            '\n <font color="#16a34a">•</font> Online Count : ' .. tostring(Response.approximate_presence_count)
        ,
        Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
        ImageSize = 42,
    })

    AboutTab:Button({
        Title = "Update Info",
        --Image = "refresh-ccw",
        Callback = function()
            local UpdatedResponse = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
                Url = DiscordAPI,
                Method = "GET",
            }).Body)
            
            if UpdatedResponse and UpdatedResponse and UpdatedResponse.guild then
                DiscordInfo:SetDesc(
                    ' <font color="#52525b">•</font> Member Count : ' .. tostring(UpdatedResponse.approximate_member_count) .. 
                    '\n <font color="#16a34a">•</font> Online Count : ' .. tostring(UpdatedResponse.approximate_presence_count)
                )
            end
        end
    })
else
    AboutTab:Paragraph({
        Title = "Error when receiving information about the Discord server",
        Desc = game:GetService("HttpService"):JSONEncode(Response),
        Image = "triangle-alert",
        ImageSize = 26,
        Color = "Red",
    })
end
AboutTab:Divider()
AboutTab:Paragraph({
    Title = "Offcial Website",
    Desc = "Copy and paste to browser, you cant get Key in website.",
    Image = "https://i.ibb.co.com/XrCRJ16f/Nusantablox.jpg",
    ImageSize = 30,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function() 
                setclipboard("https://jnkie.com/overview/nusantablox-hub")
            end,
        }
    }
})
AboutTab:Paragraph({
    Title = "Discord",
    Desc = "Join discord for more script and more Info",
    Image = "https://i.pinimg.com/736x/b5/d4/ce/b5d4ce10a744861ffd3314d20d116976.jpg",
    ImageSize = 30,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/6AKuWmAgw7")
            end,
        }
    }
})

-- ========== Main Tab ==========
MainTab:Section({ 
    Title = "AutoFarm",
})

-- AutoFarm
local AutoFarmStatus = false
local AutoFarmPlace = "Loop Race"

local AutoFarmPlaceSelect = MainTab:Dropdown({
    Title = "Select Race",
    Values = { "Loop Race", "Street Race",},
    Value = "Loop Race",
    Callback = function(option) 
        AutoFarmPlace = option
    end
})

local AutoFarmStatusInfo = MainTab:Toggle({
    Title = "AutoFarm",
    Value = false,
    Callback = function(state) 
        AutoFarmStatus = state
    end
})

local MapCheckpoints = {
    ["Loop Race"] = {
        DelayPerCheckpoint = 5.6,
        Points = {
            CFrame.new(-10492.0273, -18.2218819, 2366.24316),
            CFrame.new(-10354.165, -18.2058296, 2470.74634),
            CFrame.new(-10349.584, -18.2273083, 3891.85059),
            CFrame.new(-12324.3223, -17.9381466, 4022.28931),
            CFrame.new(-13379.9736, -18.165947, 3232.9082),
            CFrame.new(-12934.2783, -18.165144, 2296.42969),
            CFrame.new(-12355.708, -18.1686764, 1458.0094),
            CFrame.new(-12001.9102, -18.1633301, 763.873474),
            CFrame.new(-11117.7227, -18.1748409, 1171.28674),
            CFrame.new(-10799.5469, -18.218626, 2182.94995), 
        }
    },
    ["Street Race"] = {
        DelayPerCheckpoint = 5.6,
        Points = {
            CFrame.new(-9639.3887, -18.2280, 3373.9382),
            CFrame.new(-9590.3076, -18.2202, 3112.3269),
            CFrame.new(-10349.5186, -18.1900, 3020.2122),
            CFrame.new(-10331.3096, -18.2223, 2510.6306),
            CFrame.new(-9762.4893, -18.2062, 2483.5737),
            CFrame.new(-9783.8828, -18.2505, 2262.1150),
            CFrame.new(-9947.1221, 29.5493, 1654.3998),
            CFrame.new(-9941.9785, 29.5522, 2129.3860),
            CFrame.new(-10009.6904, 29.5561, 3505.7451),
            CFrame.new(-9707.7773, -16.1217, 3690.3777),
        }
    }
}

local function TeleportVehicle(targetCFrame)
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        local vehicle = humanoid.SeatPart.Parent
        
        if vehicle.PrimaryPart then
            vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
        
        vehicle:PivotTo(targetCFrame)
        return true
    else
        return false
    end
end

task.spawn(function()
    while true do
        if AutoFarmStatus then
            if not humanoid.Sit then
                WindUI:Notify({
                    Title = "AutoFarm",
                    Content = "Player Must Sit On The Bike",
                    Duration = 3,
                    Icon = "triangle-alert",
                })
                AutoFarmStatusInfo:Set(false)
                AutoFarmStatus = false
            end
            local mapData = MapCheckpoints[AutoFarmPlace]           
            if mapData then               
                local points = mapData.Points
                local customDelay = mapData.DelayPerCheckpoint
                local started = TeleportVehicle(points[1])               
                if started then
                    WindUI:Notify({
                        Title = "AutoFarm",
                        Content = "Waiting The Race Start",
                        Duration = 35,
                        Icon = "loader-circle",
                    })     
                    task.wait(35)                   
                    for i = 2, #points do
                        if not AutoFarmStatus then break end                       
                        local success = TeleportVehicle(points[i])                        
                        if not success then break end
                        task.wait(0.5)
                        if i < #points then
                            WindUI:Notify({
                                Title = "AutoFarm",
                                Content = "Delay Teleport",
                                Duration = customDelay,
                                Icon = "loader-circle",
                                })     
                            task.wait(customDelay) 
                        end
                    end                                     
                else                   
                    task.wait(2)
                end
            else
                task.wait(1)
            end
        else
            task.wait(1) 
        end
    end
end)

-- ========== Bike Tab ==========
-- Section
BikeTab:Section({
    Title = "Speed Boost",
})

-- Speed Boost
local SpeedBoostMaxSpeed = 100
local SpeedBoostAcceleration = 10
local SpeedBoostCurrentSpeed = 0
local SpeedBoostStatus = false

local SpeedBoostMaxSpeedSlider = BikeTab:Slider({
    Title = "Max Speed",
    Desc = "How fast your bike can go",
    Value = {Min = 1, Max = 600, Default = 100,},
    Callback = function(value)
        SpeedBoostMaxSpeed = value
    end
})

local SpeedBoostAccelerationSlider = BikeTab:Slider({
    Title = "Acceleration",
    Desc = "Time to reach max speed",
    Value = {Min = 1, Max = 30, Default = 10,},
    Callback = function(value)
        SpeedBoostAcceleration = value
    end
})

local SpeedBoostStatusInfo = BikeTab:Toggle({
    Title = "Speed Boost",
    Value = false,
    Callback = function(state)
        SpeedBoostStatus = state
    end
})

RunService.Stepped:Connect(function(dt)
    local seat = GetDriveSeat()
    local isSitting = humanoid and humanoid.Sit

    local isGasPressed = seat and seat.Throttle == 1

    if not SpeedBoostStatus or not isSitting then
        SpeedBoostCurrentSpeed = 0
        return
    end

    local actualVelocity = humanoidroot.AssemblyLinearVelocity.Magnitude

    if isGasPressed then
        if SpeedBoostCurrentSpeed < actualVelocity then
            SpeedBoostCurrentSpeed = actualVelocity
        end

    local divider = SpeedBoostAcceleration * 100
    local accelStep = SpeedBoostMaxSpeed / divider

    if SpeedBoostCurrentSpeed < SpeedBoostMaxSpeed then
        SpeedBoostCurrentSpeed = SpeedBoostCurrentSpeed + accelStep
    else
        SpeedBoostCurrentSpeed = SpeedBoostMaxSpeed
    end

    local look = humanoidroot.CFrame.LookVector
    local dir = Vector3.new(look.X, 0, look.Z).Unit
        humanoidroot.AssemblyLinearVelocity = Vector3.new(
            dir.X * SpeedBoostCurrentSpeed,
            humanoidroot.AssemblyLinearVelocity.Y,
            dir.Z * SpeedBoostCurrentSpeed
        )
    else 
        SpeedBoostCurrentSpeed = actualVelocity
    end
end)

-- Section
BikeTab:Section({
    Title = "Brake Boost",
})

-- Brake Boost
local BrakeBoost = 10
local BrakeBoostStatus = false

local BrakeBoostSlider = BikeTab:Slider({
    Title = "Brake Boost Power",
    Value = {Min = 1, Max = 100, Default = 10,},
    Callback = function(value)
        BrakeBoost = value
    end
})

local BrakeBoostStatusInfo = BikeTab:Toggle({
    Title = "Brake Boost",
    Value = false,
    Callback = function(state)
        BrakeBoostStatus = state
    end
})

RunService.Stepped:Connect(function(dt)
    local seat = GetDriveSeat()
    local isBrakePressed = seat and seat.Throttle == -1

    if BrakeBoostStatus and isBrakePressed then
        local velocity = humanoidroot.AssemblyLinearVelocity
        local speed = velocity.Magnitude

        if speed > 0.1 then
            local reduction = BrakeBoost * dt * 0.001
            local newSpeed = math.max(0, speed - reduction)

            local direction = velocity.Unit

            humanoidroot.AssemblyLinearVelocity = Vector3.new(
                direction.X * newSpeed,
                velocity.Y,
                direction.Z * newSpeed
            )
        end
    end
end)
