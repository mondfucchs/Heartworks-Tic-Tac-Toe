local love = require("love")

local ttt = {
    wait = function(seconds, callback)
        table.insert(timers, {time = seconds, callback = callback})
    end,

    checkwgrid = function()
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        for ix = 32, 280, 96 do
            for iy = 136, 384, 96 do
                if (x > ix and x < ix + 72) and
                   (y > iy and y < iy + 72) then
                    return (ix - 32) / 96, (iy - 136) / 96
                end
            end
        end

        return nil
    end,

    put = function(x, y)
        if x ~= nil and y ~= nil then

            if board[x][y] == nil then
                board[x][y] = turnowner
                _G.turnowner = (turnowner == "x") and "o" or "x"
            else
                return false
            end
        end
    end,

    checkwin = function()
        -- Row wining:
        for row, val in pairs(board) do
            if board[row][0] ~= nil and board[row][0] == board[row][1] and board[row][1] == board[row][2] then
                return true
            end
        end

        -- Column wining:
        for column, val in pairs(board) do
            if board[0][column] ~= nil and board[0][column] == board[1][column] and board[1][column] == board[2][column] then
                return true
            end
        end

        -- Diagonal wining:
        if board[0][0] ~= nil and board[0][0] == board[1][1] and board[1][1] == board[2][2] then
            return true
        end

        -- Inverse Diagonal Wining:
        if board[2][0] ~= nil and board[2][0] == board[1][1] and board[1][1] == board[0][2] then
            return true
        end

        return false
    end,

    checktie = function()
        -- SHOULD ONLY BE CALLED AFTER CHECKWIN!
        for r = 0, 2 do
            for c = 0, 2 do
                if board[r][c] == nil then
                    return false
                end
            end
        end

        return true
    end,

    givepoint = function()
        if turnowner == "o" then _G.x_score = x_score + 1 end
        if turnowner == "x" then _G.o_score = o_score + 1 end
    end,

    cleanboard = function()
        for i = 0, 2 do
            board[i] = {}
            for j = 0, 2 do
                board[i][j] = nil
            end
        end

        _G.pointpermit = false
    end
}


return ttt