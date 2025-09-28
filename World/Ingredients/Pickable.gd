extends StaticBody3D

@export var outline_material: ShaderMaterial	
@export var mesh_instance: MeshInstance3D	

var dragged: bool = false

func enable_outline(enable: bool):
	if not mesh_instance or not outline_material:
		return
		
	if enable:
		mesh_instance.material_overlay = outline_material
	else:
		if not dragged:
			mesh_instance.material_overlay = null

func _on_mouse_entered():
	enable_outline(true)
	
func _on_mouse_exited():
	enable_outline(false)
