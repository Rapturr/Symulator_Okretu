extends Panel

onready var waves = $"../Waves"

var windDir = Vector2()

func _process(_delta):
	for i in $VBP.get_children():
		match i.name:
			"WAVEHEIGHT": waves.setHeight($VBP/WAVEHEIGHT/HSlider.value)
			"DISTANCE": waves.setWavelength($VBP/DISTANCE/HSlider.value)
			"ST": waves.set_steepness($VBP/ST/HSlider.value)
			"WINDX": windDir.x = $VBP/WINDX/HSlider.value
			"WINDY": windDir.y = $VBP/WINDY/HSlider.value
	waves.setWindDirection(windDir)
