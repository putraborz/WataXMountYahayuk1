--// Service Roblox
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// URL data verifikasi
local urlVip = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/vip.txt"
local urlSatuan = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/2.txt"

--// URL script utama jika berhasil verifikasi
local successUrls = {
    "https://raw.githubusercontent.com/putraborz/WataXMountAtin/main/Loader/WataX.lua",
    "https://raw.githubusercontent.com/putraborz/WataXMountYahayuk1/refs/heads/main/Loader/mainmap970.lua"
}

--// Link sosial
local TIKTOK_LINK = "https://www.tiktok.com/@lexxc"
local DISCORD_LINK = "https://discord.gg/"

--// Fungsi ambil data
local function fetch(url)
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    return ok and res or nil
end

--// Cek verifikasi
local function isVerified(uname)
    local vip = fetch(urlVip)
    local sat = fetch(urlSatuan)
    if not vip or not sat then return false end
    uname = uname:lower()

    local function checkList(list)
        for line in list:gmatch("[^\r\n]+") do
            local nameOnly = line:match("^(.-)%s*%-%-") or line
            nameOnly = nameOnly:match("^%s*(.-)%s*$")
            if nameOnly:lower() == uname then
                return true
            end
        end
        return false
    end
    return checkList(vip) or checkList(sat)
end

--// Notifikasi
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Info",
            Text = text or "",
            Duration = duration or 4
        })
    end)
end

--// GUI utama
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LexHostVerification"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1
frame.Visible = false

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 0, 0)

--// Efek RGB pada pinggir frame
task.spawn(function()
    local hue = 0
    while frame.Parent do
        hue = (hue + 0.005) % 1
        stroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.02)
    end
end)

--// Animasi muncul lembut
frame.Visible = true
frame.Size = UDim2.new(0, 100, 0, 80)
TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 200),
    BackgroundTransparency = 0
}):Play()

--// Partikel melayang (aura)
for i = 1, 10 do
    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
    dot.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
    dot.BackgroundTransparency = 0.3
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
    dot.ZIndex = 1
    task.spawn(function()
        while dot.Parent do
            TweenService:Create(dot, TweenInfo.new(math.random(4,8), Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = 0.8
            }):Play()
            task.wait(math.random(4,8))
            dot.BackgroundTransparency = 0.3
        end
    end)
end

--// Tombol close
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--// Avatar player
local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0, 64, 0, 64)
avatar.Position = UDim2.new(0, 20, 0, 40)
avatar.BackgroundTransparency = 1

task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100)
    end)
    if ok and img then
        avatar.Image = img
    else
        avatar.Image = "rbxassetid://112840507"
    end
end)

--// Nama player dengan efek RGB lembut
local unameLabel = Instance.new("TextLabel", frame)
unameLabel.Position = UDim2.new(0, 100, 0, 55)
unameLabel.Size = UDim2.new(1, -120, 0, 30)
unameLabel.BackgroundTransparency = 1
unameLabel.Font = Enum.Font.GothamBold
unameLabel.TextSize = 22
unameLabel.TextColor3 = Color3.fromRGB(255,255,255)
unameLabel.TextXAlignment = Enum.TextXAlignment.Left
unameLabel.Text = player.Name

task.spawn(function()
    local hue = 0
    while unameLabel.Parent do
        hue = (hue + 0.01) % 1
        unameLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait(0.02)
    end
end)

--// Label status
local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 20, 0, 120)
status.Size = UDim2.new(1, -40, 0, 24)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Text = "Klik tombol verifikasi untuk lanjut..."

--// Tombol baris bawah
local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.86, 0, 0, 36)
btnRow.Position = UDim2.new(0.07, 0, 1, -44)
btnRow.BackgroundTransparency = 1

local buttons = {
    {Name="TikTok", Color=Color3.fromRGB(0,0,0), Link=TIKTOK_LINK},
    {Name="Verifikasi", Color=Color3.fromRGB(60,180,100), Link=nil},
    {Name="discord", Color=Color3.fromRGB(88,101,242), Link=DISCORD_LINK}
}

local function copyToClipboard(link)
    if setclipboard then
        pcall(setclipboard, link)
        notify("LexHost", "Link disalin ke clipboard", 3)
        return true
    else
        notify("LexHost", "Executor tidak mendukung clipboard", 3)
        return false
    end
end

for i, data in ipairs(buttons) do
    local btn = Instance.new("TextButton", btnRow)
    btn.Size = UDim2.new(0.28, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.34, 0, 0, 0)
    btn.BackgroundColor3 = data.Color
    btn.Text = data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    -- Efek hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

    if data.Name == "Verifikasi" then
        btn.MouseButton1Click:Connect(function()
            status.Text = "🔍 Memeriksa..."
            btn.Active = false
            local ok, verified = pcall(function()
                return isVerified(player.Name)
            end)
            btn.Active = true

            if ok and verified then
                status.Text = "✅ Kamu terdaftar sebagai pengguna"
                task.wait(0.8)
                for _,url in ipairs(successUrls) do
                    pcall(function()
                        loadstring(game:HttpGet(url))()
                    end)
                end
                TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,0)}):Play()
                task.wait(0.4)
                gui:Destroy()
            else
                status.Text = "❌ Kamu belum terdaftar"
                notify("LexHost", "Kamu belum ada dalam whitelist.", 4)
            end
        end)
    else
        btn.MouseButton1Click:Connect(function()
            local ok = copyToClipboard(data.Link)
            if ok then
                status.Text = "✅ Link " .. data.Name .. " disalin!"
                task.delay(2, function()
                    if status and status.Parent then
                        status.Text = "Klik tombol verifikasi untuk lanjut..."
                    end
                end)
            end
        end)
    end
end
