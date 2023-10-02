extends Node2D



func _on_button_1_mouse_entered():
	$AnimatedSprite2D.frame = 1;
	$AnimatedSprite2D2.frame = 1;


func _on_button_1_mouse_exited():
	$AnimatedSprite2D.frame = 0;
	$AnimatedSprite2D2.frame = 0;


func _on_button_2_mouse_entered():
	$AnimatedSprite2D.frame = 2;
	$AnimatedSprite2D2.frame = 2;


func _on_button_2_mouse_exited():
	$AnimatedSprite2D.frame = 0;
	$AnimatedSprite2D2.frame = 0;
