-- Globals Section
AVM_GroupMasterVolume = 0.2; -- The Master Volume Setting for Group Mode
AVM_SoloMasterVolume = 1.0; -- The Master Volume Setting for Solo Mode


-- Minimap Section
local addon = ...
local icon = LibStub("LibDBIcon-1.0", true);
ArtaVolumeManagerIcon = ArtaVolumeManagerIcon or {};
local mmButtonShown = ArtaVolumeManagerIcon.Visible or true;

local function fillInfoTooltip(tip)
	if tip == nil then print("nil"); return; end;
	tip:ClearLines();	
	
	-- Check current Master Volume levels
	local svar = GetCVar("Sound_MasterVolume")		
	svar = tonumber(svar)
	local mode = "Custom"
	if svar == AVM_GroupMasterVolume then
		mode = "Group Mode"			
	end
	
	if svar == AVM_SoloMasterVolume then
		mode = "Solo Mode"			
	end
	
	
	tip:AddLine("ArtaVolumeManager: |cFF00FF00"..mode);
	tip:AddLine("\nLeft Click: Toggle profile");
	tip:AddLine("Right Click: Open Settings")
	tip:Show();
end;

local function minimapButtonShowHide(toggle)
	if not icon then return; end;
	--if toggle is true just flip visibility.
	if toggle then mmButtonShown = not mmButtonShown; end;
	--if toggle is false adjust visibility to saved status
	if toggle == false then
		if ArtaVolumeManagerIcon.Visible == nil then ArtaVolumeManagerIcon.Visible = true; end;
		mmButtonShown = ArtaVolumeManagerIcon.Visible;
	end;
	if mmButtonShown then
		icon:Show(addon);
	else
		icon:Hide(addon);
		if toggle then print("Minimap button is now hidden.\n"); end;
	end;
	ArtaVolumeManagerIcon.Visible = mmButtonShown;
end;

local function ArtaVolumeManagerMiniMap(button)
	if not icon then return; end;
	
	-- Check current Master Volume levels
	local svar = GetCVar("Sound_MasterVolume")		
	svar = tonumber(svar)
	local mode = "Custom"
	if svar == AVM_GroupMasterVolume then
		mode = "Group Mode"			
	end
	
	if svar == AVM_SoloMasterVolume then
		mode = "Solo Mode"			
	end
	
	-- Left click toggles current mode
	if button == "LeftButton" then
		if mode == "Solo Mode" then
			ShowMessage("Switching to Group Mode")
			SetCVar("Sound_MasterVolume", AVM_GroupMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);			
		elseif mode == "Group Mode" then
			ShowMessage("Switching to Solo Mode")
			SetCVar("Sound_MasterVolume", AVM_SoloMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);	
		else
			ShowMessage("Switching to Solo Mode")
			SetCVar("Sound_MasterVolume", AVM_SoloMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);	
		end
	elseif button == "RightButton" then
		-- Right click should open a configuration window, but it's NYI
		ShowMessage("Opening Settings [NYI]")
	end;
end;

local iconFile = "Interface\\Icons\\inv_misc_gem_pearl_04"


local ldb = LibStub("LibDataBroker-1.1", true)

local avmLDB = ldb and ldb:NewDataObject("ArtaVolumeManager", {
    type = "data source",
    text = "ArtaVolumeManager",
    icon = iconFile,
    OnClick = function(_, button) ArtaVolumeManagerMiniMap(button) end,
})

if avmLDB then
    function avmLDB:OnEnter()
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
        fillInfoTooltip(GameTooltip)
    end

    function avmLDB:OnLeave()
        GameTooltip:Hide()
    end
end


AddonCompartmentFrame:RegisterAddon({
	text = "ArtaVolumeManager",
	icon = "Interface\\Icons\\inv_misc_gem_pearl_04",
	notCheckable = true,
	registerForAnyClick = true,
	func = function(self, arg1, arg2, checked, mouseButton)
		mouseButton = arg1.buttonName
		if mouseButton == "LeftButton" then
			ShowMessage("Left button clicked")			
		elseif mouseButton == "RightButton" then		
			ShowMessage("Right button clicked")
		end;	
	end,
	funcOnEnter = function(self)		
		GameTooltip:SetOwner(self, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
		GameTooltip:ClearLines();
		fillInfoTooltip(GameTooltip);
	end,
	funcOnLeave = function()
		GameTooltip:Hide();
	end,
})


--event frame
local f = CreateFrame("FRAME");
f:RegisterEvent("SPELLS_CHANGED");

function f:OnEvent(event, arg1)
	if event == "SPELLS_CHANGED" then
		--Minimap button
		ArtaVolumeManagerIcon = ArtaVolumeManagerIcon or {};
		
		if avmLDB then
		
		if icon then icon:Register(addon, avmLDB, ArtaVolumeManagerIcon); end;
		
		end;
		minimapButtonShowHide(false);		
		f:UnregisterEvent("SPELLS_CHANGED");		
	end;
end;
f:SetScript("OnEvent", f.OnEvent); 




-- Locals Section
local TimeSinceLastUpdate = 0

-- Set Slash Commands
SLASH_ARTAVOLUMEMANAGER1 = "/avm"
SLASH_ARTAVOLUMEMANAGER2 = "/artavolumemanager"
function SlashCmdList.ARTAVOLUMEMANAGER(msg, editbox)
	print("Settings screen invoked [NYI]")
end

SLASH_ARTAVOLUMEMANAGERTOGGLE1 = "/avmtoggle"
function SlashCmdList.ARTAVOLUMEMANAGERTOGGLE(msg, editbox)
	
	-- Check current Master Volume levels
	local svar = GetCVar("Sound_MasterVolume")		
	svar = tonumber(svar)
	local mode = "Custom"
	if svar == AVM_GroupMasterVolume then
		mode = "Group Mode"			
	end
	
	if svar == AVM_SoloMasterVolume then
		mode = "Solo Mode"			
	end
	
	if mode == "Solo Mode" then
			ShowMessage("Switching to Group Mode")
			SetCVar("Sound_MasterVolume", AVM_GroupMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);			
	elseif mode == "Group Mode" then
		ShowMessage("Switching to Solo Mode")
		SetCVar("Sound_MasterVolume", AVM_SoloMasterVolume)
		GameTooltip:ClearLines();
		fillInfoTooltip(GameTooltip);	
	else
		ShowMessage("Switching to Solo Mode")
		SetCVar("Sound_MasterVolume", AVM_SoloMasterVolume)
		GameTooltip:ClearLines();
		fillInfoTooltip(GameTooltip);	
	end	
	
end

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
