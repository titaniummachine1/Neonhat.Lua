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
local mHeight     = menu:AddComponent(MenuLib.Slider("height", -50 ,50 , 0 ))
local mmmheight   = menu:AddComponent(MenuLib.Slider("height", 0 ,50 , 25 ))
local mradious    = menu:AddComponent(MenuLib.Slider("radious", 1 ,85 , 15 ))
local mresolution = menu:AddComponent(MenuLib.Slider("resolution", 1 ,360 , 32 ))
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

    draw.SetFont( myfont )
    draw.Color( 255, 255, 255, 255 )
    local w, h = draw.GetScreenSize()
    local screenPos = { w / 2 - 15, h / 2 + 35}

    --text

    -- hat
    -- hat
-- define the vertices of the hat
-- set circle resolution
-- hat
-- ustawienie rozdzielczości koła
-- hat
-- ustawienie rozdzielczości koła
-- hat
-- ustawienie rozdzielczości koła


-- Calculate the vertex positions around the circle
-- Define circle parameters
local center = pLocalOrigin
local radius = mradious:GetValue() -- radius of the circle
local segments = mresolution:GetValue() -- number of segments to use for the circle
local height = mHeight:GetValue() -- height of the circle
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









--[[ ustawienie rozdzielczości koła
local resolution = 36
-- promień koła
local radius = 50
-- wektor środka koła
local center = pLocalOrigin
-- wektor wysokości ostrosłupa
local height = Vector3(0, 0, 20)
-- inicjalizacja tablicy wierzchołków koła
local vertices = {}
-- wyznaczanie pozycji wierzchołków koła
for i = 1, resolution do
    local angle = (2 * math.pi / resolution) * (i - 1)
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)
    vertices[i] = Vector3(center.x + x, center.y + y)
end
-- rysowanie linii łączących kolejne wierzchołki koła oraz linii z punktów koła do wierzchołka stożka na wysokości 'height'
    for i = 1, resolution do
        local v1 = vertices[i]
        local v2 = vertices[(i % resolution) + 1]
        draw.Line(v1.x, v1.y, v1.z, height.x, height.y, height.z)
        draw.Line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z)
        draw.Line(v2.x, v2.y, v2.z, height.x, height.y, height.z)
    end
    
-- rysowanie linii łączącej ostatni wierzchołek z pierwszym
draw.Line(vertices[resolution], vertices[1])
]]
end


--[[ Unregister previous callbacks ]]--

callbacks.Unregister("Draw", "MCT_Draw")                        -- Unregister the "Draw" callback
--[[ Register callbacks ]]--
callbacks.Register("Draw", "MCT_Draw", doDraw)                               -- Register the "Draw" callback
--[[ Play sound when loaded ]]--
client.Command('play "ui/buttonclick"', true) -- Play the "buttonclick" sound when the script is loaded