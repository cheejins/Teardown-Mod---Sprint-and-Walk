-- Sprint and Walk - By: Cheeins
#include "data.lua"
#include "utility.lua"

local gameInitialized = false

local sprintKey = "shift"
local walkKey = "c"
local dirKeys = {"w","s","a","d"}
local dirs = {
    Vec(0,0,1), --w
    Vec(0,0,-1), --s
    Vec(1,0,0), --a
    Vec(-1,0,0) --d
}

local sprintSpeed = nil
local walkSpeed = nil
local st = nil
local def = getDef()

function init()

    if gameInitialized == false then
        if GetBool("savegame.mod.init") == false then
            resetMod()
            SetBool("savegame.mod.init", true)
        end
        SetFloat("savegame.mod.sprint.amt", def.sprint.amt) -- reset stamina amt on restart
        gameInitialized = true
    end

end

function tick()

    if st == nil then
        setValues() -- set values on quickload
    end

    local sprinting = false
    if GetPlayerVehicle() == 0 then

        local hit = QueryRaycast(GetPlayerTransform().pos, Vec(0, -1, 0), 0.4)

        if hit then
            local moving = false
            local speed = 2 -- default
            local dir = Vec(0,0,0)
    
            for i = 1, #dirKeys do
                if InputDown(dirKeys[i]) then
                    dir = VecAdd(dir, dirs[i])
                    moving = true
                end
            end
            dir = VecNormalize(dir)
    
            dbw("Movement", "Normal")
            if moving then
                if InputDown(sprintKey) then
                    sprinting = true
                    if st.amt >= 0 then
                        speed = sprintSpeed
                        subStamina()
                        move(speed, dir)
                        dbw("Movement", "Sprinting")
                    end
                end
                if InputDown(walkKey) then
                    speed = walkSpeed
                    move(speed, dir)
                    dbw("Movement", "Walking")
                end
            end


    
            dbw("st.amt", st.amt)
            dbw("st.timer", st.timer)
            dbw("st.delay", st.delay)
        end
    end

    if sprinting == false then addStamina() end
end


function setValues()
    sprintSpeed = GetFloat("savegame.mod.sprint.speed") or 11
    walkSpeed = GetFloat("savegame.mod.walk.speed") or 2.5

    local ts = GetTimeStep()
    st = {
        min = 0,
        max = GetFloat("savegame.mod.sprint.max") or def.sprint.max,
        amt = GetFloat("savegame.mod.sprint.amt") or def.sprint.amt,
        add = (((GetFloat("savegame.mod.sprint.max")
                or def.sprint.max)*ts))
                / ((GetFloat("savegame.mod.sprint.delay") or (def.sprint.delay))),
        sub = ts,
        timer = 0,
        delay = GetFloat("savegame.mod.sprint.delay") or def.sprint.delay,
    }
end

function move(_speed, _dir)

    local mvDir = VecScale(_dir, _speed)

    local camTr = GetPlayerCameraTransform()
    local camFwd = TransformToParentPoint(camTr, Vec(0,0,1))
    camTr.pos[2] = 0
    camFwd[2] = 0

    local camSubFlatY = VecNormalize(VecSub(camTr.pos, camFwd))
    camTr.rot = QuatLookAt(GetPlayerTransform(), camSubFlatY)

    local sVel = GetPlayerVelocity()
    sVel = VecSub(camTr.pos, TransformToParentPoint(camTr, mvDir))
    sVel[2] = GetPlayerVelocity()[2]
    SetPlayerVelocity(sVel)
    -- printVec(GetPlayerVelocity())
end
function addStamina()
    if st.timer <= 0 and st.amt < st.max then
        st.amt = st.amt + st.add
    elseif st.timer >= 0 then
        st.timer = st.timer - GetTimeStep()
    end
end
function subStamina()
    st.amt = st.amt - st.sub
    SetFloat("savegame.mod.sprint.amt", st.amt)
    if st.amt >= 0 then st.timer = st.delay end
end


function draw()
    drawSprintBar()
end
function drawSprintBar()
    if GetPlayerVehicle() == 0 and st.amt < st.max then
        local pad = 6
        local spBarW = 300
        local stFac = st.max/st.amt
        local sptBarVal = spBarW/(st.max/st.amt)
        local spBarH = 30

        UiColor(0,0,0) -- bar bg
        UiTranslate(100, 1000)
        UiRect(spBarW+pad, spBarH)

        UiColor(1,1/stFac,1/stFac) -- bar fill
        UiTranslate(pad/2,pad/2)
        UiRect(sptBarVal, spBarH-pad)
    end
end


function resetMod()
    SetFloat("savegame.mod.sprint.speed",  def.sprint.speed)
    SetString("savegame.mod.sprint.mode", def.sprint.mode)
    SetFloat("savegame.mod.sprint.max", def.sprint.max) -- duration
    SetFloat("savegame.mod.sprint.add", def.sprint.add) -- recovery rate
    SetFloat("savegame.mod.sprint.delay", def.sprint.delay) -- recovery delay

    SetFloat("savegame.mod.walk.speed", def.walk.speed)
    SetString("savegame.mod.walk.mode", def.walk.mode)

    dbp("All values reset")
end


local db = false -- debug
function dbp(str)
    if db then DebugPrint(str) end
end
function dbw(str, val)
    if db then DebugWatch(str, val) end
end