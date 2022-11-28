tool
extends ImmediateGeometry

const NUMBER_OF_WAVES = 10;

export(float, 0, 1) var amplitude = 1.0 setget setHeight
export(float, 10, 100) var wavelength = 10.0 setget setWavelength
export(float, 0, 1) var steepness = 0.1 setget set_steepness
export(Vector2) var windDirection = Vector2(1, 0) setget setWindDirection
export(float, 0, 1) var wind_align = 0.0 setget set_wind_align

var res = 124.0
var setable = false

var counter = 0.5
var cube_cam = preload("res://Ocean/Seagull.tscn")
var cube_cam_inst;

var waves = []
var waves_in_tex = ImageTexture.new()

func _ready():
	
	for j in range(res):
		var y = j/res - 0.5
		var n_y = (j+1)/res - 0.5
		begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		for i in range(res):
			var x = i/res - 0.5
			
			#var new_x = x 
			#var new_y = y
			
			add_vertex(Vector3(x*2, 0, -y*2))
			
			#new_y = n_y - translation.z
			add_vertex(Vector3(x*2, 0, -n_y*2))
		end()
	begin(Mesh.PRIMITIVE_POINTS)
	add_vertex(-Vector3(1,1,1)*pow(2,32))
	add_vertex(Vector3(1,1,1)*pow(2,32))
	end()
	
	waves_in_tex = ImageTexture.new()
	update_waves()
	
	cube_cam_inst = cube_cam.instance()
	add_child(cube_cam_inst)


func _process(delta):
	counter -= delta
	if counter <= 0:
		var cube_map = cube_cam_inst.update_cube_map()
		material_override.set_shader_param('environment', cube_map)
		counter = INF
	
	material_override.set_shader_param('time_offset', OS.get_ticks_msec()/1000.0 * 10)
	setable = true

func setWavelength(value):
	wavelength = value
	if setable:
		update_waves()

func set_steepness(value):
	steepness = value
	if setable:
		update_waves()

func setHeight(value):
	amplitude = value
	if setable:
		update_waves()

func setWindDirection(value):
	windDirection = value
	if setable:
		update_waves()

func set_wind_align(value):
	wind_align = value
	if setable:
		update_waves()

func get_displace(position):
	var dispPosition = Vector3.ZERO
	
	var hz
	var ht
	var steep
	var dir
	for i in waves:
		ht = i['amplitude']
		if ht == 0.0: continue
		
		dir = Vector2(i['wind_directionX'], i['wind_directionY'])
		hz = i['frequency']
		steep = i['steepness'] / (hz*ht)
		
		var pos2D = Vector2(position.x, position.z)
		
		var W = pos2D.dot(hz*dir) + hz * 2 * OS.get_ticks_msec()/1000.0 * 10
		dispPosition = Vector3(position.x + dir.x * cos(W) * ht * steep, 
					ht * sin(W), position.z + dir.y * cos(W) * ht * steep)
	return dispPosition;

func update_waves():
	seed(0)
	#var amp_length_ratio = amplitude / wavelength
	waves.clear()
	for _i in range(NUMBER_OF_WAVES):
		var _Wavelength = rand_range(wavelength/2.0, wavelength*2.0)
		var _windDirection = windDirection.rotated(rand_range(-PI, PI)*(1-wind_align))
		
		waves.append({
			'amplitude': amplitude / wavelength * _Wavelength,
			'steepness': rand_range(0, steepness),
			'wind_directionX': _windDirection.x,
			'wind_directionY': _windDirection.y,
			'frequency': sqrt(0.098 * TAU/_Wavelength)
		})
	#Put Waves in Texture..
	var img = Image.new()
	img.create(5, NUMBER_OF_WAVES, false, Image.FORMAT_RF)
	img.lock()
	for i in range(NUMBER_OF_WAVES):
		img.set_pixel(0, i, Color(waves[i]['amplitude'], 0,0,0))
		img.set_pixel(1, i, Color(waves[i]['steepness'], 0,0,0))
		img.set_pixel(2, i, Color(waves[i]['wind_directionX'], 0,0,0))
		img.set_pixel(3, i, Color(waves[i]['wind_directionY'], 0,0,0))
		img.set_pixel(4, i, Color(waves[i]['frequency'], 0,0,0))
	img.unlock()
	waves_in_tex.create_from_image(img, 0)
	material_override.set_shader_param('waves', waves_in_tex)
