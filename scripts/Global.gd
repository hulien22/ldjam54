extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const TacticHints: Dictionary = {
	HINT_LARGE_SOLDIERS = "They have many large fighters",
	HINT_STEALTHY = "You don't seem to see anyone..",
	HINT_DEFENSIVE = "They seem heavily fortified",
	HINT_DUMB = "They don't seem very smart",
	HINT_POOR_ARMOR = "They are known to be lightly armored",
}

var tactics: Dictionary = {
	"The Beeg Bonk" : Tactic.new("The Beeg Bonk", "Hit them with the largest sticks we can find", "Good against poorly armored fighters", "Bad against ranged attacks and even larger sticks", [TacticHints.HINT_LARGE_SOLDIERS, TacticHints.HINT_DUMB]),
	"Gorilla Tactics" : Tactic.new("Gorilla Tactics", "Send in a bunch of gorillas", "Good against archers", "Scared of horses", [TacticHints.HINT_LARGE_SOLDIERS, ]),
	"Omae Wa Mou Shindeiru" : Tactic.new("Omae Wa Mou Shindeiru", "Teleport behind their backs using ", "PRO", "CON"),
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

# Scores from -3 to 3. Determines how much stronger the first tactic is over the second.
# Keys are named tacticname-tacticname, and each pair only appears once.
const tactics_score: Dictionary = {
	"The Beeg Bonk-Gorilla Tactics" : 0,
}


func get_tactics_score(tactic1:String, tactic2:String) -> int:
	# All tactics tie against themselves.
	if (tactic1 == tactic2):
		return 0;

	# find tactics, find score difference from map (do both checks to find)
	# check environment and add/subtract from score
	var score = tactics_score.get(tactic1 + "-" + tactic2)
	if (score == null):
		score = tactics_score.get(tactic2 + "-" + tactic1)
	if (score == null):
		score = 0;
		push_error("Could not find tactics score for tactics ", tactic1, " and ", tactic2);
	
	return score;

