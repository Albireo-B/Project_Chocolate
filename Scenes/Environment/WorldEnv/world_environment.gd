extends WorldEnvironment

@export var day_cycle_duration: float = 60.0
@export var sun: DirectionalLight3D

var sky: Sky = environment.sky
var current_time: float = 0.0
	
func _process(delta):
	current_time += delta
	var time_normalized: float = fmod(current_time, day_cycle_duration) / day_cycle_duration
	# Adjust sun rotation 
	var sun_angle: float = lerpf(-90.0, 270.0, time_normalized)
	sun.rotation_degrees = Vector3(sun_angle, 0.0, 0.0)
	# Adjust brightness
	var light_energy: float = cos(deg_to_rad(sun_angle + 90))
	if light_energy < 0.0:
		sun.light_energy = 0.1
		sun.shadow_enabled = false
	else:
		sun.light_energy = lerpf(0.1, 2.0, light_energy)
		sun.shadow_enabled = true
