extends CanvasLayer

func _ready():
	hide()

func resume():
	print("resuming")
	hide()
	get_tree().paused = false
	
func pause():
	print("pausing")
	get_tree().paused = true
	show()

func escape():
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

# resume
func _on_button_pressed() -> void:
	resume()

# restart
func _on_button_3_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

# quit
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _process(delta):
	escape()
