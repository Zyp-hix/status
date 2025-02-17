local StarterGui = game:GetService("StarterGui")

-- Overwrite SetCore completely
local old_SetCore = StarterGui.SetCore

StarterGui.SetCore = function(self, coreType, data)
    if coreType == "SendNotification" and type(data) == "table" then
        local title = data.Title or ""
        local text = data.Text or ""

        -- **BLOCK ALL XENO NOTIFICATIONS COMPLETELY**
        if string.find(title, "Xeno") or string.find(text, "Xeno") then
            return -- Do NOTHING, so it NEVER shows
        end
    end

    -- Call the original SetCore function
    return old_SetCore(self, coreType, data)
end

-- **FORCE INJECT YOUR NOTIFICATION IMMEDIATELY**
task.spawn(function()
    task.wait(1) -- Small delay to override Xeno's message
    StarterGui:SetCore("SendNotification", {
        Title = "Injected",
        Text = "Bear is injected",
        Duration = 5
    })
end)
