extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const TacticHints: Dictionary = {
	HINT_LARGE_SOLDIERS = "They have many large fighters",
	HINT_STEALTHY = "You don't seem to see anyone..",
	HINT_DEFENSIVE = "They seem heavily fortified",
	HINT_POOR_ARMOR = "They are known to be lightly armored",
	HINT_DUMB = "They don't seem very smart",
	HINT_SMART = "They are known to employ advanced strategies",
	HINT_SURPRISE = "Something seems off..",
	HINT_AOE = "They plan to attack a large area",
	HINT_WEAK = "Their attacks are pretty weak",
	HINT_CAVALRY = "You hear neighing",
	HINT_POWERFUL_ATTACK = "They are known for their strong frontal assaults",
	HINT_RANGED = "Watch out for their ranged attacks",
	HINT_EXPLOSIVE = "You smell gunpowder in the wind",
	HINT_GROUPED = "They tend to group up in small clusters",
	HINT_SPREAD = "Watch out for attacks from all directions",
}
#Mobile, countermeasures, use terrain, 

var tactics: Dictionary = {
	"The Beeg Bonk" : Tactic.new("The Beeg Bonk", "Hit them with the largest sticks we can find", "Good against poorly armored fighters", "Bad against advanced strategies and even larger sticks", [TacticHints.HINT_LARGE_SOLDIERS, TacticHints.HINT_DUMB]),
	"Gorilla Tactics" : Tactic.new("Gorilla Tactics", "Send in a troop of stampeding gorillas", "Good against ranged attacks", "Scared of horses", [TacticHints.HINT_LARGE_SOLDIERS ]),
	"Omae Wa Mou Shindeiru" : Tactic.new("Omae Wa Mou Shindeiru", "Teleport behind their backs, 'Nothing personnel kid'", "Good against ranged units", "CON", [TacticHints.HINT_STEALTHY, TacticHints.HINT_SURPRISE]),
	"Faint Attack" : Tactic.new("Faint Attack", "Pretend to faint to draw in their forces, then attack!", "Works well on dumb soldiers", "CON", [TacticHints.HINT_SMART, TacticHints.HINT_SURPRISE]),
	"Platypus Defense" : Tactic.new("Platypus Defense", "Stab attackers with poisonous spurs", "Good against poorly armored fighters", "CON", [TacticHints.HINT_DEFENSIVE, TacticHints.HINT_WEAK]),
	"Tank You Very Much" : Tactic.new("Tank You Very Much", "Steal enemy tanks and attack with them", "Really good if they have tanks", "Really bad if they don't..", [TacticHints.HINT_STEALTHY]),
	"Carpet Bomb" : Tactic.new("Carpet Bomb", "Cover them with the finest carpets", "Good against units that are hiding", "Bad against stronger enemies", [TacticHints.HINT_AOE, TacticHints.HINT_WEAK, TacticHints.HINT_RANGED]),
	"Armadillo Rollout" : Tactic.new("Armadillo Rollout", "Roll armadillos at them and aim for a STRIKE!", "PRO", "CON", [TacticHints.HINT_POWERFUL_ATTACK, TacticHints.HINT_AOE]),
	"Walk The Flank" : Tactic.new("Walk The Flank", "Put on eyepatches and attack from both sides me-mateys!", "PRO", "CON", [TacticHints.HINT_SURPRISE]),
	"Chaaaaaaarge!" : Tactic.new("Chaaaaaaarge!", "Send in the cavalry!", "PRO", "CON", [TacticHints.HINT_CAVALRY, TacticHints.HINT_POWERFUL_ATTACK]),
	"Build A Wall" : Tactic.new("Build A Wall", "Build the largest wall, don't worry someone else will pay for it", "PRO", "CON", [TacticHints.HINT_DEFENSIVE]),
	"The Wolf's Head" : Tactic.new("The Wolf's Head", "Use a large battering ram to smash through enemy forces", "Strong against defensive forces", "CON", [TacticHints.HINT_POWERFUL_ATTACK]),
	"Lightning Rush" : Tactic.new("Lightning Rush", "Rush in with red anthropomorphic tanks, Ka-Chow!", "PRO", "Bad against explosives", [TacticHints.HINT_POWERFUL_ATTACK, TacticHints.HINT_DEFENSIVE]),
	"Birthday Surprise" : Tactic.new("Birthday Surprise", "Gift them a nice wooden horse filled with specially trained combat horses", "PRO", "CON", [TacticHints.HINT_CAVALRY, TacticHints.HINT_SURPRISE, TacticHints.HINT_SMART]),
	"Pyramid Scheme" : Tactic.new("Pyramid Scheme", "Invite them to join ", "PRO", "CON", [TacticHints.HINT_DEFENSIVE]),
	"Kiting" : Tactic.new("Kiting", "Uses kites to get the high ground for your archers", "PRO", "CON", [TacticHints.HINT_RANGED, TacticHints.HINT_STEALTHY]),
	"Make It Rain" : Tactic.new("Make It Rain", "Perform special shamanic dances to make metal projectiles fall on your enemies", "PRO", "CON", [TacticHints.HINT_RANGED, TacticHints.HINT_AOE, TacticHints.HINT_POOR_ARMOR]),
	"Superior Siege Engine" : Tactic.new("Superior Siege Engine", "Use a trebuchet to launch inferior catapults", "PRO", "CON", [TacticHints.HINT_RANGED]),
	"Hot Potato" : Tactic.new("Hot Potato", "Wait that's not a potato, that's a.. *BOOM*", "PRO", "CON", [TacticHints.HINT_EXPLOSIVE]),
	"Holy Hand Grenade" : Tactic.new("Holy Hand Grenade", "Thou shalt count to three, no more no less", "PRO", "CON", [TacticHints.HINT_EXPLOSIVE, TacticHints.HINT_AOE]),
	"Pack Tactics" : Tactic.new("Pack Tactics", "Attack as a group, you get advantage on your attack (whatever that means)..", "PRO", "CON", [TacticHints.HINT_SMART, TacticHints.HINT_GROUPED, TacticHints.HINT_WEAK]),
};

