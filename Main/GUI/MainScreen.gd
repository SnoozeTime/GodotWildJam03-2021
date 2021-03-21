extends TextureRect

func _ready():
	Save.load_game()

func _on_Button_pressed():
	$ButtonClick.play()
	Transition.fade_to("res://Main/Game2.tscn")


func _on_Button_mouse_entered():
	$ButtonHover.play()
