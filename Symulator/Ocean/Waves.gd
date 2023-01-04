tool
extends ImmediateGeometry

const WAVESNUM = 10;

export(float, 0, 1) var waveheight = 1.0 setget setHeight
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
var waveTexture = ImageTexture.new()

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
	
	waveTexture = ImageTexture.new()
	updateWaves()
	
	cube_cam_inst = cube_cam.instance()
	add_child(cube_cam_inst)


func _process(delta):
	counter -= delta
	if counter <= 0:
		var cube_map = cube_cam_inst.update_cube_map()
		material_override.set_shader_param('world', cube_map)
		counter = INF
	
	material_override.set_shader_param('time_offset', OS.get_ticks_msec()/1000.0 * 10)
	setable = true

func setWavelength(value):
	wavelength = value
	if setable:
		updateWaves()

func set_steepness(value):
	steepness = value
	if setable:
		updateWaves()

func setHeight(value):
	waveheight = value
	if setable:
		updateWaves()

func setWindDirection(value):
	windDirection = value
	if setable:
		updateWaves()

func set_wind_align(value):
	wind_align = value
	if setable:
		updateWaves()

func movedByWave(position):
	var dispPosition = Vector3.ZERO
	
	var hz
	var ht
	var steep
	var dir
	for i in waves:
		ht = i['waveheight']
		if ht == 0.0: continue
		
		dir = Vector2(i['wind_directionX'], i['wind_directionY'])
		hz = i['frequency']
		steep = i['steepness'] / (hz*ht)
		
		var pos2D = Vector2(position.x, position.z)
		
		var W = pos2D.dot(hz*dir) + hz * 2 * OS.get_ticks_msec()/1000.0 * 10
		dispPosition = Vector3(position.x + dir.x * cos(W) * ht * steep, 
					ht * sin(W), position.z + dir.y * cos(W) * ht * steep)
	return dispPosition;

func updateWaves():
	seed(0)
	waves.clear()
	for _i in range(WAVESNUM):
		var randWavelen = rand_range(wavelength/2.0, wavelength*2.0)
		var rotWindDir = windDirection.rotated(rand_range(-PI, PI)*(1-wind_align))
		
		waves.append({
			'waveheight': waveheight / wavelength * randWavelen,
			'steepness': rand_range(0, steepness),
			'wind_directionX': rotWindDir.x,
			'wind_directionY': rotWindDir.y,
			'frequency': sqrt(0.098 * TAU/randWavelen)
		})
	var image = Image.new()
	image.create(5, WAVESNUM, false, Image.FORMAT_RF)
	image.lock()
	for i in range(WAVESNUM):
		image.set_pixel(0, i, Color(waves[i]['waveheight'], 0,0,0))
		image.set_pixel(1, i, Color(waves[i]['steepness'], 0,0,0))
		image.set_pixel(2, i, Color(waves[i]['wind_directionX'], 0,0,0))
		image.set_pixel(3, i, Color(waves[i]['wind_directionY'], 0,0,0))
		image.set_pixel(4, i, Color(waves[i]['frequency'], 0,0,0))
	image.unlock()
	waveTexture.create_from_image(image, 0)
	material_override.set_shader_param('waves', waveTexture)
