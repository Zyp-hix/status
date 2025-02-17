local alreadyDisplayed = false

-- Function to handle notifications
local function displayNotification(title, text)
    -- Check if the notification contains "Xeno" in the title or text
    if title:find("Xeno") or text:find("Xeno") then
        return -- Do nothing if it contains "Xeno"
    end
    
    -- Only show the notification if one hasn't already been displayed
    if not alreadyDisplayed then
        alreadyDisplayed = true
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
        })
        
        -- Wait for 5 seconds before allowing another notification to appear
        wait(5)
        alreadyDisplayed = false
    end
end

-- Example notification
displayNotification("Injected", "Bear has been injected!")
