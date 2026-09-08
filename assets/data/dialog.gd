extends Node
class_name Dialog

var dialog: Dictionary = {

	# TUTORIAL

	"Intro": "WELCOME TO ECHOES:
		
Every life is recorded. Your movements and actions can become part of the solution.",

	"T1": "CREATE AN ECHO:
		
When you're ready, Activate Echo to end your current life and preserve your actions.",

	"T2": "ECHO CREATED:
		
Your previous life will now replay your actions exactly.",

	"T3": "WATCH YOUR ECHO:
		
Your Echo begins at the same time you do and repeats its recorded actions exactly. Use your echos to help your current life.",

	"T4": "ECHO CREATED:
		
When an Echo reaches the point where you activated it, it becomes a physical Echo.",

	"T5": "ECHOES HAVE WEIGHT:
		
Echoes can pass through the world without interfering with you. Echo have physical weight and can activate mechanisms.",

	"T6": "WORK WITH YOUR PAST:
		
Position your Echo so it holds the pressure plate, then use your current life to reach the exit. Cubes can also be used to activate pressure plates.",

	# DEATH / LIFE 

	"DeathWarning": "[color=#611b1b]WARNING![/color]
Activating an Echo Orb preserves your life as an Echo. Dying to a hazard does not.",

	"LifeLost": "LIFE LOST
This life was not committed. No Echo or Echo Orb will be created.",

	"FinalLife": "FINAL LIFE
There will be no next Echo. Reach the exit to complete the chamber.",

	"FinalLifeActivation": "NO LIVES REMAIN
Creating another Echo will fail the chamber.",

	# TOOLTIPS

	"ActivateEcho": "Press [F] to End this life and create an Echo.",

	"Echo": "Repeats the actions of a previous life.",

	"PressurePlate": "Requires weight to remain active.",

	"Button": "Activate it yourself, or let an Echo activate.",

	"Bollard": "Find the mechanism controlling this bollard.",

	"Hazard": "Death to hazards consumes the life without creating an Echo.",

	"Portal": "Reach the portal to complete the chamber.",

	"LifeCounter": "Your remaining attempts in this chamber.",

	"EchoCounter": "Committed lives currently helping you.",

	# HUD TOOLTIPS

	"LivesInfo": "LIVES
Each chamber gives you a limited number of lives. Intentionally activate an Echo Orb to preserve a life as an Echo. Accidental death consumes the life permanently.",

	"EchoesInfo": "ECHOES
Committed lives replay from the beginning each time a new life starts. Plan where they move, what they activate, where they become Echos, and timing may be important.",

	"EchoOrbInfo": "ECHO ORB
The physical remains of a committed Echo. Echos have weight and interact with the environment.",

}
