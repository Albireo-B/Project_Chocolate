extends Node3D

@export var recipe_manager: RecipeManager
@export var client_base_object: PackedScene
@export var client_time_to_pos: float

var current_client_object: Node3D
var current_client_recipe: Recipe

func _ready():
	SignalManager.recipe_ended.connect(_on_cauldron_recipe_ended)
	SignalManager.recipe_successful.connect(_on_recipe_successful)
	start_new_quest()
	
func _on_recipe_successful(successful: bool):
	end_quest(successful)
	await get_tree().create_timer(client_time_to_pos).timeout
	start_new_quest()
	
func start_new_quest():
	current_client_recipe = recipe_manager.unlocked_recipes.pick_random()		
	current_client_object = client_base_object.instantiate()
	add_child(current_client_object)
	current_client_object.global_position = $ClientStartPos.global_position
	var text: String = "I want : " + current_client_recipe.name
	(current_client_object.get_node("RecipeText") as Label3D).text = text
	var tween: Tween = create_tween()
	tween.tween_property(current_client_object, "global_position", $ClientEndPos.global_position, client_time_to_pos)

func end_quest(quest_successful: bool):
	var text: String = "😎" if quest_successful else "😒"
	(current_client_object.get_node("RecipeText") as Label3D).text = text
	var tween: Tween = create_tween()
	tween.tween_property(current_client_object, "global_position", $ClientStartPos.global_position, client_time_to_pos)
	await get_tree().create_timer(client_time_to_pos).timeout
	current_client_object.queue_free()
	
func _on_cauldron_recipe_ended(ingredients: Array[Ingredient.IngredientType]):
	current_client_recipe.ingredients.sort()
	ingredients.sort()
	SignalManager.recipe_successful.emit(ingredients == current_client_recipe.ingredients)
