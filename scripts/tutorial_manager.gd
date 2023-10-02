extends Node

var completed_tutorials:Array[String] = [];

# returns if this is the first time we've done this tutorial
func add_tutorial(tut_name:String) -> bool:
	if completed_tutorials.has(tut_name):
		return false;
	completed_tutorials.append(tut_name);
	return true;
