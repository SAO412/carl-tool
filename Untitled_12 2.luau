print("Hello, world!");-- ==============================================================================
-- 📱🌸 Carl Tool - 《一掌轟仙界》完整菜單版（含歷代更新日誌 v2.0 ~ v3.0） 🌸📱
-- ==============================================================================

local RAW_ASSET_ID = "135295556334883"
local DISCORD_INVITE_URL = "https://discord.gg/XknhQjbE4z"
local CONFIG_FILE_NAME = "CarlTool_YiZhang_Full_v3.json"

local UPDATE_LOGS_DATA = {
    zh = {
        "📱 [v3.0] 整合動態數值去重追蹤與全參數可調滑桿",
        "  • 優先採信最新變動的 0~20 數字標籤，減少抓到殘留/舊數字導致打很低。",
        "  • 支援「目標數字」、「折返保護門檻」、「點擊冷卻 ms」與「點螢幕 X/Y 比例」即時調整並自動存檔。",
        "",
        "📱 [v2.9] 去重追蹤 + 折返保護防漏打",
        "  • 記錄各數字標籤前次內容，鎖定最近變動數值並針對從高點折返補點。",
        "",
        "📱 [v2.8] 精準鎖定 20 與點螢幕模式",
        "  • 改為直接點螢幕並縮短冷卻，鎖定 20 尾端提升完美一擊穩定度。",
        "",
        "📱 [v2.7] 修復 MainUI 同名 Frame 抓錯導致完全不攻擊",
        "  • 改由「發！」按鈕與「凝聚光波」文字反推所屬容器，不再誤抓頂部金錢欄。",
        "  • 結合 firesignal 直觸按鈕事件 + GuiInset 修正座標點擊。",
        "",
        "📱 [v2.6] 修復卡關問題與放寬 0~20 動態數字偵測",
        "  • 放寬動態數字與游標偵測條件，避免因單一座標或高度門檻過早回傳 nil。",
        "",
        "📱 [v2.5] 依真實 UI 結構鎖定 0~20 光波條",
        "  • 追蹤光波底條游標比例與即時 0~20 數值，排除底部固定刻度 0/5/10/15/20。",
        "",
        "📱 [v2.4] 全畫面 UI 結構掃描",
        "  • 擴大掃描範圍至全畫面可見 UI 元件與文字/數值，並支援一鍵複製結構。",
        "",
        "📱 [v2.3] 新增「一鍵抓進度條結構」診斷工具",
        "  • 針對進度條物件結構不明導致不打/誤打，加入一鍵掃描並複製 UI 資訊。",
        "",
        "📱 [v2.2] 游標寬度篩選與邊緣比例計算",
        "  • 篩選橫向游標寬度並依進度條左右邊界計算百分比。",
        "",
        "📱 [v2.0] 純手機介面與觸控全面重寫",
        "  • 改為頂部 5 分頁、懸浮球自動吸邊、大熱區開關與滑桿、中英切換與主題配色。"
    },
    en = {
        "📱 [v3.0] Integrated Active Number Tracking & Full Adjustable Sliders",
        "  • Prioritizes actively changing 0-20 labels to prevent low-distance misfires.",
        "  • Adjustable Target (0-20), Turnback Guard, Cooldown (ms), and Screen Tap X/Y % with auto-save.",
        "",
        "📱 [v2.9] Active Label Deduplication + Turnback Guard",
        "  • Tracks label text changes and triggers on turnback from peak to avoid missing 20.",
        "",
        "📱 [v2.8] Target 20 & Screen Tap Mode",
        "  • Switched to screen tapping with shorter cooldown for peak precision.",
        "",
        "📱 [v2.7] Fixed Duplicate 'Frame' Lookup Bug",
        "  • Locates wave panel via '發！' / '凝聚光波' and adds firesignal + GuiInset tap support.",
        "",
        "📱 [v2.6] Relaxed 0-20 Counter Detection",
        "  • Prevented premature nil returns from strict height or Y-position filters.",
        "",
        "📱 [v2.5] 0-20 Wave Bar & Dynamic Counter Lock",
        "  • Filters static 0/5/10/15/20 ticks and reads live 0-20 progress.",
        "",
        "📱 [v2.4] Full-Screen UI Structure Scan",
        "  • Expanded scan across visible UI elements and clipboard copy.",
        "",
        "📱 [v2.3] One-Tap Bar Structure Dumper",
        "  • Added UI hierarchy & position dumper for troubleshooting.",
        "",
        "📱 [v2.2] Cursor Width Filter & Edge Ratio",
        "  • Calculated bar percentage from cursor width and bar bounds.",
        "",
        "📱 [v2.0] Mobile UI & Touch Rewrite",
        "  • Top 5 tabs, edge-snapping floating button, touch sliders, bilingual & theme switcher."
    }
}

