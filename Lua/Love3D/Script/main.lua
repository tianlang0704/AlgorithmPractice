require("Requires")

local renderer = Renderer.New()

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- Load some default values for our rectangle.
function love.load()
    renderer:Setup(800, 600)
end


function love.update(dt)
    renderer:Update(dt)
end

function love.wheelmoved(x, y)
    renderer:WheelMoved(x, y)
end

-- Draw a coloured rectangle.
function love.draw()
    renderer:Draw()
end