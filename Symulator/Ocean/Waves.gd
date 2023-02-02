tool
extends ImmediateGeometry

const WAVESNUM = 10;

var waveheight = 1.0 setget setHeight
var wavelength = 10.0 setget setWavelength
var steepness = 0.1 setget set_steepness
var windDirection = Vector2(1, 0) setget setWindDirection

var res = 128.0
var setable = false

var counter = 0.5
var seagull = preload("res://Ocean/Seagull.tscn")
var seagull_inst;

var waves = []
var waveTexture = ImageTexture.new()

func _ready():
	for i in range(res):
		var y = i/res - 0.5
		var y2 = (i+1)/res - 0.5
		begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		for j in range(res):
			var x = j/res - 0.5
			add_vertex(Vector3(x*4, 0, -y*4))
			add_vertex(Vector3(x*4, 0, -y2*4))
		end()
	begin(Mesh.PRIMITIVE_POINTS)
	add_vertex(-Vector3(1,1,1)*pow(2,32))
	add_vertex(Vector3(1,1,1)*pow(2,32))
	end()
	
	waveTexture = ImageTexture.new()
	updateWaves()
	
	seagull_inst = seagull.instance()
	add_child(seagull_inst)
	setable = true


func _process(delta):
	counter -= delta
	if counter <= 0:
		var cube_map = seagull_inst.update_seagull()
		material_override.set_shader_param('world', cube_map)
		counter = 0.5
	
	material_override.set_shader_param('time_offset', OS.get_ticks_msec()/100.0)


func setWavelength(val):
	wavelength = val
	if setable:
		updateWaves()

func set_steepness(val):
	steepness = val
	if setable:
		updateWaves()

func setHeight(val):
	waveheight = val
	if setable:
		updateWaves()

func setWindDirection(val):
	windDirection = val
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
		var rotWindDir = windDirection.rotated(rand_range(-PI, PI))
		
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
	material_override.set_shader_param('wavesMyTex', waveTexture)