local function generateDynamicSignature()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local sig = "CarlUI_"
    math.randomseed(os.time() + tick())
    for i = 1, math.random(10, 18) do
        local idx = math.random(1, #chars)
        sig = sig .. chars:sub(idx, idx)
    end
    return sig
end

local _POLY_ID = generateDynamicSignature()

local function getExecutorName()
    if identifyexecutor then return identifyexecutor()
    elseif getexecutorname then return getexecutorname()
    elseif Delta then return "Delta Mobile"
    elseif Codex then return "Codex Mobile"
    elseif Fluxus then return "Fluxus Mobile"
    elseif Arceus then return "Arceus X"
    else return "Executor" end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local currentLanguage = "zh"
local currentThemeIndex = 1

local ThemePresets = {
    Pink = Color3.fromRGB(255, 105, 180),
    NeonCyan = Color3.fromRGB(0, 245, 255),
    NeonPurple = Color3.fromRGB(199, 125, 255),
    Gold = Color3.fromRGB(255, 215, 0),
    Green = Color3.fromRGB(50, 235, 130),
    Red = Color3.fromRGB(255, 99, 71),
    Blue = Color3.fromRGB(30, 144, 255),
    Orange = Color3.fromRGB(255, 140, 0),
    Lime = Color3.fromRGB(173, 255, 47),
    White = Color3.fromRGB(240, 248, 255)
}

local ThemeNames = {
    "🌸 櫻花粉", "💎 電光青", "🔮 霓虹紫",
    "👑 閃耀金", "🍃 翡翠綠", "🍎 活力紅",
    "🌊 湛藍海", "🍊 蜜柑橘", "🍋 青檸黃", "☁️ 雲朵白"
}
local ThemeKeys = {"Pink", "NeonCyan", "NeonPurple", "Gold", "Green", "Red", "Blue", "Orange", "Lime", "White"}

local function getAccentColor()
    return ThemePresets[ThemeKeys[currentThemeIndex]] or ThemePresets.Pink
end

local Config = {
    AutoLaunch = false,
    AutoWalk = false,
    TargetNum = 20,
    TurnbackGuard = 19,
    ClickDelayMs = 80,
    TapScaleX = 50,
    TapScaleY = 72,
    MenuTextSize = 14,
    MenuBackgroundAlpha = 12,
    SavedThemeIndex = 1,
    SavedLanguage = "zh",
    PanelWidth = 430,
    PanelHeight = 310
}

local SessionStats = {
    StartTime = tick(),
    LaunchCount = 0,
    DetectedCount = 0
}

local _LastTick = 0
local _IsClicking = false
local _saveQueued = false
local lastSeenNum = nil
local lastLabelText = {}

local function saveConfig()
    if _saveQueued then return end
    _saveQueued = true
    task.delay(0.35, function()
        _saveQueued = false
        if writefile then
            pcall(function()
                Config.SavedThemeIndex = currentThemeIndex
                Config.SavedLanguage = currentLanguage
                writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(Config))
            end)
        end
    end)
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE_NAME) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE_NAME))
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if k ~= "AutoLaunch" and k ~= "AutoWalk" then
                        Config[k] = v
                    end
                end
                currentThemeIndex = Config.SavedThemeIndex or 1
                currentLanguage = Config.SavedLanguage or "zh"
            end
        end)
    end
end
loadConfig()

local TextDict = {
    zh = {
        MainTab = "⚡ 掛機",
        BagTab = "🎒 法寶",
        LogsTab = "📊 日誌",
        ChangelogTab = "📜 更新",
        CfgTab = "⚙️ 設定",
        AutoLaunch = "🚀 自動發射 (點螢幕)",
        TargetNum = "🎯 目標數字 (0~20)",
        TurnbackGuard = "↩️ 折返保護門檻",
        ClickDelayMs = "⏳ 點擊冷卻 (ms)",
        TapScaleX = "📍 點擊 X 位置 (%)",
        TapScaleY = "📍 點擊 Y 位置 (%)",
        AutoWalk = "🚶 自動往前走",
        ScanBagNow = "🔍 掃描背包法寶",
        SelectAll = "☑ 全選/取消",
        ExportSelected = "📋 複製匯出",
        ResetStats = "🔄 重置數據",
        ChangelogTitle = "📜 歷代更新日誌 (v2.0 ~ v3.0)",
        FontSize = "🔤 字體大小",
        MenuAlpha = "🎨 透明度 %",
        AccentTheme = "✨ 主題配色"
    },
    en = {
        MainTab = "⚡ Farm",
        BagTab = "🎒 Bag",
        LogsTab = "📊 Logs",
        ChangelogTab = "📜 News",
        CfgTab = "⚙️ Setup",
        AutoLaunch = "🚀 Auto Tap Screen",
        TargetNum = "🎯 Target Num (0-20)",
        TurnbackGuard = "↩️ Turnback Guard",
        ClickDelayMs = "⏳ Cooldown (ms)",
        TapScaleX = "📍 Tap X Pos (%)",
        TapScaleY = "📍 Tap Y Pos (%)",
        AutoWalk = "🚶 Auto Walk",
        ScanBagNow = "🔍 Scan Bag",
        SelectAll = "☑ All/None",
        ExportSelected = "📋 Copy",
        ResetStats = "🔄 Reset",
        ChangelogTitle = "📜 Changelog (v2.0 ~ v3.0)",
        FontSize = "🔤 Font Size",
        MenuAlpha = "🎨 Alpha %",
        AccentTheme = "✨ Theme"
    }
}

local function t(key)
    return TextDict[currentLanguage][key] or key
end

local refreshLanguageText, updateThemeStyle, refreshChangelogText

local gui = Instance.new("ScreenGui")
gui.Name = "CarlUI_" .. _POLY_ID
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        gui.Parent = game:GetService("CoreGui")
    else
        gui.Parent = pg
    end
end)
if not gui.Parent or not gui:IsDescendantOf(game) then
    gui.Parent = pg
end

local function applyCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 16)
    c.Parent = p
end

local function setupImage(imageLabel, assetId)
    pcall(function()
        imageLabel.Image = "rbxassetid://" .. tostring(assetId)
        task.spawn(function()
            task.wait(1.5)
            if imageLabel and imageLabel.Parent and not imageLabel.IsLoaded then
                imageLabel.Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420"
            end
        end)
    end)
end

local dragState = nil
local resizeState = nil
local mainPanel, floatingBtn

local function bindDrag(obj, onRelease)
    obj.Active = true
    obj.Draggable = false

    obj.InputBegan:Connect(function(inp)
        if resizeState or dragState then return end
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            local parentOrigin = obj.Parent and obj.Parent.AbsolutePosition or Vector2.zero
            dragState = {
                target = obj,
                inp = inp,
                startInput = Vector2.new(inp.Position.X, inp.Position.Y),
                startPos = obj.AbsolutePosition - parentOrigin,
                moved = 0,
                onRelease = onRelease
            }
        end
    end)
