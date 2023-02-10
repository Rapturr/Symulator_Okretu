tool
extends RigidBody

const MAX_SPEED = 124

var gear = 1.0

var input_vector = Vector3.ZERO

var shipDirection = Vector2(0,1)

var health = 100.0

var canTakeDamage = true

onready var damageTimer = $damageTimer

func _process(_delta):
	var waves = get_parent().get_node('Waves')
	var wind = waves.windDirection
	
	moveShip(wind)
	
	if translation.y < -10:
		shipWreck()
	
	if Input.is_action_pressed("ui_up") and gear < 1.0:
		gear += 0.01
	elif Input.is_action_pressed("ui_down") and gear > 0.8:
		gear -= 0.01

func moveShip(wind):
	var shipRotation = shipDirection.rotated(-rotation.y)
	var windSpeed = sqrt(wind.x*wind.x + wind.y*wind.y)
	var windNormal = wind.normalized()
	var shipRotationNormal = shipRotation.normalized()
	
	var checkRel = Vector2(shipRotationNormal.x - windNormal.x,shipRotationNormal.y - windNormal.y)
	var chechLen = checkRel.length()
	
	var calculatedMovement = (shipRotation * windSpeed)*gear
	if chechLen > 0.25 or chechLen < -0.25:
		add_central_force(Vector3(calculatedMovement.x, 0, calculatedMovement.y)*MAX_SPEED)
	else:
		add_central_force(Vector3(-calculatedMovement.x/3, 0, -calculatedMovement.y/3))

	input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	input_vector = input_vector.normalized()
	
	add_torque(Vector3(0,input_vector.x*2 * linear_velocity.length(),0))

func sailControl():
	if Input.is_action_pressed("ui_up") and gear < 1.0:
		gear = min(gear+0.01, 1.0)
	elif Input.is_action_pressed("ui_down") and gear > 0.8:
		gear = min(gear-0.01, 0.7)

func _on_Area_body_entered(body):
	if body.is_in_group("Rock"):
		takedamage(5 * linear_velocity.length())

func takedamage(val):
	health = max(health-val, 0)
	damageTimer.start(5)
	if health == 0:
		shipWreck()

func _on_ResetButton_pressed():
	resetShip()
	
func resetShip():
	get_tree().paused = false
	get_parent().get_node("Reset").visible = false
	linear_velocity = Vector3.ZERO
	transform.origin = Vector3.ZERO
	health = 100.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return true

func shipWreck():
	get_tree().paused = true
	get_parent().get_node("Reset").visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	return true

func _on_damageTimer_timeout():
	canTakeDamage = true
