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
	if math.abs(svar - GroupMasterVolume) < 0.05 then
		mode = "Group Mode"			
	end
	
	if math.abs(svar - SoloMasterVolume) < 0.05 then
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
	
	if math.abs(svar - GroupMasterVolume) < 0.05 then
		mode = "Group Mode"			
	end
	
	if math.abs(svar - SoloMasterVolume) < 0.05 then
		mode = "Solo Mode"			
	end
	
	-- Left click toggles current mode
	if button == "LeftButton" then
		if mode == "Solo Mode" then
			ShowMessage("Switching to Group Mode")
			SetCVar("Sound_MasterVolume", GroupMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);			
		elseif mode == "Group Mode" then
			ShowMessage("Switching to Solo Mode")
			SetCVar("Sound_MasterVolume", SoloMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);	
		else
			ShowMessage("Switching to Solo Mode")
			SetCVar("Sound_MasterVolume", SoloMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);	
		end
	elseif button == "RightButton" then
		-- Right click should open a configuration window
		ShowMessage("Opening Settings.")
		ShowSettings()
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



-- Locals Section
local TimeSinceLastUpdate = 0

-- Set Slash Commands
SLASH_ARTAVOLUMEMANAGER1 = "/avm"
SLASH_ARTAVOLUMEMANAGER2 = "/artavolumemanager"
function SlashCmdList.ARTAVOLUMEMANAGER(msg, editbox)
	ShowMessage("Opening Settings.")
	ShowSettings()
end

SLASH_ARTAVOLUMEMANAGERTOGGLE1 = "/avmtoggle"
function SlashCmdList.ARTAVOLUMEMANAGERTOGGLE(msg, editbox)
	
	-- Check current Master Volume levels
	local svar = GetCVar("Sound_MasterVolume")		
	svar = tonumber(svar)
	local mode = "Custom"
	if math.abs(svar - GroupMasterVolume) < 0.05 then
		mode = "Group Mode"			
	end
	
	if math.abs(svar - SoloMasterVolume) < 0.05 then
		mode = "Solo Mode"			
	end
	
	if mode == "Solo Mode" then
			ShowMessage("Switching to Group Mode")
			SetCVar("Sound_MasterVolume", GroupMasterVolume)
			GameTooltip:ClearLines();
			fillInfoTooltip(GameTooltip);			
	elseif mode == "Group Mode" then
		ShowMessage("Switching to Solo Mode")
		SetCVar("Sound_MasterVolume", SoloMasterVolume)
		GameTooltip:ClearLines();
		fillInfoTooltip(GameTooltip);	
	else
		ShowMessage("Switching to Solo Mode")
		SetCVar("Sound_MasterVolume", SoloMasterVolume)
		GameTooltip:ClearLines();
		fillInfoTooltip(GameTooltip);	
	end	
	
end

--[[
SLASH_AVMDEBUG1 = "/avmdebug"
function SlashCmdList.AVMDEBUG(msg)
    print("GroupMasterVolume:", GroupMasterVolume, "type:", type(GroupMasterVolume))
    print("SoloMasterVolume:", SoloMasterVolume, "type:", type(SoloMasterVolume))
end]]


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
		ShowMessage("Type /avm or /artavolumemanager for settings.\nType /avmtoggle to toggle between profiles.")		
		
		-- Load the SavedVariables		
		if GroupMasterVolume == nil then
			GroupMasterVolume = 0.2 -- This is the first time this addon is loaded; initialize the volume to 0.2			
		end
		
		if SoloMasterVolume == nil then
			SoloMasterVolume = 1.0 -- This is the first time this addon is loaded; initialize the volume to 1.0			
		end		
		
		-- Since we are already responding to the event, we don't need to keep listening to it and we unregister it
		self:UnregisterEvent("ADDON_LOADED")
	end	
end

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


-- Settings FRAME
local settingsFrame = nil