end

UserInputService.InputChanged:Connect(function(inp)
    if resizeState and (inp == resizeState.inp or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local cur = Vector2.new(inp.Position.X, inp.Position.Y)
        local delta = cur - resizeState.startInput
        local cam = workspace.CurrentCamera
        local maxW = cam and math.max(350, cam.ViewportSize.X - 16) or 700
        local maxH = cam and math.max(230, cam.ViewportSize.Y - 16) or 480
        local w = math.clamp(resizeState.startSize.X + delta.X, 350, maxW)
        local h = math.clamp(resizeState.startSize.Y + delta.Y, 230, maxH)
        if mainPanel then
            mainPanel.Size = UDim2.new(0, w, 0, h)
        end
        return
    end

    if dragState and (inp == dragState.inp or inp.UserInputType == Enum.UserInputType.MouseMovement) then
        local cur = Vector2.new(inp.Position.X, inp.Position.Y)
        local delta = cur - dragState.startInput
        dragState.moved = math.max(dragState.moved, delta.Magnitude)
        local nextPos = dragState.startPos + delta
        dragState.target.Position = UDim2.new(0, nextPos.X, 0, nextPos.Y)
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if resizeState and (inp == resizeState.inp or inp.UserInputType == Enum.UserInputType.MouseButton1) then
        resizeState = nil
        if mainPanel then
            Config.PanelWidth = math.floor(mainPanel.AbsoluteSize.X)
            Config.PanelHeight = math.floor(mainPanel.AbsoluteSize.Y)
            saveConfig()
        end
    end

    if dragState and (inp == dragState.inp or inp.UserInputType == Enum.UserInputType.MouseButton1) then
        local done = dragState
        dragState = nil
        if done.onRelease then
            done.onRelease(done.moved, done.target)
        end
    end
end)

local floatGui = Instance.new("ScreenGui")
floatGui.Name = "CarlFloat_" .. _POLY_ID
floatGui.ResetOnSpawn = false
floatGui.IgnoreGuiInset = true
pcall(function()
    if gethui then floatGui.Parent = gethui() else floatGui.Parent = gui.Parent end
end)

floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 54, 0, 54)
floatingBtn.Position = UDim2.new(0, 12, 0, 130)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 230, 242)
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Active = true
floatingBtn.Draggable = false
floatingBtn.AutoButtonColor = false
floatingBtn.Visible = false
floatingBtn.ZIndex = 100
floatingBtn.Parent = floatGui
applyCorner(floatingBtn, 18)
setupImage(floatingBtn, RAW_ASSET_ID)

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = getAccentColor()
floatStroke.Thickness = 2.5
floatStroke.Parent = floatingBtn

mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, Config.PanelWidth, 0, Config.PanelHeight)
mainPanel.Position = UDim2.new(0.5, -Config.PanelWidth/2, 0.5, -Config.PanelHeight/2)
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 240, 246)
mainPanel.BackgroundTransparency = Config.MenuBackgroundAlpha / 100
mainPanel.Active = true
mainPanel.Draggable = false
mainPanel.Parent = gui
applyCorner(mainPanel, 22)

bindDrag(mainPanel, nil)

local lastTap = 0
bindDrag(floatingBtn, function(moved, btn)
    if moved < 8 then
        local now = tick()
        if now - lastTap > 0.16 then
            lastTap = now
            mainPanel.Visible = true
            floatingBtn.Visible = false
        end
    else
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(800, 400)
        local cx = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
        local snapX = (cx < vp.X / 2) and 10 or (vp.X - btn.AbsoluteSize.X - 10)
        local clampY = math.clamp(btn.AbsolutePosition.Y, 32, vp.Y - btn.AbsoluteSize.Y - 12)
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, snapX, 0, clampY)
        }):Play()
    end
end)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 238)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 242, 255))
}
grad.Rotation = 45
grad.Parent = mainPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = getAccentColor()
panelStroke.Transparency = 0.25
panelStroke.Thickness = 2
panelStroke.Parent = mainPanel

local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 30, 0, 30)
resizeHandle.Position = UDim2.new(1, -30, 1, -30)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = getAccentColor()
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 15
resizeHandle.ZIndex = 90
resizeHandle.Parent = mainPanel

resizeHandle.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragState = nil
        resizeState = {
            inp = inp,
            startInput = Vector2.new(inp.Position.X, inp.Position.Y),
            startSize = Vector2.new(mainPanel.AbsoluteSize.X, mainPanel.AbsoluteSize.Y)
        }
    end
end)

local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1, -16, 0, 34)
headerBar.Position = UDim2.new(0, 8, 0, 7)
headerBar.BackgroundColor3 = Color3.fromRGB(255, 250, 253)
headerBar.BackgroundTransparency = 0.35
headerBar.ZIndex = 20
headerBar.Parent = mainPanel
applyCorner(headerBar, 12)

local headerLogo = Instance.new("ImageLabel")
headerLogo.Size = UDim2.new(0, 24, 0, 24)
headerLogo.Position = UDim2.new(0, 7, 0.5, -12)
headerLogo.BackgroundTransparency = 1
headerLogo.ScaleType = Enum.ScaleType.Fit
headerLogo.ZIndex = 25
headerLogo.Parent = headerBar
setupImage(headerLogo, RAW_ASSET_ID)

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0, 150, 1, 0)
headerTitle.Position = UDim2.new(0, 36, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "CARL TOOL 🌸"
headerTitle.TextColor3 = Color3.fromRGB(160, 60, 110)
headerTitle.Font = Enum.Font.GothamBlack
headerTitle.TextSize = 13
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 25
headerTitle.Parent = headerBar

local function makeHeaderBtn(rightOffset, txt, col)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 28)
    b.Position = UDim2.new(1, -rightOffset, 0.5, -14)
    b.BackgroundColor3 = Color3.fromRGB(255, 232, 244)
    b.Text = txt
    b.TextColor3 = col
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.ZIndex = 30
    b.Parent = headerBar
    applyCorner(b, 9)
    return b
