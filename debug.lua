--// Roblox Purchase Success Debugger
--// Script By Summer Studio

local CoreGui = game:GetService("CoreGui")

local KEYWORDS = {
    "success",
    "successful",
    "completed",
    "purchase",
    "purchased",
    "mua",
    "thành công",
    "done",
    "owned"
}

local logged = {}

--========================
-- CHECK
--========================

local function hasKeyword(str)

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

local function logObject(v)

    if logged[v] then
        return
    end

    logged[v] = true

    local text = ""

    pcall(function()
        text = v.Text
    end)

    print("=================================")
    print("Class : "..v.ClassName)
    print("Name  : "..v.Name)
    print("Path  : "..v:GetFullName())
    print("Text  : "..text)
    print("=================================")

end

--========================
-- CHECK OBJECT
--========================

local function check(v)

    if not (
        v:IsA("TextLabel")
        or v:IsA("TextButton")
        or v:IsA("ImageLabel")
        or v:IsA("ImageButton")
        or v:IsA("Frame")
    ) then
        return
    end

    local found = false

    if hasKeyword(v.Name) then
        found = true
    end

    pcall(function()

        if v.Text and hasKeyword(v.Text) then
            found = true
        end

    end)

    if found then
        logObject(v)
    end
end

--========================
-- EXISTING
--========================

for _,v in pairs(CoreGui:GetDescendants()) do

    task.spawn(function()

        pcall(function()
            check(v)
        end)

    end)
end

--========================
-- RUNTIME HOOK
--========================

CoreGui.DescendantAdded:Connect(function(v)

    task.defer(function()

        pcall(function()
            check(v)
        end)

    end)

end)

print("Purchase Success Debugger Started")
print("Now buy something cheap to capture success GUI")
