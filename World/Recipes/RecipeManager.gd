class_name RecipeManager
extends Node3D

@export var all_recipes: Array[Recipe]

@export var unlocked_ingredients: Array[Ingredient.IngredientType]
@export var unlocked_recipes: Array[Recipe]
@export var ingredient_spawner: Node3D

func _ready():
	SignalManager.recipe_ended.connect(_on_cauldron_recipe_ended)
	for ingredient in unlocked_ingredients:
		ingredient_spawner.spawn_ingredient(ingredient)
		
	update_recipes()
	
func unlock_ingredient(new_ingredient: Ingredient.IngredientType):
	unlocked_ingredients.append(new_ingredient)
	update_recipes()

func update_recipes():
	unlocked_recipes.clear()
	for recipe in all_recipes:
		if recipe.ingredients.all(func(recipe_ingredient): return unlocked_ingredients.has(recipe_ingredient)):
			unlocked_recipes.append(recipe)
			
func _on_cauldron_recipe_ended(ingredients: Array):
	var recipe_index: int = -1
	for recipe in unlocked_recipes:
		if recipe.ingredients == ingredients:
			recipe_index = unlocked_recipes.find(recipe)
			print("Found recipe : " + recipe.name + " with  index : " + str(recipe_index))
			break
			
	if recipe_index == -1:
		#TODO : Recipe done
		print("No recipe found")
	
	for ingredient in ingredients:
		ingredient_spawner.spawn_ingredient(ingredient)