function ShowSettings()
    if settingsFrame then
        settingsFrame:Show()
        return
    end
    
    -- Create the main settings frame
    settingsFrame = CreateFrame("Frame", "ArtaVolumeManagerSettings", UIParent, "UIPanelDialogTemplate")
    settingsFrame:SetSize(420, 320)
    settingsFrame:SetPoint("CENTER")
    settingsFrame:EnableMouse(true)
    settingsFrame:SetMovable(true)
    settingsFrame:EnableMouse(true)
    settingsFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
    settingsFrame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
    
    -- Title
    local title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -8)
    title:SetText("ArtaVolumeManager Settings")
    
    -- Subtitle (centered)
    local subtitle = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -10)
    subtitle:SetWidth(380)
    subtitle:SetJustifyH("CENTER")
    subtitle:SetText("Audio Volume Configuration")
    
    -- Horizontal line (centered)
    local line = settingsFrame:CreateTexture(nil, "ARTWORK")
    line:SetSize(340, 2)
    line:SetPoint("TOP", subtitle, "BOTTOM", 0, -15)
    line:SetColorTexture(1, 1, 1, 0.5)
    
    -- Solo Mode label (centered)
    local soloLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    soloLabel:SetPoint("TOP", line, "BOTTOM", 0, -15)
    soloLabel:SetWidth(380)
    soloLabel:SetJustifyH("CENTER")
    soloLabel:SetText("Solo Mode Profile")
    
    -- Solo slider (fixed width, centered)
    local soloSlider = CreateFrame("Slider", "AVMSoloSlider", settingsFrame, "OptionsSliderTemplate")
    soloSlider:SetPoint("TOP", soloLabel, "BOTTOM", 0, -15)
    soloSlider:SetWidth(340)
    soloSlider:SetMinMaxValues(0, 1)
    soloSlider:SetValueStep(0.05)
    soloSlider:SetObeyStepOnDrag(true)
    soloSlider:SetValue(SoloMasterVolume or 1.0)
    _G[soloSlider:GetName() .. "Text"]:SetText("Master Volume")
    soloSlider:SetScript("OnValueChanged", function(self)
        _G[self:GetName() .. "Low"]:SetText(string.format("%.2f", self:GetValue()))
        _G[self:GetName() .. "High"]:SetText(string.format("%.2f", self:GetValue()))
    end)
    
    -- Group Mode label (centered)
    local groupLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    groupLabel:SetPoint("TOP", soloSlider, "BOTTOM", 0, -25)
    groupLabel:SetWidth(380)
    groupLabel:SetJustifyH("CENTER")
    groupLabel:SetText("Group Mode Profile")
    
    -- Group slider (fixed width, centered)
    local groupSlider = CreateFrame("Slider", "AVGGroupSlider", settingsFrame, "OptionsSliderTemplate")
    groupSlider:SetPoint("TOP", groupLabel, "BOTTOM", 0, -15)
    groupSlider:SetWidth(340)
    groupSlider:SetMinMaxValues(0, 1)
    groupSlider:SetValueStep(0.05)
    groupSlider:SetObeyStepOnDrag(true)
    groupSlider:SetValue(GroupMasterVolume or 0.2)
    _G[groupSlider:GetName() .. "Text"]:SetText("Master Volume")
    groupSlider:SetScript("OnValueChanged", function(self)
        _G[self:GetName() .. "Low"]:SetText(string.format("%.2f", self:GetValue()))
        _G[self:GetName() .. "High"]:SetText(string.format("%.2f", self:GetValue()))
    end)
    
    -- Save button (single, perfectly centered)
    local saveButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
    saveButton:SetSize(100, 25)
    saveButton:SetPoint("BOTTOM", 0, 20)
    saveButton:SetText("Save")
    saveButton:SetScript("OnClick", function()
        SoloMasterVolume = soloSlider:GetValue()
        GroupMasterVolume = groupSlider:GetValue()        
        ShowMessage("Settings saved.")
        settingsFrame:Hide()
    end) 
    
end

