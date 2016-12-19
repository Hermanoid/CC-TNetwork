--TestTurtle By Lucas Niewohner
--This program is technically a universal tester, although It's intented to test my FakeTurtle program.
--It works by running a chunk of code against supplied API's (the function imitations, in the case of FakeTurtle)
-- and comparing the output text (From prints and such) with the actual output from a real, Minecraftian Turtle
--The test code for each API must dig in and print every aspect or tendency that may exist a genuine ComputerCraft turtle, in order to make the tests accurate.

--Replace the object of this require with whatever code you wish to test
require("C:\\Users\\Goerge\\Documents\\GitHub\\CC-TNetwork\\Turtle\\FakeTurtle.lua")


--Name v. function and intended output
testGroups = {}

--If testing with already existing output files, true, if building output files on turtle, false
isTesting = false

function register(name,func)
--pretty simple right now, but may be changed in the future.
	testGroups[name] = func
end

--override typical print logic to write to a string (currentTestOutput), but keep the usual print method under a different name
print_normal = print

currentTestOutput = ""
print = function(text)
	if currentTestOutput == "" then
		currentTestOutput = text
	else
		currentTestOutput = currentTestOutput.."\n"..text
	end
end
function test()
	for name, func in pairs(testGroups )do
		print_normal("Testing "..name.."...")
		currentTestOutput = ""
		func()
		if isTesting then
			local file = io.open("output/"+name)
			local normalOutput = file:read("*all")
			file:close()
			if currentTestOutput == normalOutput then
				print_normal("Test for "..name.." passed!")
			else
				print_normal("** Test for "..name.." failed! **")
				print_normal("* Target (normal): *")
				print_normal(normalOutput)
				print_normal("* Actual *")
				print_normal(currentTestOutput)
			end
		else
			local file = io.open("output/"+name,"w+")
			file:write(currentTestOutput)
			file:close()
		end
		
	end
end

commandBlockName = "CommandBlock"
function CommandBlockTest()
	local commandBlock = CommandBlock:new()
	print(commandBlock:getCommand())
	commandBlock:setCommand("Do Stuff")
	print(commandBlock:getCommand())
	commandBlock:runCommand()
	commandBlock:setCommand("Do Work")
	print(commandBlock:getCommand())
	commandBlock:runCommand()
end
register(commandBlockName,CommandBlockTest)

test()