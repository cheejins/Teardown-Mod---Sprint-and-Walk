#include "utility.lua"
#include "data.lua"
#include "main.lua"

--[[
- speeds
- stamina
    - stamina add rate: slider
    - stamina sub rate: slider
    - stamina delay: slider
    - stamina bar: on, off
]]

local ui = {
    bgColor = 0.12,
}

local def = getDef()
local lim = {
    sprint = {
        speed = 100 / 30,
        mode = "hold",
        max = 100 / 30,
        add = 100 / 30,
        delay = 100 / 10
    },
    walk = {
        speed = 100 / 5,
        mode = "hold"
    }
}
local min = {
    sprint = {
        speed = 7
    },
    walk = {
        speed = 1
    }
}

-- sliders
local slW = 400
local slMul = slW/100

function init()
    -- checkModSet()
end

function draw()

    UiColor(1, 1, 1)
    UiFont("bold.ttf", 40)

    UiPush() -- Heading
        UiTranslate(300, 20)

        UiPush()
            UiColor(ui.bgColor, ui.bgColor, ui.bgColor)
            local bounds = {1300,170}
            UiRect(bounds[1], bounds[2])
        UiPop()

        UiPush()
            UiAlign("right top")
            UiColor(1, 1, 1)
            UiTranslate(1270, 20)
            UiFont("bold.ttf", 40)
            local resetButton = UiTextButton("RESET", 200, 50)
            if resetButton then
                resetMod()
            end
        UiPop()

        -- Image
        UiPush()
            UiTranslate(20, 20)
            UiImageBox("MOD/Preview.jpg", 120, 120, 1, 1)
        UiPop()
        -- Title
        UiTranslate(150, 20)
        UiAlign("left top")
        UiFont("bold.ttf", 70)
        UiText("Sprint and Walk")
        -- Author
        UiTranslate(0, 70)
        UiFont("bold.ttf", 35)
        UiText("By: Cheejins")

    UiPop()

    -- Stamina box
    UiPush()
        -- Sprint box
        UiPush()
            UiTranslate(300,215)
            UiPush()
                UiColor(ui.bgColor, ui.bgColor, ui.bgColor)
                local bounds = {625,700}
                UiRect(bounds[1], bounds[2])
            UiPop()

            UiTranslate(20,50) -- padding
            UiPush() -- heading
                UiFont("bold.ttf", 40)
                UiText("SPRINT")

                UiTranslate(50,20) -- padding

                UiPush() -- slider - speed
                    UiTranslate(0,50)

                    UiFont("bold.ttf", 30)
                    UiText("Speed")
                    UiTranslate(0,20)

                    UiAlign("left middle")
                    UiColor(0.4, 0.4, 0.4)
                    UiRect(slW+10, 10)

                    -- sprint speed
                    UiColor(1, 1, 1)
                    local limit = lim.sprint.speed
                    local value = (GetFloat("savegame.mod.sprint.speed") or 2) * slMul
                    local done = false
                    value, done = UiSlider("ui/common/dot.png", "x", value*limit, 0, slW)
                    if done then
                        SetFloat("savegame.mod.sprint.speed", value/slMul/limit)
                        -- dbp("savegame.mod.sprint.speed = " .. value/slMul/limit)
                    end
                    UiPush()
                        UiTranslate(slW+25,0)
                        UiText(sfn(value/slMul/limit, 1))
                    UiPop()

                UiPop()

                -- UiPush() -- button - toggle/hold
                --     UiTranslate(0,150)
                --     UiFont("bold.ttf", 30)

                --     UiText("Mode")
                --     UiTranslate(0,10)

                --     UiColor(0.8, 0.8, 0.8)
                --     UiImageBox("ui/common/box-solid-6.png", 200, 50, 6, 6)
                --     UiTranslate(4,4)
                --     UiColor(1, 1, 1)
                --     UiImageBox("ui/common/box-solid-6.png", 192, 42, 6, 6)

                --     UiTranslate(100,21)
                --     UiColor(0, 0, 0)
                --     UiAlign("center middle")
                --     UiTextButton("Toggle", 200, 50)
                -- UiPop()
            UiPop()

            UiTranslate(0,250) -- padding
            UiPush() -- sprint - heading
                UiFont("bold.ttf", 40)
                UiText("SPRINT STAMINA")

                UiTranslate(50,20) -- indent
                
                UiPush() -- slider
                    UiTranslate(0,50)
                    
                    UiFont("bold.ttf", 30)
                    UiText("Sprint Duration (seconds)")
                    UiTranslate(0,20)

                    UiAlign("left middle")
                    UiColor(0.4, 0.4, 0.4)
                    UiRect(slW+10, 10)

                    UiColor(1, 1, 1)
                    local limit = lim.sprint.max
                    local value = (GetFloat("savegame.mod.sprint.max") or 2) * slMul
                    local done = false
                    value, done = UiSlider("ui/common/dot.png", "x", value*limit, 0, slW)
                    if done then
                        SetFloat("savegame.mod.sprint.max", value/slMul/limit)
                        -- dbp("savegame.mod.sprint.max = " .. value/slMul/limit)
                    end
                    UiPush()
                        UiTranslate(slW+25,0)
                        UiText(sfn(value/slMul/limit, 1))
                    UiPop()

                UiPop()

                UiTranslate(0,50) -- indent
                UiPush() -- slider
                    UiTranslate(0,100)
                    
                    UiFont("bold.ttf", 30)
                    UiText("Recovery Time")
                    UiTranslate(0,20)

                    UiAlign("left middle")
                    UiColor(0.4, 0.4, 0.4)
                    UiRect(slW+10, 10)

                    -- sprint add (recovery time)
                    UiColor(1, 1, 1)
                    local limit = lim.sprint.add
                    local value = (GetFloat("savegame.mod.sprint.add") or 2) * slMul
                    local done = false
                    value, done = UiSlider("ui/common/dot.png", "x", value*limit, 0, slW)
                    if done then
                        SetFloat("savegame.mod.sprint.add", value/slMul/limit)
                        -- dbp("savegame.mod.sprint.add = " .. value/slMul/limit)
                    end
                    UiPush()
                        UiTranslate(slW+25,0)
                        UiText(sfn(value/slMul/limit, 1))
                    UiPop()

                UiPop()

                UiTranslate(0,100) -- indent
                UiPush() -- slider
                    UiTranslate(0,100)
                    
                    UiFont("bold.ttf", 30)
                    UiText("Recovery Delay")
                    UiTranslate(0,20)

                    UiAlign("left middle")
                    UiColor(0.4, 0.4, 0.4)
                    UiRect(slW+10, 10)

                    -- sprint delay (recovery time)
                    UiColor(1, 1, 1)
                    local limit = lim.sprint.delay
                    local value = (GetFloat("savegame.mod.sprint.delay") or 2) * slMul
                    local done = false
                    value, done = UiSlider("ui/common/dot.png", "x", value*limit, 0, slW)
                    if done then
                        SetFloat("savegame.mod.sprint.delay", value/slMul/limit)
                        -- dbp("savegame.mod.sprint.delay = " .. value/slMul/limit)
                    end
                    UiPush()
                        UiTranslate(slW+25,0)
                        UiText(sfn(value/slMul/limit, 1))
                    UiPop()
                UiPop()

            UiPop()
        UiPop()
    UiPop()


    -- Walk box
    UiPush()
        UiPush()
            UiTranslate(950,215)

            UiPush()
                UiColor(ui.bgColor, ui.bgColor, ui.bgColor)
                local bounds = {650,700}
                UiRect(bounds[1], bounds[2])
            UiPop()

            UiTranslate(20,50) -- padding
            UiPush() -- heading
                UiFont("bold.ttf", 40)
                UiText("WALK")

                UiTranslate(50,20) -- padding
                UiPush() -- slider
                    UiTranslate(0,50)

                    UiFont("bold.ttf", 30)
                    UiText("Speed")

                    UiTranslate(0,20)
                    UiAlign("left middle")
                    UiColor(0.4, 0.4, 0.4)
                    UiRect(slW+10, 10)

                    UiColor(1, 1, 1)

                    local limit = lim.walk.speed
                    local value = ((GetFloat("savegame.mod.walk.speed") or def.walk.speed))
                    local valueMul = value * slMul
                    local done = false
                    value, done = UiSlider("ui/common/dot.png", "x", valueMul*limit, 0, slW)
                    value = value/slMul/limit -- normal value

                    if done then
                        SetFloat("savegame.mod.walk.speed", value)
                        dbp("savegame.mod.walk.speed = " .. GetFloat("savegame.mod.walk.speed"))
                    end

                    UiPush()
                        UiTranslate(slW + 25,0)
                        UiText(sfn((value), 1))
                    UiPop()

                UiPop()

                -- UiPush() -- button - toggle/hold
                --     UiTranslate(0,150)
                --     UiFont("bold.ttf", 30)

                --     UiText("Mode")
                --     UiTranslate(0,10)

                --     UiColor(0.8, 0.8, 0.8)
                --     UiImageBox("ui/common/box-solid-6.png", 200, 50, 6, 6)
                --     UiTranslate(4,4)
                --     UiColor(1, 1, 1)
                --     UiImageBox("ui/common/box-solid-6.png", 192, 42, 6, 6)

                --     UiTranslate(100,21)
                --     UiColor(0, 0, 0)
                --     UiAlign("center middle")
                --     UiTextButton("Toggle", 200, 50)
                -- UiPop()

            UiPop()
        UiPop()
    UiPop()

    UiPop()
        UiColor(1, 1, 1)
        UiTranslate(UiCenter()-20, 970)
        UiFont("bold.ttf", 50)
        UiAlign("center middle")
        if UiTextButton("Close", 200, 40) then
            Menu()
        end
    UiPop()

end


function resetMod()
    SetFloat("savegame.mod.sprint.speed",  def.sprint.speed)
    SetString("savegame.mod.sprint.mode", def.sprint.mode)
    SetFloat("savegame.mod.sprint.max", def.sprint.max) -- duration
    SetFloat("savegame.mod.sprint.add", def.sprint.add) -- recovery rate
    SetFloat("savegame.mod.sprint.delay", def.sprint.delay) -- recovery delay

    SetFloat("savegame.mod.walk.speed", def.walk.speed)
    SetString("savegame.mod.walk.mode", def.walk.mode)

    -- dbp("All values reset")
end

local db = false -- debug
function dbp(str)
    if db then DebugPrint(str) end
end
function dbw(str, val)
    if db then DebugWatch(str, val) end
end