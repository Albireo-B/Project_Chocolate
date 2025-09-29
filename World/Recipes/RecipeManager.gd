class_name RecipeManager
extends Node3D

@export var all_ingredients: Array[Ingredient]
@export var all_recipes: Array[Recipe]

@export var unlocked_ingredients: Array[Ingredient]
@export var unlocked_recipes: Array[Recipe]
@export var ingredient_spawner: Node3D

func _ready():
	SignalManager.recipe_ended.connect(_on_cauldron_recipe_ended)
	SignalManager.ingredient_unlocked.connect(_on_ingredient_unlocked)
	call_deferred("init")

func init():
	SignalManager.shop_ingredients_updated.emit(all_ingredients.filter(func(ingredient): return !unlocked_ingredients.has(ingredient)))

func update_recipes():
	unlocked_recipes.clear()
	var ingredient_types: Array[Ingredient.IngredientType]
	for ingredient in unlocked_ingredients:
		ingredient_types.append(ingredient.ingredient_type)
	for recipe in all_recipes:
		if recipe.ingredients.all(func(recipe_ingredient): return ingredient_types.has(recipe_ingredient)):
			unlocked_recipes.append(recipe)
			
func _on_cauldron_recipe_ended(ingredients: Array[Ingredient.IngredientType]):
	var recipe_index: int = -1
	for recipe in unlocked_recipes:
		recipe.ingredients.sort()
		ingredients.sort()
		if recipe.ingredients == ingredients:
			recipe_index = unlocked_recipes.find(recipe)
			print("Found recipe : " + recipe.name + " with  index : " + str(recipe_index))
			SignalManager.recipe_successful.emit()
			break
			
	if recipe_index == -1:
		#TODO : Recipe done
		print("No recipe found")
	
	for ingredient_used in ingredients:
		ingredient_spawner.spawn_ingredient(all_ingredients.filter(func(ingredient): return ingredient.ingredient_type == ingredient_used)[0])

func _on_ingredient_unlocked(ingredient: Ingredient):
	if unlocked_ingredients.has(ingredient):
		return
		
	unlock_ingredient(ingredient)
	
func unlock_ingredient(ingredient: Ingredient):
	unlocked_ingredients.append(ingredient)
	update_recipes()
	ingredient_spawner.spawn_ingredient(ingredient)
	SignalManager.shop_ingredients_updated.emit(all_ingredients.filter(func(ingredient): return !unlocked_ingredients.has(ingredient)))
