extends HBoxContainer

export(Texture) var left_texture

func _ready():
	if left_texture:
		$LeftTexture.texture = left_texture
