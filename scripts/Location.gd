class_name Location
extends Control

enum LOCATION {START, COMBAT, ORACLE, LIBRARY, UPGRADE, FORGE, BOSS}

signal moved_to_location(Location)

var location_type: LOCATION
var connections: Array[Location]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate(active: bool):
	$button.disabled = !active

func init(location_type: LOCATION, position: Vector2, active: bool, connections: Array[Location]):
	self.location_type = location_type
	self.connections = connections
	self.set_position(position)
	$button.disabled = !active
	for connection in connections:
		var line = Line2D.new()
		line.add_point(Vector2.ZERO)
		line.add_point(connection.position-position)
		add_child(line)

func _on_pressed():
	print("here")
	activate(false)
	moved_to_location.emit(self)
	for connection in connections:
		connection.activate(true)
	
