extends Node2D

var t1:Tactic;
var t2:Tactic;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Neg3.pressed.connect(Callable(self, "select_score").bind(-3))
	$Neg2.pressed.connect(Callable(self, "select_score").bind(-2))
	$Neg1.pressed.connect(Callable(self, "select_score").bind(-1))
	$Zero.pressed.connect(Callable(self, "select_score").bind(0))
	$Plus1.pressed.connect(Callable(self, "select_score").bind(1))
	$Plus2.pressed.connect(Callable(self, "select_score").bind(2))
	$Plus3.pressed.connect(Callable(self, "select_score").bind(3))
	gen_next()

func select_score(score:int):
	# print message to copy into code
	#print("\t\"" + t1.name_ + "-" + t2.name_ + "\" : " + str(score) + ",");
	# insert into map so we don't pick again.
	Global.tactics_score[t1.name_ + "-" + t2.name_] = score;
	gen_next()

func gen_next():
	while true:
		t1 = Global.get_random_tactic()
		t2 = Global.get_random_tactic()
		
		if (t1.name_ == t2.name_):
			continue;
		if (Global.tactics_score.has(t1.name_ + "-" + t2.name_)):
			continue;
		if (Global.tactics_score.has(t2.name_ + "-" + t1.name_)):
			continue;
		break;
	$Label.text = t1.name_ + " vs " + t2.name_
	$Label2.text = t1.desc_
	$Label4.text = t1.pro_
	$Label6.text = t1.con_
	$Label3.text = t2.desc_
	$Label5.text = t2.pro_
	$Label7.text = t2.con_
