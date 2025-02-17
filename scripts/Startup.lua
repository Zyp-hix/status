local StarterGui = game:GetService("StarterGui")

-- Save the original SetCore function
local old_SetCore = StarterGui.SetCore

-- Override SetCore to block "Xeno" messages and show custom notification
StarterGui.SetCore = function(self, coreType, data)
    if coreType == "SendNotification" and type(data) == "table" then
        local title = data.Title or ""
        local text = data.Text or ""

        -- Block notifications that contain "Xeno"
        if title:find("Xeno") or text:find("Xeno") then
            -- Instead of blocking, override with custom message
            data.Title = "Injected"
            data.Text = "Bear is injected"
        end
    end

    -- Call original SetCore function
    return old_SetCore(self, coreType, data)
end

-- Display custom notification immediately
StarterGui:SetCore("SendNotification", {
    Title = "Injected",
    Text = "Bear is injected",
})
