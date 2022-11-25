tool
extends Spatial

func ready():
	for i in get_children():
		i.size = Vector2(256, 256)
		i.own_world = true

func update_cube_map():
	var images = {
		'Front': CubeMap.SIDE_FRONT,
		'Rear': CubeMap.SIDE_BACK,
		'Left': CubeMap.SIDE_LEFT,
		'Right': CubeMap.SIDE_RIGHT,
		'Top': CubeMap.SIDE_TOP,
		'Bottom': CubeMap.SIDE_BOTTOM
	}
	var cube_map = CubeMap.new()
	
	for i in get_children():
		if i.name in images:
			var img = Image.new()
			img.copy_from(i.get_texture().get_data())
			cube_map.set_side(images[i.name], img)
	
	return cube_map
