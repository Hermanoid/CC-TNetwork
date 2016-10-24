# CC-TNetwork
A Codebase designed to power the Mass Coordination of ComputerCraft Turtles

__The TNetwork is built upon the idea of mass coordination and operation of ComputerCraft Turtles.  Everything it contains, is, for the most part, accomplished via a bunch of turtles.__

_There is no code at the time of writing, so the contents of this readme are all speculative._

## The Idea-
ComputerCraft is a nice mod for MineCraft that introduces Computers, which can execute code (lua) much like regular computers.  Then, it introduces Turtles, which are robots capable of doing many MineCraftian things, such as mining, farming, digging, combat, crafting...  All of which require code and a considerable amount of waiting.

Waiting is boring.  We want stuff done faster, with minimal effort by the actual player. That is where the TNetwork comes in.  The TNetwork utilizes Modems and Networking items in ComputerCraft to operate a huge, connected Network of Turtles and their master Computers.

The Turtles themselves do no thinking.  They are given instructions, whether in real-time or in a list before execution, to do whatever they do like mindless idiots.  The ruling computers are (more or less) centralized and use an efficient communication protocol to send out tons of command messages to control many, many~ turtles simultaneously.  Because, why wait for a single turtle to dig a big hole when you can have 20!



## The Turtle Control Code

The Turtles run the slave program that lets it mindlessly act upon commands given via the RemoteTurtle API, which runs on the master, commanding computers.  These Computer use the API to create instances of a turtle command class, one for each turtle, that lets the computer control the turtle somewhat like the turtle would control itself.

That statement kind of turned in on itself.  A better example is such:

__Instead Of:__

```
  turtle.Up()
  ...
```

on the turtle itself,

__run:__

```
  rturtle = RemoteTurtle:new(turtleId)
  rturtle:Up()
  ...
```

On the Computer, Where RemoteTurtle is the API, and turtleId represents the id (also channel number) of the turtle you seek to control, as long as the turtle under that id is running the slave code

The Color (:) is a bit of syntactic sugar that lua implements to allow folks like me to imitate classes - something lua does not support - by using tables.  The colon hides the "self" variable that would otherwise have to be passed in for the imitation to work.  You can learn all about that fun colon at [lua.org](http://www.lua.org/pil/16.1.html).  (That 'classes' lesson is lesson 16.1 and reuses some objects from the introduction lesson, so you may want to check out the beginning of the chapter [here](http://www.lua.org/pil/16.1.html) before reading on to 16.1 to avoid confusion.)

***
## Sorry, but that's all the far I've gotten. 

More stuff coming soon!

_This Code is the fruit of my free time.  You may say I have no life, and you might be right._
