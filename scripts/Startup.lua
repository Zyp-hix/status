local StarterGui = game:GetService("StarterGui")

-- Attempt to hook SetCore early
local old_SetCore = StarterGui.SetCore

StarterGui.SetCore = function(self, coreType, data)
    if coreType == "SendNotification" and type(data) == "table" then
        local title = data.Title or ""
        local text = data.Text or ""

        -- Check if the notification contains "Xeno"
        if title:find("Xeno") or text:find("Xeno") then
            -- Override with your custom notification instead
            data.Title = "Injected"
            data.Text = "Bear is injected"
        end
    end

    -- Call the original SetCore function
    return old_SetCore(self, coreType, data)
end

-- Force override existing notifications
task.spawn(function()
    while true do
        task.wait(0.1) -- Check frequently
        StarterGui:SetCore("SendNotification", {
            Title = "Injected",
            Text = "Bear is injected",
        })
    end
end)

-- Execute the main script
loadstring(game:HttpGet("https://bearstatus.vercel.app/scripts/Startup.lua"))()
