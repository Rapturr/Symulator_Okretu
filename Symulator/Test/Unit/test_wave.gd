extends 'res://addons/gut/test.gd'

var wave = load("res://Ocean/Waves.gd")
var _wave = null;

func before_each():
	_wave = wave.new()

func after_each():
	_wave.free()

func test_setWavelength():
	_wave.setWavelength(150.0)
	assert_eq(_wave.wavelength, 100.0, "Parametr długości fali powinien wynosić 100")
	_wave.setWavelength(5.0)
	assert_eq(_wave.wavelength, 10.0, "Parametr długości fali powinien wynosić 10")

func test_setSteepness():
	_wave.setSteepness(3.0)
	assert_eq(_wave.steepness, 0.7, "Parametr długości fali powinien wynosić 0.7")
	_wave.setSteepness(-1.0)
	assert_eq(_wave.steepness, 0, "Parametr długości fali powinien wynosić 0")

func test_setHeight():
	_wave.setHeight(3.0)
	assert_eq(_wave.waveheight, 1.0, "Parametr długości fali powinien wynosić 1")
	_wave.setHeight(-1.0)
	assert_eq(_wave.waveheight, 0, "Parametr długości fali powinien wynosić 0")

func test_setWindDirection():
	_wave.setWindDirection(Vector2(3.0,3.0))
	assert_eq(_wave.windDirection.x, 1.0, "Parametr X kierunku wiatru powinien wynosić 1")
	assert_eq(_wave.windDirection.y, 1.0, "Parametr Y kierunku wiatru powinien wynosić 1")
	_wave.setWindDirection(Vector2(-3.0,-3.0))
	assert_eq(_wave.windDirection.x, -1.0, "Parametr X kierunku wiatru powinien wynosić -1")
	assert_eq(_wave.windDirection.x, -1.0, "Parametr Y kierunku wiatru powinien wynosić -1")
