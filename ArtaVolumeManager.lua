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
