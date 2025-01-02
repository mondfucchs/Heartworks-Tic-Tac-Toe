local love   = require("love")
local ttt    = require("functions")

-- Loading Assets:
local background = love.graphics.newImage("assets/img/background.png")
local heartworks = love.graphics.newImage("assets/img/heartworks.png")
local cursorspr  = love.graphics.newImage("assets/img/cursor.png")

local x_spr      = love.graphics.newImage("assets/img/x.png")
local o_spr      = love.graphics.newImage("assets/img/o.png")

local x_prv      = love.graphics.newImage("assets/img/x_preview.png")
local o_prv      = love.graphics.newImage("assets/img/o_preview.png")

_G.msg_xwon   = love.graphics.newImage("assets/img/msg_xwon.png")
_G.msg_owon   = love.graphics.newImage("assets/img/msg_owon.png")
_G.msg_tie    = love.graphics.newImage("assets/img/msg_tie.png")

_G.msg        = nil

local font       = love.graphics.newFont("assets/heartworks-font.ttf", 40)

-- Creating bidimensional board table:
_G.board = {}

-- Creating timers:
_G.timers = {}

-- Control Variables:
_G.pointpermit = false
local mouseActive = true

for i = 0, 2 do
    board[i] = {}
    for j = 0, 2 do
        board[i][j] = nil
    end
end

-- Setting other general variables:
_G.turnowner = "x"

function love.load()
    love.mouse.setVisible(false)
    love.graphics.setFont(font)

    _G.x_score = 0
    _G.o_score = 0

    _G.sounds = {}
    sounds.win_o = love.audio.newSource("assets/sound/win_o.wav", "static")
    sounds.win_x = love.audio.newSource("assets/sound/win_x.wav", "static")
    sounds.tie   = love.audio.newSource("assets/sound/tie.wav", "static")
end


function love.update(dt)

    -- Checking timers:

    for i = #timers, 1, -1 do

        timers[i].time = timers[i].time - dt

        if timers[i].time <= 0 then

            if timers[i].callback then
                timers[i].callback()
            end

            table.remove(timers, i)
        end
    end

    if love.mouse.isDown(1) and mouseActive then
        mouseActive = false
        ttt.put(ttt.checkwgrid())
    end

    if not love.mouse.isDown(1) and not ttt.checkwin() then
        mouseActive = true
    end

    if ttt.checkwin() and not pointpermit then
        if turnowner == "x" then _G.msg = msg_owon; sounds.win_o:play() end
        if turnowner == "o" then _G.msg = msg_xwon; sounds.win_x:play() end

        mouseActive = false
        _G.pointpermit = true

        ttt.wait(1,
        function()
            ttt.cleanboard()
            ttt.givepoint()
            mouseActive = true
        end)

    elseif ttt.checktie() and not ttt.checkwin() then
        _G.msg = msg_tie
        sounds.tie:play()
        ttt.wait(1,
        function()
            ttt.cleanboard()
        end)

    end
end


function love.draw()

    -- Background images:
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(heartworks, 5, 413)

    -- Scores:
    love.graphics.setColor(0.2, 0.2, 0.2)

    love.graphics.print(x_score, 104, 24)
    love.graphics.print(o_score, 104, 72)

    love.graphics.setColor(0.75, 0.25, 0.25)

    love.graphics.setColor(1, 1, 1)

    -- O's and X's

    for x, row in pairs(board) do
        for y, square in pairs(row) do

            if square == "x" then
                love.graphics.draw(x_spr, 32 + 96 * x, 136 + 96 * y)

            elseif square == "o" then
                love.graphics.draw(o_spr, 32 + 96 * x, 136 + 96 * y)
            end
        end
    end

    -- Previews:

    local previewx, previewy = ttt.checkwgrid()

    if (previewx ~= nil) and (previewy ~= nil) and (mouseActive) then
        if (turnowner == "x") then love.graphics.draw(x_prv, 32 + 96 * previewx, 136 + 96 * previewy) end
        if (turnowner == "o") then love.graphics.draw(o_prv, 32 + 96 * previewx, 136 + 96 * previewy) end
    end

    -- Message:

    if msg ~= nil then
        love.graphics.draw(msg, 152, 288)
        ttt.wait(1, function()
            _G.msg = nil
        end)
    end

    -- Cursor:

    love.graphics.draw(cursorspr, math.floor(love.mouse.getX() / 8) * 8, math.floor(love.mouse.getY() / 8) * 8)
end