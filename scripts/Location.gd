class_name Location
extends Control

enum LOCATION {START, COMBAT, ORACLE, LIBRARY, UPGRADE, FORGE, MEDITATE, BOSS}
var line_texture = load("res://art/tactic 1.png")

signal moved_to_location(Location)

var location_type: LOCATION
var debate_topic: DebateQuestion
var connections: Array[Location]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate(active: bool):
	$button.disabled = !active

func init(stage: int, location_type: LOCATION, position: Vector2, active: bool, connections: Array[Location]):
	self.location_type = location_type
	if location_type == LOCATION.COMBAT:
		debate_topic = Global.get_random_debate_question(stage)
		$label.text = debate_topic.hint_
	else:
		$label.text = LOCATION.keys()[location_type]
	self.connections = connections
	self.set_position(position)
	$button.disabled = !active
	for connection in connections:
		var line = Line2D.new()
		line.add_point(Vector2.ZERO)
		line.add_point(connection.position-position)
		line.z_index = -10
		line.texture = line_texture
		line.texture_mode = Line2D.LINE_TEXTURE_TILE
		line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		add_child(line)

func _on_pressed():
	print("here")
	activate(false)
	moved_to_location.emit(self)
	for connection in connections:
		connection.activate(true)
	
