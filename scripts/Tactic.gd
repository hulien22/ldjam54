class_name Tactic extends Node

var name_: String
var desc_: String
var pro_: String
var con_: String
var hints_: Array


# Tactic complexity? for speech impact?
# Size? or put that into the tiles class?
# Icon?
# environment buff/debuff

func _init(name:String, desc:String, pro:String, con: String, hints:Array = []):
	name_ = name;
	desc_ = desc;
	pro_ = pro;
	con = con;
	hints_ = hints



