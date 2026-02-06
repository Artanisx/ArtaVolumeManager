-- Globals Section
AVM_GroupMasterVolume = 0.2; -- The Master Volume Setting for Group Mode
AVM_SoloMasterVolume = 1.0; -- The Master Volume Setting for Solo Mode

-- Locals Section
local TimeSinceLastUpdate = 0

-- Functions Section

-- Function to show formatted and colored addon messages
function ShowMessage(msg)
	print ("|c398fdf99ArtaVolumeManager: |cffffffff" ..msg)
end

-- Function called when the OnLoad event is fired
function AVM_OnLoad(self, event,...) 
    self:RegisterEvent("ADDON_LOADED")	
end


-- Function called when the an event is fired
function AVM_OnEvent(self, event, ...)	
	if event == "ADDON_LOADED" and ... == "ArtaVolumeManager" then
		ShowMessage("Loaded")
		-- Since we are already responding to the event, we don't need to keep listening to it and we unregister it
		self:UnregisterEvent("AddOn_LOADED")
	end	
end
