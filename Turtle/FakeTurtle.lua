-- FakeTurtle by Lucas Niewohner

-- This code, however useful, is designed to imitate turtles and thier API's
-- when executing turtle code off the Turtle.  This could be used to debug code
-- in a IDE outside of MineCraft instead of copying and pasting for debugging
-- on the Turtle itself.
print("Starting up FakeTurtle")

-- A Table to hold the current state of the imitation turtle.  This will be filled with default data when this code is first executed.
TurtleState = { }

-- A table holding configuration data.  This can be change to alter the behavior of Function Imitations
config = { }

-- region Functions and Utility stuff!!!
local function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

local function getKeys(table)
    local keyset = { }
    local n = 0

    for k, v in pairs(tab) do
        n = n + 1
        keyset[n] = k
    end
    return keyset
end
-- endregion


-- region Peripheral APIs

-- region Command Block

-- Global, configurable settings for how to react to runCommand
CommandBlock = {}
config.CommandBlockPeripheral = { }
config.CommandBlockPeripheral.runCommandResponseF = function(command) return true end

function CommandBlock:new(o)
    o = o or { }
    -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self._currentCommand = self._currentCommand or nil
    self._peripheralSide = self._peripheralSide or "none"
    return o
end

function CommandBlock:setCommand(command)
    self._currentCommand = command
end

function CommandBlock:runCommand()
    return config.CommandBlockPeripheral.runCommandResponseF(self._currentCommand)
end

function CommandBlock:getCommand()
    return self._currentCommand
end
-- endregion

-- region Computer
Computer = { }
config.ComputerPeripheral = { }
-- Starting power state for computers.  off is false.
config.ComputerPeripheral.defaultPowerState = false
-- possible modes:  random, static, function
config.ComputerPeripheral.idDeterminationMode = "random"
config.ComputerPeripheral.staticIdValue = nil
config.ComputerPeripheral.functionIdDeterminer = function(side, object) return nil end
function getIdFromConfig()
    mode = config.ComputerPeripheral.idDeterminationMode
    if mode == "random" then
        -- The usual max of 65535 ids minus the special relaying channel.
        return math.random(65534)
    elseif mode == "static" then
        return config.ComputerPeripheral.staticIdValue
    elseif mode == "function" then
        return config.ComputerPeripheral.functionIdDeterminer(self._peripheralSide, self)
    end
end

function Computer:new(o)
    o = o or { }
    -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self._powerState = self._powerState or config.ComputerPeripheral.defaultPowerState
    self._id = getIdFromConfig()
    self._peripheralSide = self._peripheralSide or "none"
    return o
end

function Computer:turnOn()
    self._powerState = true
end

function Computer:shutdown()
    self._powerState = false
end

function Computer:reboot()
    self._powerState = false
    -- debated putting a delay here...  eventually decided against.
    self._powerState = true
end

function Computer:getId()
    return self._id
end

function Computer:isOn()
    return self._powerState
end
-- endregion

-- region Modem
Modem = { }

config.ModemPeripheral = { }
config.ModemPeripheral.onTransmit = function(channel, replyChannel, message) end
-- The default value for Modem's wireless property if none is supplied
config.ModemPeripheral.unknownWirelessStateDefault = true
-- Something that must be supplied by user if he/she decides to use a function involving remote peripherals (peripherals, such as a printer, connected via wired modem)
-- This should be a dictionary of peripheral instances, such as {"printer_0",printer:new(...) ...}
-- with the key being the peripheral name and the value being an instance of a peripheral.
TurtleState.remotePeripherals = { }


function Modem:new(o)
    o = o or { }
    -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self._peripheralSide = self._peripheralSide or "none"
    self._openChannels = { }
    self._isWireless = self._isWireless or config.ModemPeripheral.unknownWirelessStateDefault
    return o
end

function Modem:isOpen(channel)
    return contains(self._openChannels, channel)
end

function Modem:open(channel)
    if channel < 0 or channel > 65535 then error("channel supplied for opening is out of range (peripheral modem on side " .. self._peripheralSide .. ")") end
    table.insert(self._openChannels, channel)
end

function Modem:close(channel)
    for index, ochannel in ipairs(self._openChannels) do
        if ochannel == channel then
            table.remove(index)
            return
        end
    end
