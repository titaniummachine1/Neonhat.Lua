--[[ Swing prediction for  Lmaobox  ]]--
--[[      (Modded misc-tools)       ]]--
--[[          --Authors--           ]]--
--[[           Terminator           ]]--
--[[  (github.com/titaniummachine1  ]]--
    
local menuLoaded, MenuLib = pcall(require, "Menu")                                -- Load MenuLib
assert(menuLoaded, "MenuLib not found, please install it!")                       -- If not found, throw error
assert(MenuLib.Version >= 1.44, "MenuLib version is too old, please update it!")  -- If version is too old, throw error
--[[ Menu ]]--
local menu = MenuLib.Create("Neon Hat", MenuFlags.AutoSize)
menu.Style.TitleBg = { 205, 95, 50, 255 } -- Title Background Color (Flame Pea)
menu.Style.Outline = true                 -- Outline around the menu

--[[menu:AddComponent(MenuLib.Button("Debug", function() -- Disable Weapon Sway (Executes commands)
    client.SetConVar("cl_vWeapon_sway_interp",              0)             -- Set cl_vWeapon_sway_interp to 0
    client.SetConVar("cl_jiggle_bone_framerate_cutoff", 0)             -- Set cl_jiggle_bone_framerate_cutoff to 0
    client.SetConVar("cl_bobcycle",                     10000)         -- Set cl_bobcycle to 10000
    client.SetConVar("sv_cheats", 1)                                    -- debug fast setup
    client.SetConVar("mp_disable_respawn_times", 1)
    client.SetConVar("mp_respawnwavetime", -1)
end, ItemFlags.FullWidth))]]
local mEnable     = menu:AddComponent(MenuLib.Checkbox("Enable", true))
local mmmheight   = menu:AddComponent(MenuLib.Slider("height", 0 ,50 , 11 ))
local mradious    = menu:AddComponent(MenuLib.Slider("radious", 1 ,85 , 17 ))
local mresolution = menu:AddComponent(MenuLib.Slider("resolution", 1 ,1200 , 720 ))
local color       = menu:AddComponent(MenuLib.Colorpicker("Hat Color", color))


-- debug command: ent_fire !picker Addoutput "health 99"
local myfont = draw.CreateFont( "Verdana", 16, 800 ) -- Create a font for doDraw


--[[ Code called every frame ]]--
local function doDraw()
    if mEnable:GetValue() == false then return end
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
    
local hitbox_min = Vector3(14, 14, 0)
local hitbox_max = Vector3(-14, -14, 85)
local vPlayerOrigin = nil

-- Get local player data
local pLocal = entities.GetLocalPlayer()     -- Immediately set "pLocal" to the local player (entities.GetLocalPlayer)
local pWeapon = pLocal:GetPropEntity("m_hActiveWeapon")
local swingrange = pWeapon:GetSwingRange() -- + 11.17
local tickRate = 66 -- game tick rate
--get pLocal eye level and set vector at our eye level to ensure we check distance from eyes
local viewOffset = pLocal:GetPropVector("localdata", "m_vecViewOffset[0]")
local adjustedHeight = pLocal:GetAbsOrigin() + viewOffset
local viewheight = (adjustedHeight - pLocal:GetAbsOrigin()):Length()
-- eye level 
local Vheight = Vector3(0, 0, viewheight)
local pLocalOrigin = (pLocal:GetAbsOrigin() + Vheight)
--get local class
local pLocalClass = pLocal:GetPropInt("m_iClass")
local vhitbox_Height = 85
local vhitbox_width = 18
    if pLocal == nil then return end
    --text

    -- hat

local player = entities.GetLocalPlayer()
local hitboxes = player:GetHitboxes()

local hitboxIndex = 1 -- Set the index of the hitbox to draw
local hitbox = hitboxes[hitboxIndex]
local w, h = draw.GetScreenSize()
local screenPos = { w / 2 - 15, h / 2 + 35}
draw.SetFont( myfont )

local selected_color = color:GetColor()
-- set the color using the selected color values
draw.Color(selected_color[1], selected_color[2], selected_color[3], selected_color[4])
-- Calculate the vertex positions around the circle
-- Define circle parameters
local center = (hitbox[1] + hitbox[2]) * 0.5
local radius = mradious:GetValue() -- radius of the circle
local segments = mresolution:GetValue() -- number of segments to use for the circle
local height = 0
local hat_height = height + mmmheight:GetValue() -- height of the top point

-- Calculate vertices for the circle and top point
local vertices = {}
for i = 1, segments do
  local angle = math.rad(i * (360 / segments))
  local x = center.x + math.cos(angle) * radius
  local y = center.y + math.sin(angle) * radius
  vertices[i] = client.WorldToScreen(Vector3(x, y, center.z + height))
end
local top_vertex = client.WorldToScreen(Vector3(center.x, center.y, center.z + hat_height))

-- Draw the circle and connect all the vertices to the top point
for i = 1, segments do
  local j = i + 1
  if j > segments then j = 1 end
  if vertices[i] ~= nil and vertices[j] ~= nil then
    draw.Line(vertices[i][1], vertices[i][2], vertices[j][1], vertices[j][2])
    draw.Line(vertices[i][1], vertices[i][2], top_vertex[1], top_vertex[2])
  end
end
end

--[[ Remove the menu when unloaded ]]--
local function OnUnload()                                -- Called when the script is unloaded
    MenuLib.RemoveMenu(menu)                             -- Remove the menu
    client.Command('play "ui/buttonclickrelease"', true) -- Play the "buttonclickrelease" sound
end

--[[ Unregister previous callbacks ]]--
callbacks.Unregister("Unload", "MCT_Unload")                    -- Unregister the "Unload" callback
callbacks.Unregister("Draw", "MCT_Draw")                        -- Unregister the "Draw" callback
--[[ Register callbacks ]]--
callbacks.Register("Unload", "MCT_Unload", OnUnload)                         -- Register the "Unload" callback
callbacks.Register("Draw", "MCT_Draw", doDraw)                               -- Register the "Draw" callback
--[[ Play sound when loaded ]]--
client.Command('play "ui/buttonclick"', true) -- Play the "buttonclick" sound when the script is loaded