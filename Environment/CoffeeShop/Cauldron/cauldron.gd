extends Node3D

signal recipe_ended(Array)

@export var outline_material: ShaderMaterial	
@export var mesh_instance: MeshInstance3D	
@export var launcher_mesh_instance: MeshInstance3D	
# Dictionary[int, Array[IngredientResource.Ingredient]]
@export var recipes: Dictionary

var ingredients: Array[IngredientResource.Ingredient]

func _on_mouse_entered():
	if mesh_instance and outline_material:
		mesh_instance.material_overlay = outline_material
		set_meta("on_target", true)

func _on_mouse_exited():
	if mesh_instance and outline_material:
		mesh_instance.material_overlay = null
		set_meta("on_target", false)
		
func add_ingredient(ingredient):
	ingredients.append(ingredient)

func launch_recipe():
	if ingredients.is_empty():
		return
	
	var recipe_index = recipes.values().find(ingredients)
	if recipe_index != -1:
		#TODO : Recipe done
		print("Found recipe with index : " + str(recipe_index))
		
	recipe_ended.emit(ingredients)
	ingredients.clear()

func _on_launcher_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		launch_recipe()

func _on_launcher_mouse_entered():
	if launcher_mesh_instance and outline_material:
		launcher_mesh_instance.material_overlay = outline_material

func _on_launcher_mouse_exited():
	if launcher_mesh_instance and outline_material:
		launcher_mesh_instance.material_overlay = null
