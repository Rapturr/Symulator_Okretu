tool
extends RigidBody

const MAX_SPEED = 124

var gear = 1.0

var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO

var currentSpeed = 0;

var shipDirection = Vector2(0,1)

func _process(_delta):
	var waves = get_parent().get_node('Waves')
	var wind = waves.windDirection
	
	input_vector = Vector3.ZERO
	#input_vector.x = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	input_vector.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	input_vector = input_vector.normalized()
	
	
	var shipRotation = shipDirection.rotated(rotation.y)
	
#	if shipRotation.x + wind.x <= shipRotation.x:
#		wind.x /= 2
#	if shipRotation.y + wind.y <= shipRotation.y:
#		wind.y /= 2
	
	if shipRotation.x < 0:
		shipRotation.x *= -1
	if shipRotation.y < 0:
		shipRotation.y *= -1
	
	
	var calculatedMovement = (shipRotation*wind+wind)*gear
	#if shipRotation.y >= wind.y and shipRotation.y <= wind.y+0.1:
	#	print("Ship rotation == Wind direction")
	
	#var forward_force = Vector2(0.2,0).rotated(-rotation.y+90)
	#forward_force += wind
	var moving_force = Vector3(calculatedMovement.x,0,calculatedMovement.y) * MAX_SPEED * Vector3(wind.x,0,wind.y)*gear
	add_central_force(Vector3(calculatedMovement.x, 0, calculatedMovement.y)*MAX_SPEED*gear)
	add_torque(Vector3(0,input_vector.x*100,0))
	if Input.is_action_just_pressed("ui_home"):
		currentSpeed = sqrt(linear_velocity.x*linear_velocity.x+linear_velocity.y*linear_velocity.y)
		print("Wiatr = ",wind.x)
		print("moving_force = ",moving_force)
		print("speed = ",currentSpeed)
		print("Ship rotation X = ",shipRotation.x)
		print("Ship rotation Y = ",shipRotation.y)
		print("Wind direction X = ",wind.x)
		print("Wind direction Y= ",wind.y)
		print("Gear= ",gear)
	
	if Input.is_action_pressed("ui_up") and gear < 1.0:
		gear += 0.01
	elif Input.is_action_pressed("ui_down") and gear > 0.11:
		gear -= 0.01
	
