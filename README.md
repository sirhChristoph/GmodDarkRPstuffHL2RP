# Some bits and bobs I made for a Garry's Mod DarkRP server themed around HL2RP because I was bored.

The scripts only work for DarkRP but you could change it for other gamemodes pretty easily... At that point you may as well just remake them better.

Please note that I am terrible at lua and I am still trying to learn it so don't expect the contents to be good, just thought some people might find some of it useful.

A lot of this lua was from things I have learned instead of being scripted off the top of my head so I'm sure its clunky.

You WILL have to edit things to work for you.

I tried to add comments in places to make it easy to understand.


*- autorun-misc is a bit of a mess but adds things like thirdperson command, deathsounds, disable npc weapon drop, forces physgun colour to white, jump cooldown (antibhop, cuts velocity when jumping), HL2RP style chat voicelines, plays sound file globally when more than 3 of the defined teams die, allows opening func_door if a player owns the door or is in a doorgroup that owns the door, and finally a script that remembers the client's mat_bloomscale setting and saves it locally (on their pc, so the server doesn't have to).
- forcefields adds forcefields of different sizes that can be toggled with "/ff" command in chat if a player is in the correct team, looking at it and are within defined distance from it.
    spawn forcefield can be toggled by defined ULX ranks from anywhere on the map using "/sff" command in chat.
- instant-chargers are basically health and armour chargers that instanly set hp or armour to what is defined in jobs.lua and can only be used by certain teams.
- ui-elements adds location print on the players screen, civil protection death counter and overwatch death counter. Everything to make it work must be defined in the files, have a look.*
