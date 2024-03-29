extends RigidBody

onready var waves = get_parent().get_parent().get_node('Waves')

const waterDrag = 0.99
const waterDragAng = 0.5

func _physics_process(_delta):
	var positionOrigin = get_global_transform().origin
	var world_coord_offset = positionOrigin - get_parent().translation
	
	get_parent().add_force(Vector3.DOWN * 9.8, world_coord_offset)
	
	var disp = waves.movedByWave(positionOrigin)
	var waveHeight = disp.y
	
	if positionOrigin.y < waveHeight:
		var buoyancy = clamp((waveHeight - positionOrigin.y), 0, 1)
		get_parent().add_force(Vector3(0, 9.8 * buoyancy , 0), world_coord_offset)
		get_parent().add_central_force(Vector3(buoyancy * -get_parent().linear_velocity * waterDrag ))
		get_parent().add_torque(buoyancy * -get_parent().angular_velocity * waterDragAng )
