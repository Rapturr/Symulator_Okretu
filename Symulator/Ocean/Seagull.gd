tool
extends Spatial

func _ready():
	for i in get_children():
		i.size = Vector2(256, 256)
		i.own_world = true

func update_seagull():
	var cubeSides = {
		'Front': CubeMap.SIDE_FRONT,
		'Back': CubeMap.SIDE_BACK,
		'Left': CubeMap.SIDE_LEFT,
		'Right': CubeMap.SIDE_RIGHT,
		'Top': CubeMap.SIDE_TOP,
		'Bottom': CubeMap.SIDE_BOTTOM
	}
	var seagull = CubeMap.new()
	
	for i in get_children():
		if i.name in cubeSides:
			var img = Image.new()
			img.copy_from(i.get_texture().get_data())
			seagull.set_side(cubeSides[i.name], img)
	
	return seagull
