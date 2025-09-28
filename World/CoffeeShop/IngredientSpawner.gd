extends Node3D

@export var base_ingredient: PackedScene
@export var ingredient_resources: Array[Ingredient]
@export var spawn_points_holder: Node3D

func _ready():
	spawn_ingredient(Ingredient.IngredientType.PouletDePouletPointFR)
	spawn_ingredient(Ingredient.IngredientType.DindeRotieDeHubert)
	
func spawn_ingredient(ingredient_type: Ingredient.IngredientType):
	var ingredient_resource = find_ingredient_resource(ingredient_type)
	var ingredient_spawn = find_ingredient_spawn(ingredient_type)
	if !ingredient_resource or !ingredient_spawn:
		return
		
	var ingredient_objet = base_ingredient.instantiate()
	ingredient_objet.mesh_instance.mesh = ingredient_resource.mesh
		
	var object_collision_shape: CollisionShape3D = ingredient_objet.get_node(ingredient_objet.get_meta("collision_shape"))
	object_collision_shape.shape = ingredient_objet.mesh_instance.mesh.create_convex_shape()
	ingredient_objet.set_meta("ingredient_index", ingredient_resource.ingredient)
	ingredient_spawn.add_child(ingredient_objet)

func find_ingredient_resource(ingredient: Ingredient.IngredientType):
	for resource in ingredient_resources:
		if resource.ingredient == ingredient:
			return resource
	return null
	
func find_ingredient_spawn(ingredient: Ingredient.IngredientType):
	for spawn in spawn_points_holder.get_children():
		if spawn.get_meta("ingredient_index") == ingredient:
			return spawn
	return null

func _on_cauldron_recipe_ended(ingredients: Array):
	for ingredient in ingredients:
		spawn_ingredient(ingredient)
