extends Spatial

var camera_angle = 0
var sensitivity = 0.1
var camera_change = Vector2()

var mouse_movable = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	
	if mouse_movable:
		cameraRotation()
	
	if Input.is_action_just_pressed('mouse_visible'):
		if mouse_movable:
			mouse_movable = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			mouse_movable = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative


func cameraRotation():
	if camera_change.length() > 0:
		rotate_y(deg2rad(camera_change.x * sensitivity))
		var change = camera_change.y * sensitivity
		if change + camera_angle < 20 and change + camera_angle > -50:
			$helper.rotate_x(-deg2rad(change))
			camera_angle += change
		camera_change = Vector2()