end

local discordBtn = makeHeaderBtn(122, "💬", Color3.fromRGB(114, 137, 218))
local langBtn = makeHeaderBtn(91, (currentLanguage == "zh") and "EN" or "中", Color3.fromRGB(120, 80, 105))
langBtn.TextSize = 11
local minimizeBtn = makeHeaderBtn(60, "➖", Color3.fromRGB(120, 80, 105))
local closeBtn = makeHeaderBtn(30, "❌", Color3.fromRGB(239, 68, 68))

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then pcall(function() setclipboard(DISCORD_INVITE_URL) end) end
end)

langBtn.MouseButton1Click:Connect(function()
    currentLanguage = (currentLanguage == "zh") and "en" or "zh"
    langBtn.Text = (currentLanguage == "zh") and "EN" or "中"
    refreshLanguageText()
    saveConfig()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    floatingBtn.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    Config.AutoLaunch = false
    Config.AutoWalk = false
    pcall(function()
        if lp and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character.Humanoid:Move(Vector3.new(0, 0, 0))
        end
    end)
    pcall(function()
        if floatGui then floatGui:Destroy() end
        if gui then gui:Destroy() end
    end)
end)

local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(1, -16, 0, 32)
navBar.Position = UDim2.new(0, 8, 0, 46)
navBar.BackgroundTransparency = 1
navBar.ZIndex = 20
navBar.Parent = mainPanel

local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Padding = UDim.new(0, 4)
navLayout.Parent = navBar

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -16, 1, -88)
pageContainer.Position = UDim2.new(0, 8, 0, 82)
pageContainer.BackgroundTransparency = 1
pageContainer.ZIndex = 10
pageContainer.Parent = mainPanel

local function createPage(useList, canvasH)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.CanvasSize = UDim2.new(0, 0, 0, canvasH or 420)
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = getAccentColor()
    p.Visible = false
    p.ZIndex = 10
    p.Parent = pageContainer
    if useList then
        local l = Instance.new("UIListLayout")
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Padding = UDim.new(0, 7)
        l.Parent = p
    end
    return p
end

local mainPage = createPage(true, 450)
local bagPage = createPage(false, 0)
local logsPage = createPage(true, 280)
local changelogPage = createPage(true, 620)
local cfgPage = createPage(true, 250)
mainPage.Visible = true

local navButtons = {}
local function createNavBtn(textKey, pageRef, order, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -3.5, 1, 0)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(255, 215, 235) or Color3.fromRGB(255, 245, 250)
    btn.BackgroundTransparency = isDefault and 0.15 or 0.45
    btn.Text = t(textKey)
    btn.TextColor3 = isDefault and Color3.fromRGB(180, 50, 110) or Color3.fromRGB(110, 90, 105)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 22
    btn.LayoutOrder = order
    btn.Parent = navBar
    applyCorner(btn, 10)

    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs({mainPage, bagPage, logsPage, changelogPage, cfgPage}) do
            p.Visible = (p == pageRef)
        end
        for _, b in ipairs(navButtons) do
            b.Btn.BackgroundColor3 = (b.Btn == btn) and Color3.fromRGB(255, 215, 235) or Color3.fromRGB(255, 245, 250)
            b.Btn.BackgroundTransparency = (b.Btn == btn) and 0.15 or 0.45
            b.Btn.TextColor3 = (b.Btn == btn) and Color3.fromRGB(180, 50, 110) or Color3.fromRGB(110, 90, 105)
        end
    end)
    table.insert(navButtons, {Btn = btn, Key = textKey})
    return btn
end

createNavBtn("MainTab", mainPage, 1, true)
createNavBtn("BagTab", bagPage, 2, false)
createNavBtn("LogsTab", logsPage, 3, false)
createNavBtn("ChangelogTab", changelogPage, 4, false)
createNavBtn("CfgTab", cfgPage, 5, false)

local allElements = {}

local function makeToggle(parent, textKey, initialState, callback)
    local f = Instance.new("TextButton")
    f.Size = UDim2.new(1, -4, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
    f.BackgroundTransparency = 0.25
    f.AutoButtonColor = false
    f.Text = ""
    f.ZIndex = 15
    f.Parent = parent
    applyCorner(f, 13)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.72, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = t(textKey)
    lbl.TextColor3 = Color3.fromRGB(90, 70, 85)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = Config.MenuTextSize
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 16
    lbl.Parent = f
    table.insert(allElements, {Obj = lbl, Key = textKey})

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 50, 0, 28)
    pill.Position = UDim2.new(1, -60, 0.5, -14)
    pill.BackgroundColor3 = initialState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(220, 205, 215)
    pill.ZIndex = 16
    pill.Parent = f
    applyCorner(pill, 14)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = initialState and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.ZIndex = 17
    knob.Parent = pill
    applyCorner(knob, 11)

    local state = initialState
    f.MouseButton1Click:Connect(function()
        state = not state
        pill.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(220, 205, 215)
        TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        }):Play()
        callback(state)
        saveConfig()
    end)
end

