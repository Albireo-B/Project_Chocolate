extends Node3D

@export var base_ingredient: PackedScene
@export var ingredient_resources: Array[IngredientResource]
@export var spawn_points_holder: Node3D

func _ready():
	spawn_ingredient(IngredientResource.Ingredient.PouletDePouletPointFR)
	spawn_ingredient(IngredientResource.Ingredient.DindeRotieDeHubert)
	
func spawn_ingredient(ingredient_type: IngredientResource.Ingredient):
	var ingredient_resource = find_ingredient_resource(ingredient_type)
	var ingredient_spawn = find_ingredient_spawn(ingredient_type)
	if ingredient_resource && ingredient_spawn:
		var ingredient_objet = base_ingredient.instantiate()
		ingredient_objet.get_node(ingredient_objet.get_meta("mesh_instance")).mesh = ingredient_resource.mesh
		add_child(ingredient_objet)
		ingredient_objet.global_transform.origin = ingredient_spawn

func find_ingredient_resource(ingredient: IngredientResource.Ingredient):
	for resource in ingredient_resources:
		if resource.ingredient == ingredient:
			return resource
	return null
	
func find_ingredient_spawn(ingredient: IngredientResource.Ingredient):
	for spawn in spawn_points_holder.get_children():
		if spawn.get_meta("ingredient_index") == ingredient:
			return spawn.position
	return null
