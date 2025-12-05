extends MeshInstance3D
var speed = -0.2



func _process(delta):
	get_surface_override_material(0).uv1_offset.y += delta * speed
	if get_surface_override_material(0).uv1_offset.y >=1:
		get_surface_override_material(0).uv1_offset.y = 0
