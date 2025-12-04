local _, BCDM = ...

local PRIMARY_COLOURS = {
    [0] = {0.25, 0.5, 1},
    [1] = {1, 0, 0},
    [2] = {1, 0.5, 0.25},
    [3] = {1, 1, 0},
    [6] = {0, 0.82, 1},
    [8] = {0.3, 0.52, 0.9},
    [11] = {0, 0.5, 1},
    [13] = {0.4, 0, 0.8},
    [17] = {0.79, 0.26, 0.99},
    [18] = {1, 0.61, 0}
}

local function CreatePowerBar()
    local CooldownManagerDB = BCDM.db.global
    local PowerBarDB = CooldownManagerDB.PowerBar
    local PowerBar = CreateFrame("Frame", "BCDM_PowerBar", UIParent, "BackdropTemplate")
    PowerBar:SetSize(220, PowerBarDB.Height)
    PowerBar:SetPoint(PowerBarDB.Anchors[1], PowerBarDB.Anchors[2], PowerBarDB.Anchors[3], PowerBarDB.Anchors[4], PowerBarDB.Anchors[5])
    PowerBar:SetBackdrop({bgFile = BCDM.Media.PowerBarBGTexture, edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
    PowerBar:SetBackdropColor(unpack(PowerBarDB.BGColour))
    PowerBar:SetBackdropBorderColor(0, 0, 0, 1)
    PowerBar:SetFrameStrata("MEDIUM")
    PowerBar.StatusBar = CreateFrame("StatusBar", "BCDM_PowerBar_StatusBar", PowerBar)
    PowerBar.StatusBar:SetPoint("TOPLEFT", PowerBar, "TOPLEFT", 1, -1)
    PowerBar.StatusBar:SetPoint("BOTTOMRIGHT", PowerBar, "BOTTOMRIGHT", -1, 1)
    PowerBar.StatusBar:SetMinMaxValues(0, 100)
    PowerBar.StatusBar:SetStatusBarTexture(BCDM.Media.PowerBarFGTexture)
    PowerBar.StatusBar.Value = PowerBar.StatusBar:CreateFontString(nil, "OVERLAY")
    PowerBar.StatusBar.Value:SetFont(BCDM.Media.Font, PowerBarDB.Text.FontSize, BCDM.db.global.General.FontFlag)
    PowerBar.StatusBar.Value:SetTextColor(unpack(PowerBarDB.Text.Colour))
    PowerBar.StatusBar.Value:SetPoint(PowerBarDB.Text.Anchors[1], PowerBar.StatusBar, PowerBarDB.Text.Anchors[2], PowerBarDB.Text.Anchors[3], PowerBarDB.Text.Anchors[4])
    PowerBar.StatusBar.Value:SetText("")
    PowerBar.StatusBar.Value:SetDrawLayer("OVERLAY", 7)

    local function UpdatePowerBar()
        local unit = "player"
        local powerType, powerToken = UnitPowerType(unit)
        local isMana = (powerType == 0)
        local current = UnitPower(unit, powerType)
        local max = UnitPowerMax(unit, powerType)
        if max > 0 then
            PowerBar.StatusBar:SetMinMaxValues(0, max)
            PowerBar.StatusBar:SetValue(current)
            PowerBar.StatusBar.Value:SetText(isMana and string.format("%.0f%%", UnitPowerPercent(unit, Enum.PowerType.Mana, false, true)) or current)
            local powerColour = PRIMARY_COLOURS[powerType] or {0.5, 0.5, 0.5}
            PowerBar.StatusBar:SetStatusBarColor(unpack(powerColour))
        end
    end

    PowerBar:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
    PowerBar:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    PowerBar:RegisterUnitEvent("UNIT_MAXPOWER", "player")
    PowerBar:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
    PowerBar:RegisterEvent("PLAYER_ENTERING_WORLD")
    PowerBar:SetScript("OnEvent", function(self, event, ...) UpdatePowerBar() end)

    C_Timer.After(0.1, UpdatePowerBar)

    BCDM.PowerBar = PowerBar
end

function BCDM:SetPowerBarWidth()
    local PowerBarDB = BCDM.db.global.PowerBar
    if BCDM.PowerBar then
        local powerBarWidth = _G[PowerBarDB.Anchors[2]]:GetWidth() + 2
        BCDM.PowerBar:SetWidth(powerBarWidth)
    end
end

function BCDM:SetPowerBarHeight()
    if BCDM.PowerBar then
        BCDM.PowerBar:SetHeight(BCDM.db.global.PowerBar.Height)
    end
end

function BCDM:SetupPowerBar()
    CreatePowerBar()
end

function BCDM:UpdatePowerBar()
    local PowerBarDB = BCDM.db.global.PowerBar
    if BCDM.PowerBar then
        BCDM:ResolveMedia()
        BCDM.PowerBar:ClearAllPoints()
        BCDM.PowerBar:SetPoint(PowerBarDB.Anchors[1], PowerBarDB.Anchors[2], PowerBarDB.Anchors[3], PowerBarDB.Anchors[4], PowerBarDB.Anchors[5])
        BCDM.PowerBar:SetBackdrop({bgFile = BCDM.Media.PowerBarBGTexture, edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
        BCDM.PowerBar:SetBackdropColor(unpack(PowerBarDB.BGColour))
        BCDM.PowerBar:SetBackdropBorderColor(0, 0, 0, 1)
        BCDM.PowerBar.StatusBar:SetStatusBarTexture(BCDM.Media.PowerBarFGTexture)
        BCDM.PowerBar.StatusBar.Value:ClearAllPoints()
        BCDM.PowerBar.StatusBar.Value:SetPoint(PowerBarDB.Text.Anchors[1], BCDM.PowerBar.StatusBar, PowerBarDB.Text.Anchors[2], PowerBarDB.Text.Anchors[3], PowerBarDB.Text.Anchors[4])
        BCDM.PowerBar.StatusBar.Value:SetFont(BCDM.Media.Font, PowerBarDB.Text.FontSize, BCDM.db.global.General.FontFlag)
        BCDM.PowerBar.StatusBar.Value:SetTextColor(unpack(PowerBarDB.Text.Colour))

        BCDM:SetPowerBarHeight()
        BCDM:SetPowerBarWidth()
    end
end