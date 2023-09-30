class_name Tactic extends Node

var name_: String
var desc_: String
var pro_: String
var con_: String
var hints_: Array

func _init(name:String, desc:String, pro:String, con: String, hints:Array = []):
	name_ = name;
	desc_ = desc;
	pro_ = pro;
	con = con;
	hints_ = hints



