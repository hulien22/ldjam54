extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var tactics: Dictionary = {
	"The Beeg Bonk" : Tactic.new("The Beeg Bonk", "Hit them with the largest sticks we can find", "Good against poorly armored fighters", "Bad against ranged attacks and even larger sticks"),
	"Gorilla Tactics" : Tactic.new("Gorilla Tactics", "Send in a bunch of gorillas", "Good against archers", "Scared of horses"),
	"1" : Tactic.new("NAME1", "DESC", "PRO", "CON"),
	"2" : Tactic.new("NAME2", "DESC", "PRO", "CON"),
	"3" : Tactic.new("NAME3", "DESC", "PRO", "CON"),
	"4" : Tactic.new("NAME4", "DESC", "PRO", "CON"),
	"5" : Tactic.new("NAME5", "DESC", "PRO", "CON"),
	"6" : Tactic.new("NAME6", "DESC", "PRO", "CON"),
	"7" : Tactic.new("NAME7", "DESC", "PRO", "CON"),
	"8" : Tactic.new("NAME8", "DESC", "PRO", "CON"),
	"9" : Tactic.new("NAME9", "DESC", "PRO", "CON"),
	"10" : Tactic.new("NAME10", "DESC", "PRO", "CON"),
};


