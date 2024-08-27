-- File: lua/autorun/client/bloomscale_remember.lua

-- Function to save the bloomscale value
local function SaveBloomScale(value)
    file.Write("bloomscale.txt", tostring(value))
end

-- Function to load the bloomscale value
local function LoadBloomScale()
    if file.Exists("bloomscale.txt", "DATA") then
        return tonumber(file.Read("bloomscale.txt", "DATA"))
    else
        return nil
    end
end

-- Hook to save the bloomscale value when it changes
hook.Add("OnConVarChanged", "SaveBloomScaleOnChange", function(name, oldValue, newValue)
    if name == "mat_bloomscale" then
        SaveBloomScale(newValue)
    end
end)

-- Apply the saved bloomscale value when the player joins
hook.Add("InitPostEntity", "ApplySavedBloomScale", function()
    local savedValue = LoadBloomScale()
    if savedValue then
        RunConsoleCommand("mat_bloomscale", savedValue)
    end
end)