local def = { -- default values
    sprint = {
        speed = 11,
        mode = "hold",
        max = 5, -- duration
        amt = 5, -- duration
        add = 2, -- recovery rate
        delay = 2, -- recovery delay
    },
    walk = {
        speed = 2.5,
        mode = "hold"
    }
}
function getDef() return def end
