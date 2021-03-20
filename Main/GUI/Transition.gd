extends CanvasLayer


var path: String = ""


func fade_to(scene_path):
	path = scene_path
	$AnimationPlayer.play("fade")

func change_scene():
	if path != "":
		get_tree().change_scene(path)
		
