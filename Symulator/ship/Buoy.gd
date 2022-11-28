extends RigidBody

onready var waves = get_parent().get_parent().get_node('Waves')

var depth_before_submerged = 1.0
var displacement_amount = 3.0
var last_position = Vector3()
var floater_count = 0

export var water_drag = 0.99
export var water_angular_drag = 0.5

export var enabled = true

func _ready():
	for c in get_parent().get_children():
		if c.get_script() == get_script():
			floater_count += 1

func _physics_process(_delta):
	var positionOrigin = get_global_transform().origin
	var world_coord_offset = positionOrigin - get_parent().translation
	
	get_parent().add_force(Vector3.DOWN * 9.8, world_coord_offset)
	
	var disp = waves.get_displace(positionOrigin)
	var wave_height = disp.y / 2.0
	var height = positionOrigin.y
	
	if height < wave_height:
		var buoyancy = clamp((wave_height - height) / depth_before_submerged, 0, 1)
		get_parent().add_force(Vector3(0, 9.8 * buoyancy , 0), world_coord_offset)
		get_parent().add_central_force(Vector3(buoyancy * -get_parent().linear_velocity * water_drag ))
		get_parent().add_torque(buoyancy * -get_parent().angular_velocity * water_angular_drag )
