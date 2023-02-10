extends 'res://addons/gut/test.gd'

var Ship = load("res://ship/ShipRB.gd")
var _ship = null;

func before_each():
	_ship = Ship.new()

func after_each():
	_ship.free()

func test_takedamage():
	_ship.health = 5.0
	_ship.takedamage(50)
	assert_eq(_ship.health, 0, "Poziom zdrowia powinien wynosić 0")

func test_resetShip():
	var reset = _ship.resetShip()
	assert_eq(reset, true, "funkcja zwraca true")
	assert_eq(_ship.health, 100.0, "Poziom zdrowia powinien wynosić 100")
