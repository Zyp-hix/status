local StarterGui = game:GetService("StarterGui")

-- Save original SetCore function
local old_SetCore = StarterGui.SetCore

-- Override SetCore to block "Xeno" messages
StarterGui.SetCore = function(self, coreType, data)
    if coreType == "SendNotification" and type(data) == "table" then
        local title = data.Title or ""
        local text = data.Text or ""

        -- Block notifications that contain "Xeno"
        if title:find("Xeno") or text:find("Xeno") then
            return
        end
    end

    -- Call original SetCore function
    return old_SetCore(self, coreType, data)
end
