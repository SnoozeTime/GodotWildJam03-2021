extends TextureRect

var hover_play_button = false
var hover_settings_button = false


func _ready():
	Save.load_game()

func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if hover_play_button:
			Transition.fade_to("res://Main/Game2.tscn")
		elif hover_settings_button:
			pass
			
func start_game():
	pass

func _on_PlayButton_mouse_entered():
	hover_play_button = true
	$MarginContainer/VBoxContainer/PlayButton.modulate = Color(0.0, 1.0, 0.0)

func _on_PlayButton_mouse_exited():
	hover_play_button = false
	$MarginContainer/VBoxContainer/PlayButton.modulate = Color(1.0, 1.0, 1.0)

func _on_SettingsButton_mouse_entered():
	hover_settings_button = true
	$MarginContainer/VBoxContainer/SettingsButton.modulate = Color(0.0, 1.0, 0.0)

func _on_SettingsButton_mouse_exited():
	hover_settings_button = false
	$MarginContainer/VBoxContainer/SettingsButton.modulate = Color(1.0, 1.0, 1.0)
