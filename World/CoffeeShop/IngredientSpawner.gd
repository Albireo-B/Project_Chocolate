extends Node3D

@export var base_ingredient: PackedScene
@export var spawn_points_holder: Node3D
	
func spawn_ingredient(ingredient: Ingredient):
	var ingredient_spawn = find_ingredient_spawn(ingredient.ingredient_type)
	if !ingredient_spawn:
		return
		
	var ingredient_objet = base_ingredient.instantiate()
	ingredient_objet.mesh_instance.mesh = ingredient.mesh
		
	var object_collision_shape: CollisionShape3D = ingredient_objet.get_node(ingredient_objet.get_meta("collision_shape"))
	object_collision_shape.shape = ingredient_objet.mesh_instance.mesh.create_convex_shape()
	ingredient_objet.set_meta("ingredient_index", ingredient.ingredient_type)
	ingredient_spawn.add_child(ingredient_objet)
	
func find_ingredient_spawn(ingredient: Ingredient.IngredientType):
	for spawn in spawn_points_holder.get_children():
		if spawn.get_meta("ingredient_index") == ingredient:
			return spawn
	return null
