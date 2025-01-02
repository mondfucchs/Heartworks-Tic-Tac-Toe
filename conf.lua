local love = require("love")

function love.conf(app)
    app.window.width  = 320
    app.window.height = 432
    app.console       = false
    app.window.icon   = "assets/img/gameicon.png"

    app.window.title  = "HW: Tic-Tac-Toe"
end