local function makeSlider(parent, textKey, defaultVal, minVal, maxVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -4, 0, 52)
    container.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
    container.BackgroundTransparency = 0.25
    container.ZIndex = 15
    container.Parent = parent
    applyCorner(container, 13)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.72, 0, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = t(textKey)
    lbl.TextColor3 = Color3.fromRGB(90, 70, 85)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = Config.MenuTextSize
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 16
    lbl.Parent = container
    table.insert(allElements, {Obj = lbl, Key = textKey})

    local valBox = Instance.new("TextLabel")
    valBox.Size = UDim2.new(0, 56, 0, 20)
    valBox.Position = UDim2.new(1, -68, 0, 4)
    valBox.BackgroundTransparency = 1
    valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = getAccentColor()
    valBox.Font = Enum.Font.Code
    valBox.TextSize = Config.MenuTextSize
    valBox.TextXAlignment = Enum.TextXAlignment.Right
    valBox.ZIndex = 16
    valBox.Parent = container
    table.insert(allElements, {ValBox = valBox})

    local touchZone = Instance.new("Frame")
    touchZone.Size = UDim2.new(1, -24, 0, 24)
    touchZone.Position = UDim2.new(0, 12, 0, 24)
    touchZone.BackgroundTransparency = 1
    touchZone.ZIndex = 18
    touchZone.Parent = container

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 10)
    barBg.Position = UDim2.new(0, 0, 0.5, -5)
    barBg.BackgroundColor3 = Color3.fromRGB(235, 215, 225)
    barBg.ZIndex = 16
    barBg.Parent = touchZone
    applyCorner(barBg, 5)

    local barFill = Instance.new("Frame")
    local initRatio = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    barFill.Size = UDim2.new(initRatio, 0, 1, 0)
    barFill.BackgroundColor3 = getAccentColor()
    barFill.ZIndex = 17
    barFill.Parent = barBg
    applyCorner(barFill, 5)
    table.insert(allElements, {SliderFill = barFill})

    local sliderInp = nil
    local lastVal = defaultVal

    local function applyX(x)
        local r = math.clamp((x - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor(minVal + (maxVal - minVal) * r + 0.5)
        local exactR = (v - minVal) / math.max(maxVal - minVal, 1)
        barFill.Size = UDim2.new(math.clamp(exactR, 0, 1), 0, 1, 0)
        valBox.Text = tostring(v)
        if v ~= lastVal then
            lastVal = v
            callback(v)
        end
    end

    touchZone.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragState = nil
            sliderInp = inp
            applyX(inp.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if sliderInp and (inp == sliderInp or inp.UserInputType == Enum.UserInputType.MouseMovement) then
            applyX(inp.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if sliderInp and (inp == sliderInp or inp.UserInputType == Enum.UserInputType.MouseButton1) then
            sliderInp = nil
            saveConfig()
        end
    end)
end

-- 1. 掛機分頁（全可調參數）
local liveStatusText = "🌸 待機中..."
local currentNumDisplay = "-"

makeToggle(mainPage, "AutoLaunch", Config.AutoLaunch, function(v)
    Config.AutoLaunch = v
    lastSeenNum = nil
    if not v then liveStatusText = "⏸️ 已暫停" end
end)

makeSlider(mainPage, "TargetNum", Config.TargetNum, 0, 20, function(v)
    Config.TargetNum = v
end)

makeSlider(mainPage, "TurnbackGuard", Config.TurnbackGuard, 15, 20, function(v)
    Config.TurnbackGuard = v
end)

makeSlider(mainPage, "ClickDelayMs", Config.ClickDelayMs, 50, 800, function(v)
    Config.ClickDelayMs = v
end)

makeSlider(mainPage, "TapScaleX", Config.TapScaleX, 10, 90, function(v)
    Config.TapScaleX = v
end)

makeSlider(mainPage, "TapScaleY", Config.TapScaleY, 10, 90, function(v)
    Config.TapScaleY = v
end)

makeToggle(mainPage, "AutoWalk", Config.AutoWalk, function(v)
    Config.AutoWalk = v
    if not v then
        pcall(function() lp.Character.Humanoid:Move(Vector3.new(0, 0, 0)) end)
    end
end)

-- 2. 法寶分頁
bagPage.CanvasSize = UDim2.new(0, 0, 0, 0)
bagPage.ScrollingEnabled = false

local scanNowBtn = Instance.new("TextButton")
scanNowBtn.Size = UDim2.new(1, -4, 0, 34)
scanNowBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 230)
scanNowBtn.Text = t("ScanBagNow")
scanNowBtn.TextColor3 = Color3.fromRGB(160, 50, 100)
scanNowBtn.Font = Enum.Font.GothamBold
scanNowBtn.TextSize = Config.MenuTextSize
scanNowBtn.ZIndex = 16
scanNowBtn.Parent = bagPage
applyCorner(scanNowBtn, 11)
table.insert(allElements, {Obj = scanNowBtn, Key = "ScanBagNow"})

local bagScroll = Instance.new("ScrollingFrame")
bagScroll.Size = UDim2.new(1, -4, 1, -92)
bagScroll.Position = UDim2.new(0, 0, 0, 40)
bagScroll.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
bagScroll.BackgroundTransparency = 0.35
bagScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
bagScroll.ScrollBarThickness = 3
bagScroll.ScrollBarImageColor3 = getAccentColor()
bagScroll.ZIndex = 15
bagScroll.Parent = bagPage
applyCorner(bagScroll, 11)

local bagLayout = Instance.new("UIListLayout")
bagLayout.SortOrder = Enum.SortOrder.LayoutOrder
bagLayout.Padding = UDim.new(0, 4)
bagLayout.Parent = bagScroll

local bagStatusLbl = Instance.new("TextLabel")
bagStatusLbl.Size = UDim2.new(1, -4, 0, 16)
bagStatusLbl.Position = UDim2.new(0, 2, 1, -48)
bagStatusLbl.BackgroundTransparency = 1
bagStatusLbl.Text = "💡 開啟背包後點上方掃描"
bagStatusLbl.TextColor3 = Color3.fromRGB(150, 50, 100)
bagStatusLbl.Font = Enum.Font.Code
bagStatusLbl.TextSize = 11
bagStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
bagStatusLbl.ZIndex = 15
bagStatusLbl.Parent = bagPage

local selectAllBagBtn = Instance.new("TextButton")
selectAllBagBtn.Size = UDim2.new(0.48, 0, 0, 30)
selectAllBagBtn.Position = UDim2.new(0, 0, 1, -30)
selectAllBagBtn.BackgroundColor3 = Color3.fromRGB(255, 230, 242)
selectAllBagBtn.Text = t("SelectAll")
selectAllBagBtn.TextColor3 = Color3.fromRGB(120, 80, 105)
selectAllBagBtn.Font = Enum.Font.GothamBold
selectAllBagBtn.TextSize = 12
selectAllBagBtn.ZIndex = 16
selectAllBagBtn.Parent = bagPage
applyCorner(selectAllBagBtn, 10)
table.insert(allElements, {Obj = selectAllBagBtn, Key = "SelectAll"})

local exportSelectedBtn = Instance.new("TextButton")
exportSelectedBtn.Size = UDim2.new(0.49, 0, 0, 30)
exportSelectedBtn.Position = UDim2.new(0.51, -4, 1, -30)
exportSelectedBtn.BackgroundColor3 = getAccentColor()
exportSelectedBtn.Text = t("ExportSelected")
exportSelectedBtn.TextColor3 = Color3.new(1, 1, 1)
exportSelectedBtn.Font = Enum.Font.GothamBold
exportSelectedBtn.TextSize = 12
exportSelectedBtn.ZIndex = 16
exportSelectedBtn.Parent = bagPage
applyCorner(exportSelectedBtn, 10)
table.insert(allElements, {Obj = exportSelectedBtn, Key = "ExportSelected"})

local RarityStyles = {
    ["七彩"] = {Color = Color3.fromRGB(200, 50, 200), Icon = "✨"},
    ["金光"] = {Color = Color3.fromRGB(210, 160, 0), Icon = "👑"},
    ["神品"] = {Color = Color3.fromRGB(220, 80, 20), Icon = "🔥"},
    ["仙品"] = {Color = Color3.fromRGB(0, 160, 200), Icon = "💎"},
    ["靈品"] = {Color = Color3.fromRGB(40, 160, 90), Icon = "🍃"},
    ["凡品"] = {Color = Color3.fromRGB(120, 120, 130), Icon = "📦"}
}

local function getRarityStyle(txt)
    for k, s in pairs(RarityStyles) do
        if txt:find(k) then return s end
    end
    return {Color = Color3.fromRGB(100, 100, 120), Icon = "🔹"}
end

local selectedBagItems, bagCardRefs, bagRowButtons = {}, {}, {}

local function scanBagInventory()
    local foundCount = 0
    local currentSeen = {}

    pcall(function()
        for _, guiObj in ipairs(pg:GetDescendants()) do
            if guiObj and (guiObj:IsA("Frame") or guiObj:IsA("ScrollingFrame")) then
                local gName = guiObj.Name:lower()
                if (gName:find("bag") or gName:find("inventory") or gName:find("grid")) and guiObj.Visible then
                    for _, item in ipairs(guiObj:GetDescendants()) do
                        if item and item:IsA("Frame") and item.Visible and item.AbsoluteSize.X > 36 then
                            local texts = {}
                            for _, sub in ipairs(item:GetDescendants()) do
                                if sub and sub:IsA("TextLabel") and sub.Visible and sub.Text ~= "" then
                                    table.insert(texts, sub.Text)
                                end
                            end
                            if #texts > 0 then
                                local combined = table.concat(texts, " | ")
                                if not combined:find("法寶背包") and not combined:find("功法") and not combined:find("仙緣商城") and not combined:find("展示台") and not currentSeen[combined] then
                                    currentSeen[combined] = true
                                    foundCount = foundCount + 1

                                    if not bagCardRefs[combined] then
                                        bagCardRefs[combined] = item
                                        local style = getRarityStyle(combined)

                                        local rowBtn = Instance.new("TextButton")
                                        rowBtn.Size = UDim2.new(1, -4, 0, 34)
                                        rowBtn.BackgroundColor3 = Color3.fromRGB(255, 238, 245)
                                        rowBtn.Text = string.format(" [ ] %s %s", style.Icon, combined)
                                        rowBtn.TextColor3 = style.Color
                                        rowBtn.Font = Enum.Font.Code
                                        rowBtn.TextSize = 11
                                        rowBtn.TextXAlignment = Enum.TextXAlignment.Left
                                        rowBtn.ZIndex = 16
                                        rowBtn.Parent = bagScroll
                                        applyCorner(rowBtn, 9)
                                        bagRowButtons[combined] = rowBtn

                                        rowBtn.MouseButton1Click:Connect(function()
                                            if selectedBagItems[combined] then
                                                selectedBagItems[combined] = nil
                                                rowBtn.BackgroundColor3 = Color3.fromRGB(255, 238, 245)
                                                rowBtn.Text = string.format(" [ ] %s %s", style.Icon, combined)
                                            else
                                                selectedBagItems[combined] = true
                                                rowBtn.BackgroundColor3 = Color3.fromRGB(255, 210, 230)
                                                rowBtn.Text = string.format(" [☑] %s %s", style.Icon, combined)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    for key, card in pairs(bagCardRefs) do
        if not currentSeen[key] or not card or not card.Parent then
            bagCardRefs[key], selectedBagItems[key] = nil, nil
            if bagRowButtons[key] then bagRowButtons[key]:Destroy(); bagRowButtons[key] = nil end
        end
    end

    bagScroll.CanvasSize = UDim2.new(0, 0, 0, foundCount * 38 + 8)
    SessionStats.DetectedCount = foundCount
    bagStatusLbl.Text = (foundCount > 0) and string.format("✨ 識別 %d 件法寶", foundCount) or "⚠️ 未偵測到法寶"
end

scanNowBtn.MouseButton1Click:Connect(scanBagInventory)

local isAllBagSelected = false
selectAllBagBtn.MouseButton1Click:Connect(function()
    isAllBagSelected = not isAllBagSelected
    for key, btn in pairs(bagRowButtons) do
        local style = getRarityStyle(key)
        if isAllBagSelected then
            selectedBagItems[key] = true
            btn.BackgroundColor3 = Color3.fromRGB(255, 210, 230)
            btn.Text = string.format(" [☑] %s %s", style.Icon, key)
        else
            selectedBagItems[key] = nil
            btn.BackgroundColor3 = Color3.fromRGB(255, 238, 245)
            btn.Text = string.format(" [ ] %s %s", style.Icon, key)
        end
    end
end)

exportSelectedBtn.MouseButton1Click:Connect(function()
    local count, summary = 0, ""
    for key, _ in pairs(selectedBagItems) do
        count = count + 1
        summary = summary .. "- " .. key .. "\n"
    end
    if setclipboard and count > 0 then
        pcall(function() setclipboard(summary) end)
        bagStatusLbl.Text = string.format("📋 已複製 %d 件法寶", count)
    else
        bagStatusLbl.Text = "⚠️ 未選取或無剪貼簿權限"
    end
end)

-- 3. 日誌分頁
local statsCard = Instance.new("Frame")
statsCard.Size = UDim2.new(1, -4, 0, 134)
statsCard.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
statsCard.BackgroundTransparency = 0.25
statsCard.ZIndex = 15
statsCard.Parent = logsPage
applyCorner(statsCard, 13)

local statsLbl = Instance.new("TextLabel")
statsLbl.Size = UDim2.new(1, -16, 1, -12)
statsLbl.Position = UDim2.new(0, 8, 0, 6)
statsLbl.BackgroundTransparency = 1
statsLbl.Text = "🌸 載入中..."
statsLbl.TextColor3 = Color3.fromRGB(90, 70, 85)
statsLbl.Font = Enum.Font.Code
statsLbl.TextSize = 12
statsLbl.TextXAlignment = Enum.TextXAlignment.Left
statsLbl.TextYAlignment = Enum.TextYAlignment.Top
statsLbl.ZIndex = 16
statsLbl.Parent = statsCard

local resetStatsBtn = Instance.new("TextButton")
resetStatsBtn.Size = UDim2.new(1, -4, 0, 34)
resetStatsBtn.BackgroundColor3 = Color3.fromRGB(255, 230, 242)
resetStatsBtn.Text = t("ResetStats")
resetStatsBtn.TextColor3 = Color3.fromRGB(120, 80, 105)
resetStatsBtn.Font = Enum.Font.GothamBold
resetStatsBtn.TextSize = 13
resetStatsBtn.ZIndex = 15
resetStatsBtn.Parent = logsPage
applyCorner(resetStatsBtn, 12)
table.insert(allElements, {Obj = resetStatsBtn, Key = "ResetStats"})

resetStatsBtn.MouseButton1Click:Connect(function()
    SessionStats.StartTime = tick()
    SessionStats.LaunchCount = 0
    SessionStats.DetectedCount = 0
end)

-- 4. 更新分頁
local changelogCard = Instance.new("Frame")
changelogCard.Size = UDim2.new(1, -4, 0, 580)
changelogCard.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
changelogCard.BackgroundTransparency = 0.25
changelogCard.ZIndex = 15
changelogCard.Parent = changelogPage
applyCorner(changelogCard, 13)

local changelogTitleLbl = Instance.new("TextLabel")
changelogTitleLbl.Size = UDim2.new(1, -16, 0, 22)
changelogTitleLbl.Position = UDim2.new(0, 8, 0, 6)
changelogTitleLbl.BackgroundTransparency = 1
changelogTitleLbl.Text = t("ChangelogTitle")
changelogTitleLbl.TextColor3 = getAccentColor()
changelogTitleLbl.Font = Enum.Font.GothamBold
changelogTitleLbl.TextSize = 13
changelogTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
changelogTitleLbl.ZIndex = 16
changelogTitleLbl.Parent = changelogCard
table.insert(allElements, {Obj = changelogTitleLbl, Key = "ChangelogTitle"})

local changelogBodyLbl = Instance.new("TextLabel")
changelogBodyLbl.Size = UDim2.new(1, -16, 1, -32)
changelogBodyLbl.Position = UDim2.new(0, 8, 0, 28)
changelogBodyLbl.BackgroundTransparency = 1
changelogBodyLbl.Text = ""
changelogBodyLbl.TextColor3 = Color3.fromRGB(90, 70, 85)
changelogBodyLbl.Font = Enum.Font.Code
changelogBodyLbl.TextSize = 11
changelogBodyLbl.TextXAlignment = Enum.TextXAlignment.Left
changelogBodyLbl.TextYAlignment = Enum.TextYAlignment.Top
changelogBodyLbl.TextWrapped = true
changelogBodyLbl.ZIndex = 16
changelogBodyLbl.Parent = changelogCard

refreshChangelogText = function()
    local lines = UPDATE_LOGS_DATA[currentLanguage] or UPDATE_LOGS_DATA.zh
    changelogBodyLbl.Text = table.concat(lines, "\n")
end
refreshChangelogText()

-- 5. 設定分頁
local themeRow = Instance.new("Frame")
themeRow.Size = UDim2.new(1, -4, 0, 44)
themeRow.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
themeRow.BackgroundTransparency = 0.25
themeRow.ZIndex = 15
themeRow.Parent = cfgPage
applyCorner(themeRow, 13)

local themeLbl = Instance.new("TextLabel")
themeLbl.Size = UDim2.new(0.45, 0, 1, 0)
themeLbl.Position = UDim2.new(0, 12, 0, 0)
themeLbl.BackgroundTransparency = 1
themeLbl.Text = t("AccentTheme")
themeLbl.TextColor3 = Color3.fromRGB(90, 70, 85)
themeLbl.Font = Enum.Font.GothamMedium
themeLbl.TextSize = Config.MenuTextSize
themeLbl.TextXAlignment = Enum.TextXAlignment.Left
themeLbl.ZIndex = 16
themeLbl.Parent = themeRow
table.insert(allElements, {Obj = themeLbl, Key = "AccentTheme"})

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0.48, -6, 0, 30)
themeBtn.Position = UDim2.new(0.52, 0, 0.5, -15)
themeBtn.BackgroundColor3 = Color3.fromRGB(255, 230, 242)
themeBtn.Text = ThemeNames[currentThemeIndex]
themeBtn.TextColor3 = getAccentColor()
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 12
themeBtn.ZIndex = 16
themeBtn.Parent = themeRow
applyCorner(themeBtn, 9)

themeBtn.MouseButton1Click:Connect(function()
    currentThemeIndex = currentThemeIndex % #ThemeNames + 1
    themeBtn.Text = ThemeNames[currentThemeIndex]
    updateThemeStyle()
    saveConfig()
end)

makeSlider(cfgPage, "FontSize", Config.MenuTextSize, 11, 18, function(v)
    Config.MenuTextSize = v
    for _, item in ipairs(allElements) do
        if item.Obj then pcall(function() item.Obj.TextSize = v end) end
        if item.ValBox then pcall(function() item.ValBox.TextSize = v end) end
    end
end)

makeSlider(cfgPage, "MenuAlpha", Config.MenuBackgroundAlpha, 0, 75, function(v)
    Config.MenuBackgroundAlpha = v
    mainPanel.BackgroundTransparency = v / 100
end)

updateThemeStyle = function()
    local acc = getAccentColor()
    panelStroke.Color = acc
    floatStroke.Color = acc
    changelogTitleLbl.TextColor3 = acc
    themeBtn.TextColor3 = acc
    exportSelectedBtn.BackgroundColor3 = acc
    bagScroll.ScrollBarImageColor3 = acc
    resizeHandle.TextColor3 = acc
    for _, item in ipairs(allElements) do
        if item.ValBox then item.ValBox.TextColor3 = acc end
        if item.SliderFill then item.SliderFill.BackgroundColor3 = acc end
    end
end

refreshLanguageText = function()
    for _, item in ipairs(navButtons) do
        item.Btn.Text = t(item.Key)
    end
    for _, item in ipairs(allElements) do
        if item.Key and item.Obj then item.Obj.Text = t(item.Key) end
    end
    refreshChangelogText()
end

updateThemeStyle()

-- 去重追蹤最近變動的 0~20 數字標籤
local function findActiveDynNum()
    local m = pg:FindFirstChild("MainUI")
    if not m then return nil end

    local changedNum = nil
    local fallbackNum = nil

    for _, v in ipairs(m:GetDescendants()) do
        if v:IsA("TextButton") and v.Visible and v.Text:find("發") and v.Parent then
            for _, c in ipairs(v.Parent:GetDescendants()) do
                if c:IsA("TextLabel") and c.Visible then
                    local txt = c.Text:gsub("^%s+", ""):gsub("%s+$", "")
                    local n = tonumber(txt)
                    if n and n >= 0 and n <= 20 and math.floor(n) == n and c.AbsoluteSize.Y >= 24 then
                        if lastLabelText[c] ~= txt then
                            lastLabelText[c] = txt
                            changedNum = n
                        end
                        if not fallbackNum or n > fallbackNum then
                            fallbackNum = n
                        end
                    end
                end
            end
        end
    end

    return changedNum or fallbackNum
end

local function clickScreen()
    if _IsClicking then return end
    local now = tick()
    if now - _LastTick < (Config.ClickDelayMs / 1000) then return end

    _IsClicking = true
    _LastTick = now

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local inset = GuiService:GetGuiInset()

    local x = vp.X * (Config.TapScaleX / 100) + math.random(-2, 2)
    local y = vp.Y * (Config.TapScaleY / 100) + inset.Y + math.random(-2, 2)

    local ok, vim = pcall(function() return game:GetService("VirtualInputManager") end)
    if ok and vim then
        pcall(function()
            if vim.SendTouchEvent then
                vim:SendTouchEvent(1, Enum.UserInputState.Begin.Value, x, y)
                task.wait(0.01)
                vim:SendTouchEvent(1, Enum.UserInputState.End.Value, x, y)
            else
                vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait(0.01)
                vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
            end
            SessionStats.LaunchCount = SessionStats.LaunchCount + 1
            liveStatusText = string.format("⚡ 已點螢幕 (%d次)", SessionStats.LaunchCount)
        end)
    end

    _IsClicking = false
end

local function fmtTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = math.floor(sec % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

RunService.RenderStepped:Connect(function()
    local elapsed = tick() - SessionStats.StartTime
    local ping = 0
    pcall(function()
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)

    statsLbl.Text = string.format(
        "• ⏳ 時長: %s | 🚀 次數: %d\n• 🔢 數值: %s | 📶 %d ms\n• 📱 %s\n• %s",
        fmtTime(elapsed),
        SessionStats.LaunchCount,
        currentNumDisplay,
        ping,
        getExecutorName(),
        liveStatusText
    )

    pcall(function()
        if Config.AutoWalk then
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local cam = workspace.CurrentCamera
                local look = cam.CFrame.LookVector
                hum:Move(Vector3.new(look.X, 0, look.Z).Unit, true)
            end
        end
    end)

    if not Config.AutoLaunch then return end

    local num = findActiveDynNum()
    if num == nil then
        lastSeenNum = nil
        currentNumDisplay = "-"
        liveStatusText = "🔍 等待光波數字..."
        return
    end

    currentNumDisplay = tostring(num)
    local hitTarget = (num >= Config.TargetNum)
    local turnedBack = (lastSeenNum ~= nil and lastSeenNum >= Config.TurnbackGuard and num < lastSeenNum)
    lastSeenNum = num

    liveStatusText = string.format("🎯 目標 %d | 折返 >=%d", Config.TargetNum, Config.TurnbackGuard)

    if hitTarget or turnedBack then
        clickScreen()
    end
end)