end

function Modem:closeAll()
    self._openChannels = { }
end

-- Who knows how the other guy is supposed to repond?  Let's leave that to the user of this program.
function Modem:transmit(channel, replyChannel, message)
    config.ModemPeripheral.onTransmit(channel, replyChannel, message)
end

function Modem:isWireless()
    return self._isWireless
end


 --TODO  add message event imitations.
--Remote Functions dealing with peripherals attached via Wired modem are not supported.  With quite a bit of thinker-tinking it could be 
--managed, but not yet.  If a demand is available, I will pursue this later.

--region Printer
Printer = {}
config.PrinterPeripheral = {}
config.PrinterPeripheral.startingInk = 20
config.PrinterPeripheral.startingPaper = 20

--region Page
Page = {}
config.printedPages = {}
config.printedPages.Width = 25
config.printedPages.Hieght = 21
function Page:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self._map = { }
    blankColumn = {}
    for i = 0, config.printedPages.Hieght do
        table.insert(blankColumn," ")
    end
    for i = 0, config.printedPages.Width do
        table.insert(self._map,blankColumn)
    end
end

function Page:set(x,y,character)
    self._map[x][y] = character
end
--endregion

function Printer:new(o)
    o = o or { }
    -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self._peripheralSide = self._peripheralSide or "none"
    self._pages = {}
    self._inkLevel = config.PrinterPeripheral.startingInk
    self._pageLevel = config.PrinterPeripheral.startingPaper
    return o
end

--A couple of functions to stand in for lack of players physically supplying printer.
function Printer:_feedInk(amount)
    self._inkLevel = self._inkLevel + amount
end


function Printer:newPage()
    table.insert(self._pages,Page.new({}))
end
--endregion
-- endregion


-- endregion

-- region Peripherals
peripheral = { }
config.peripheral = { }
TurtleState.peripheralData = { }

-- Default side fill - Most likely will be somehow altered by user code.
-- Note: in (potential) future versions, all peripherals here except modem will be determined by emulated world surroundings of the turtle.
TurtleState.peripheralData.sides = { }
TurtleState.peripheralData.sides["top"] = "computer"
TurtleState.peripheralData.sides["left"] = "modem"
TurtleState.peripheralData.sides["right"] = "turtle"
TurtleState.peripheralData.sides["front"] = "drive"
TurtleState.peripheralData.sides["back"] = "monitor"
TurtleState.peripheralData.sides["bottom"] = "printer"

-- Internal function.  Implemented now to create a universal standard.  This may be changed to instead get sides via the actual surroundings of the fake turtle.
function getSide(side)
    return TurtleState.peripheralData.sides[side]
end

function peripheral.isPresent(side)
    return getSide(side) ~= nil
end

function peripheral.getType(side)
    return getSide(side)
end

function peripheral.getMethods(side)
    -- TODO - requires peripheral APIs, which have yet to exist
end



function peripheral.call(...)
    args = { ...}
    if not #args > 2 then error("peripheral.call requires at least 2 arguments.  Usage:  peripherals.call(string side, string method, ...) ") end
    side = args[1]
    method = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    methodArgs = args
    -- TODO - call method. Also requires peripheral APIs
end

function peripheral.wrap(side)
    if TurtleState.peripheralData.sides[side] == nil then return nil end
    -- TODO - return API - this literally returns the peripheral API I need so bad.
end

function peripheral.find(side, fnFilter)
    return TurtleState.peripheralData.sides[side]
    -- TODO - implement Filter Function.  Couldn't implement yet because "object" parameter of fnFilter(name,object) is the corresponding Peripheral API.
end
-- endregion


-- region Rednet
-- An object to hold Rednet API function imitations
rednet = { }

-- Initializing state values for Rednet
TurtleState.rednetData = { }
TurtleState.rednetData.isOpen = false

-- Does this side have a modem?  This Function reaches out to peripherals to see how Config data says to react.  
function rednet.open(side)

end

function rednet.isOpen()
    return false
end

function rednet.lookup(protocol, hostname)
    return 1
end
-- endregion
config.CommandBlockPeripheral.runCommandResponseF = function(command)
	if command == "Do Work" then
		print("Doing Work!!!")
	 else
	 	print("But I don't know what to do!")
	 end
end
