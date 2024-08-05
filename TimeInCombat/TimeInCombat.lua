print("TimeInCombat loaded")

-- Create a frame to listen for events
local frame = CreateFrame("FRAME", "HealthTimerFrame", nil, "BackdropTemplate")

local backdropInfo =
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
 	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 8,
 	edgeSize = 8,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}
frame:SetBackdrop(backdropInfo)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_DISABLED") -- This event triggers when the player enters combat
frame:RegisterEvent("PLAYER_REGEN_ENABLED") -- This event triggers when the player leaves combat

-- Variables to track time
local startTime = nil

-- Function to handle the dragging of the frame
local function onDragStart(self)
    self:StartMoving()
end

local function onDragStop(self)
    self:StopMovingOrSizing()
end

-- Event handler function
local function eventHandler(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Reset variables when entering the world
        startTime = nil
        HealthTimerText:SetText("0.00 seconds")
    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Player has entered combat
        startTime = GetTime()
        --print("Entered combat at: " .. startTime)
        print("Entered combat")
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Player has left combat
        if startTime then
            local endTime = GetTime()
            local duration = endTime - startTime
            
            -- Display the time spent in combat
            --print("Time spent in combat: " .. duration .. " seconds")
            print(string.format("Left combat. Time in combat: %.2f seconds", duration))
            HealthTimerText:SetText(string.format("%.2f seconds", duration))

            -- Reset variables
            startTime = nil
        end
    end
end

-- Set the script for the frame
frame:SetScript("OnEvent", eventHandler)

-- Enable dragging for the frame
HealthTimerFrame:SetMovable(true)
HealthTimerFrame:EnableMouse(true)
HealthTimerFrame:RegisterForDrag("LeftButton")
HealthTimerFrame:SetScript("OnDragStart", onDragStart)
HealthTimerFrame:SetScript("OnDragStop", onDragStop)