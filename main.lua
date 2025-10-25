local api = require("api")

local unsafe_portals_Addon = {
	name = "Unsafe Portals",
	author = "Michaelqt",
	version = "1.0",
	desc = "Adds a button to disable safe portal option briefly."
}

local unsafePortalsWindow
local systemConfigFrame

local clockTimer = 0
local clockResetTime = 10000

local buffIdCounter = 1
local buffInfos = {}

local isUnsafePortalsEnabled

local function toggleUnsafePortalsOption()
	systemConfigFrame.optionButton:OnClick("LeftButton")
	local optionFrame = ADDON:GetContent(UIC.OPTION_FRAME)
	optionFrame.contentWindow.menuListFrame.categoryFrames[3].buttons[3]:OnClick("LeftButton")
	
	optionFrame.contentWindow.pageWindow.subFrame[6].content.optionFrames[14].optionControl.textButton:OnClick("LeftButton")
	optionFrame:Save()
	optionFrame:Show(false)
end 

local function OnUpdate(dt)
	if isUnsafePortalsEnabled == false then 
		if clockTimer + dt > clockResetTime then
			toggleUnsafePortalsOption()
			isUnsafePortalsEnabled = true
			clockTimer = 0
			api.Log:Info("[Unsafe Portals] Other player portals are now disabled.")
		end 
		-- api.Log:Info(clockTimer)
		clockTimer = clockTimer + dt
	end 
end 

local function OnLoad()
	local settings = api.GetSettings("unsafe_portals")
	systemConfigFrame = ADDON:GetContent(UIC.SYSTEM_CONFIG_FRAME)


	-- Get player's current unsafe portal setting
	systemConfigFrame.optionButton:OnClick("LeftButton")
	local optionFrame = ADDON:GetContent(UIC.OPTION_FRAME)
	optionFrame.contentWindow.menuListFrame.categoryFrames[3].buttons[3]:OnClick("LeftButton")
	local ogValue = optionFrame.contentWindow.pageWindow.subFrame[6].content.optionFrames[14].optionControl.originalValue
	optionFrame:Show(false)

	if ogValue == 0 then 
		toggleUnsafePortalsOption()
	end
	isUnsafePortalsEnabled = true

	unsafePortalsWindow = api.Interface:CreateEmptyWindow("unsafePortalsWindow", "UIParent")
	disableSafePortalsBtn = unsafePortalsWindow:CreateChildWidget("button", "disableSafePortalsBtn", 0, true)
    ApplyButtonSkin(disableSafePortalsBtn, BUTTON_BASIC.DEFAULT)
	disableSafePortalsBtn:SetText("Unsafe Portals")
	disableSafePortalsBtn:SetExtent(120, 28)
	disableSafePortalsBtn:AddAnchor("BOTTOMLEFT", "UIParent", 3, -30)
	function disableSafePortalsBtn:OnClick()
        toggleUnsafePortalsOption()
		isUnsafePortalsEnabled = false
		api.Log:Info("[Unsafe Portals] You can use other player's portals for 10 seconds.")
    end 
    disableSafePortalsBtn:SetHandler("OnClick", disableSafePortalsBtn.OnClick)

	
	
	unsafePortalsWindow:Show(true)
    api.On("UPDATE", OnUpdate)
	api.SaveSettings()
end

local function OnUnload()
	api.On("UPDATE", function() return end)
	if unsafePortalsWindow ~= nil then 
		unsafePortalsWindow:Show(false)
		unsafePortalsWindow = nil
	end
end

unsafe_portals_Addon.OnLoad = OnLoad
unsafe_portals_Addon.OnUnload = OnUnload

return unsafe_portals_Addon