#var tactics2 : Dictionary = {
#	"The Beeg Bonk" : Tactic.new("The Beeg Bonk", "Hit them with the largest sticks we can find", "Good against poorly armored fighters", "Bad against advanced strategies and even larger sticks", [TacticHints.HINT_LARGE_SOLDIERS, TacticHints.HINT_DUMB]),
#	"Gorilla Tactics" : Tactic.new("Gorilla Tactics", "Send in a troop of stampeding gorillas", "Good against ranged attacks", "Scared of horses", [TacticHints.HINT_LARGE_SOLDIERS ]),
#	"Omae Wa Mou Shindeiru" : Tactic.new("Omae Wa Mou Shindeiru", "Teleport behind their backs, 'Nothing personnel kid'", "Good against ranged units", "Bad against countermeasures", [TacticHints.HINT_STEALTHY, TacticHints.HINT_SURPRISE]),
#	"Faint Attack" : Tactic.new("Faint Attack", "Pretend to faint to draw in their forces, then attack!", "Good against less experienced soldiers", "Bad against disciplined foes", [TacticHints.HINT_SMART, TacticHints.HINT_SURPRISE]),
#	"Platypus Defense" : Tactic.new("Platypus Defense", "Stab attackers with poisonous spurs", "Good against poorly armored fighters", "Bad against heavily armored opponents", [TacticHints.HINT_DEFENSIVE, TacticHints.HINT_WEAK]),
#	"Tank You Very Much" : Tactic.new("Tank You Very Much", "Steal enemy tanks and attack with them", "Effective against enemies with tanks", "Ineffective against tankless foes", [TacticHints.HINT_STEALTHY]),
#	"Carpet Bomb" : Tactic.new("Carpet Bomb", "Cover them with the finest carpets", "Effective against units that are hiding", "Less effective against stronger enemies", [TacticHints.HINT_AOE, TacticHints.HINT_WEAK, TacticHints.HINT_RANGED]),
#	"Armadillo Rollout" : Tactic.new("Armadillo Rollout", "Roll armadillos at them and aim for a STRIKE!", "Effective at dealing area damage", "Less effective against agile foes", [TacticHints.HINT_POWERFUL_ATTACK, TacticHints.HINT_AOE]),
#	"Walk The Flank" : Tactic.new("Walk The Flank", "Put on eyepatches and attack from both sides me-mateys!", "Effective for surprising enemies", "Less effective against well-prepared foes", [TacticHints.HINT_SURPRISE]),
#	"Chaaaaaaarge!" : Tactic.new("Chaaaaaaarge!", "Send in the cavalry!", "Effective for powerful charges", "Less effective against entrenched enemies", [TacticHints.HINT_CAVALRY, TacticHints.HINT_POWERFUL_ATTACK]),
#	"Build A Wall" : Tactic.new("Build A Wall", "Build the largest wall, don't worry someone else will pay for it", "Effective for defensive purposes", "Less effective if enemy bypasses it", [TacticHints.HINT_DEFENSIVE]),
#	"The Wolf's Head" : Tactic.new("The Wolf's Head", "Use a large battering ram to smash through enemy forces", "Strong against defensive forces", "Less effective against mobile foes", [TacticHints.HINT_POWERFUL_ATTACK]),
#	"Lightning Rush" : Tactic.new("Lightning Rush", "Rush in with red anthropomorphic tanks, Ka-Chow!", "Effective for rapid assaults", "Less effective against well-prepared defenses", [TacticHints.HINT_POWERFUL_ATTACK, TacticHints.HINT_DEFENSIVE]),
#	"Birthday Surprise" : Tactic.new("Birthday Surprise", "Gift them a nice wooden horse filled with specially trained combat horses", "Effective for surprise cavalry attacks", "Less effective if the wooden horse is detected early", [TacticHints.HINT_CAVALRY, TacticHints.HINT_SURPRISE, TacticHints.HINT_SMART]),
#	"Pyramid Scheme" : Tactic.new("Pyramid Scheme", "Invite them to join", "Effective for deceiving enemies", "Less effective if the scheme is uncovered", [TacticHints.HINT_DEFENSIVE]),
#	"Kiting" : Tactic.new("Kiting", "Uses kites to get the high ground for your archers", "Effective for gaining advantageous positions", "Less effective if kites are destroyed", [TacticHints.HINT_RANGED, TacticHints.HINT_STEALTHY]),
#	"Make It Rain" : Tactic.new("Make It Rain", "Perform special shamanic dances to make metal projectiles fall on your enemies", "Effective for raining down projectiles", "Less effective against heavily armored foes", [TacticHints.HINT_RANGED, TacticHints.HINT_AOE, TacticHints.HINT_POOR_ARMOR]),
#	"Superior Siege Engine" : Tactic.new("Superior Siege Engine", "Use a trebuchet to launch inferior catapults", "Effective for ranged siege attacks", "Less effective if the enemy has strong defenses", [TacticHints.HINT_RANGED]),
#	"Hot Potato" : Tactic.new("Hot Potato", "Wait that's not a potato, that's a.. *BOOM*", "Effective for surprise explosive attacks", "Less effective against foes with blast resistance", [TacticHints.HINT_EXPLOSIVE]),
#	"Holy Hand Grenade" : Tactic.new("Holy Hand Grenade", "Thou shalt count to three, no more no less", "Effective for area explosive attacks", "Less effective against foes with explosive countermeasures", [TacticHints.HINT_EXPLOSIVE, TacticHints.HINT_AOE]),
#	"Pack Tactics" : Tactic.new("Pack Tactics", "Attack as a group, you get advantage on your attack (whatever that means)..", "Effective for coordinated group assaults", "Less effective if the group is separated or disrupted", [TacticHints.HINT_SMART, TacticHints.HINT_GROUPED, TacticHints.HINT_WEAK]),
#}

# Scores from -3 to 3. Determines how much stronger the first tactic is over the second.
# Keys are named tacticname-tacticname, and each pair only appears once.
var tactics_score: Dictionary = {
	"The Beeg Bonk-Gorilla Tactics" : 0,
	"Build A Wall-The Wolf's Head" : -3,
	"Make It Rain-Hot Potato" : 0,
	"Carpet Bomb-Chaaaaaaarge!" : -2,
	"Omae Wa Mou Shindeiru-Chaaaaaaarge!" : 0,
	"Faint Attack-Holy Hand Grenade" : -2,
	"Superior Siege Engine-The Beeg Bonk" : 1,
	"Make It Rain-Kiting" : 3,
	"Carpet Bomb-Tank You Very Much" : 2,
	"Holy Hand Grenade-Lightning Rush" : 1,
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

func get_random_tactic() -> Tactic:
	var key:String = tactics.keys()[rng.randi() % tactics.size()];
	return tactics[key];

func get_random_tactic_to_counter(tactic: Tactic, min_score: int) -> Tactic:
	# loop through tactic scores to find ones that have >= min_score, then randomly pick one of them
	return null
