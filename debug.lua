--// Script By Summer Studio
--// Runtime GUI Scanner
--// Scan ONLY opened GUI
--// Mobile/VNG Optimized

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local Logged = {}
local Webhook = ""

local RequestFunction =
    request
    or http_request
    or syn and syn.request

local KEYWORDS = {
    "robux",
    "purchase",
    "buy",
    "confirm",
    "success",
    "donate",
    "gift",
    "premium",
    "owned",
    "completed",
    "mua",
    "thành công"
}

--========================
-- GUI
--========================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SummerStudioScanner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

--========================
-- OPEN BUTTON
--========================

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = ScreenGui

OpenButton.Size = UDim2.new(0,55,0,55)
OpenButton.Position = UDim2.new(0,20,0.5,-27)

OpenButton.Text = "O"
OpenButton.TextScaled = true

OpenButton.TextColor3 = Color3.new(1,1,1)

OpenButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
OpenButton.BackgroundTransparency = 0.2

OpenButton.BorderSizePixel = 2
OpenButton.BorderColor3 = Color3.fromRGB(120,120,120)

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1,0)
OpenCorner.Parent = OpenButton

--========================
-- MAIN GUI
--========================

local Main = Instance.new("Frame")
Main.Parent = ScreenGui

Main.Size = UDim2.new(0,360,0,300)
Main.Position = UDim2.new(0.5,-180,0.5,-150)

Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,12)
MainCorner.Parent = Main

-- TITLE

local Title = Instance.new("TextLabel")
Title.Parent = Main

Title.Size = UDim2.new(1,0,0,40)

Title.BackgroundTransparency = 1
Title.Text = "Script By Summer Studio"

Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)

-- CLOSE

local Close = Instance.new("TextButton")
Close.Parent = Main

Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)

Close.Text = "X"
Close.TextScaled = true

Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(45,45,45)

-- WEBHOOK LABEL

local Label = Instance.new("TextLabel")
Label.Parent = Main

Label.Size = UDim2.new(1,0,0,30)
Label.Position = UDim2.new(0,0,0,55)

Label.BackgroundTransparency = 1

Label.Text = "Discord Webhook"
Label.TextScaled = true

Label.TextColor3 = Color3.new(1,1,1)

-- WEBHOOK BOX

local WebhookBox = Instance.new("TextBox")
WebhookBox.Parent = Main

WebhookBox.Size = UDim2.new(0.9,0,0,40)
WebhookBox.Position = UDim2.new(0.05,0,0,90)

WebhookBox.PlaceholderText = "Paste Webhook..."
WebhookBox.Text = ""

WebhookBox.TextScaled = true

WebhookBox.TextColor3 = Color3.new(1,1,1)
WebhookBox.BackgroundColor3 = Color3.fromRGB(35,35,35)

local WebhookCorner = Instance.new("UICorner")
WebhookCorner.CornerRadius = UDim.new(0,10)
WebhookCorner.Parent = WebhookBox

-- STATUS

local Status = Instance.new("TextLabel")
Status.Parent = Main

Status.Size = UDim2.new(1,0,0,30)
Status.Position = UDim2.new(0,0,0,145)

Status.BackgroundTransparency = 1

Status.Text = "Waiting..."
Status.TextScaled = true

Status.TextColor3 = Color3.fromRGB(0,255,0)

-- LOGS

local Logs = Instance.new("TextBox")
Logs.Parent = Main

Logs.Size = UDim2.new(0.9,0,0.35,0)
Logs.Position = UDim2.new(0.05,0,0,185)

Logs.MultiLine = true
Logs.ClearTextOnFocus = false
Logs.TextEditable = false

Logs.TextWrapped = false
Logs.TextXAlignment = Enum.TextXAlignment.Left
Logs.TextYAlignment = Enum.TextYAlignment.Top

Logs.TextSize = 14

Logs.Text = ""

Logs.BackgroundColor3 = Color3.fromRGB(30,30,30)
Logs.TextColor3 = Color3.new(1,1,1)

local LogsCorner = Instance.new("UICorner")
LogsCorner.CornerRadius = UDim.new(0,10)
LogsCorner.Parent = Logs

--========================
-- DRAG
--========================

local function Drag(gui)

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    gui.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()

                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end

            end)
        end
    end)

    gui.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end

    end)

    UIS.InputChanged:Connect(function(input)

        if input == dragInput and dragging then

            local delta = input.Position - dragStart

            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

        end
    end)
end

Drag(OpenButton)
Drag(Main)

--========================
-- OPEN/CLOSE
--========================

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

--========================
-- WEBHOOK
--========================

WebhookBox.FocusLost:Connect(function()

    Webhook = WebhookBox.Text

    Status.Text = "Webhook Saved"

end)

local function SendWebhook(msg)

    if Webhook == "" then
        return
    end

    if not RequestFunction then
        return
    end

    pcall(function()

        RequestFunction({
            Url = Webhook,
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = HttpService:JSONEncode({
                content = "```"..msg.."```"
            })
        })

    end)
end

--========================
-- KEYWORD CHECK
--========================

local function HasKeyword(str)

    str = tostring(str):lower()

    for _,k in pairs(KEYWORDS) do

        if str:find(k) then
            return true
        end

    end

    return false
end

--========================
-- LOG
--========================

local function AddLog(msg)

    if #Logs.Text > 12000 then
        Logs.Text = ""
    end

    Logs.Text =
        Logs.Text ..
        "\n\n" ..
        msg

end

--========================
-- CHECK GUI
--========================

local function Check(v)

    if Logged[v] then
        return
    end

    if not (
        v:IsA("TextLabel")
        or v:IsA("TextButton")
        or v:IsA("ImageLabel")
        or v:IsA("ImageButton")
    ) then
        return
    end

    local found = false
    local text = ""

    if HasKeyword(v.Name) then
        found = true
    end

    pcall(function()

        text = v.Text or ""

        if HasKeyword(text) then
            found = true
        end

    end)

    if found then

        Logged[v] = true

        local output =
            "Class : "..v.ClassName.."\n" ..
            "Name  : "..v.Name.."\n" ..
            "Path  : "..v:GetFullName().."\n" ..
            "Text  : "..text

        print(output)

        AddLog(output)

        SendWebhook(output)

        Status.Text = "Detected : "..v.Name

    end
end

--========================
-- ONLY SCAN OPENED GUI
--========================

CoreGui.DescendantAdded:Connect(function(v)

    task.defer(function()

        pcall(function()
            Check(v)
        end)

    end)

end)

Status.Text = "Scanner Started"
