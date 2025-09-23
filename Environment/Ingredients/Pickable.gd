extends Node3D

@export var outline_material: ShaderMaterial	
var mesh_instance: MeshInstance3D

func _ready():
	mesh_instance = get_node(get_meta("mesh_instance"))
	
func _on_body_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("clicking on " + IngredientResource.Ingredient.keys()[get_meta("ingredient_index")])

func _on_body_mouse_entered():
	if !outline_material or !mesh_instance:
		return
	
	mesh_instance.material_overlay = outline_material

func _on_body_mouse_exited():
	if !outline_material or !mesh_instance:
		return
	
	mesh_instance.material_overlay = null
