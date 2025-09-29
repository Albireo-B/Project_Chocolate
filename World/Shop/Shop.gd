extends MarginContainer

@export var money_text: Label
@export var money_owned: int = 0
@export var ingredients_to_sell: Array[Ingredient]

func _ready():
	SignalManager.shop_ingredients_updated.connect(_on_shop_updated)
	SignalManager.recipe_successful.connect(_on_recipe_successful)
	
func _on_shop_button_pressed():
	visible = !visible
		
func _on_shop_updated(ingredients: Array[Ingredient]):
	ingredients_to_sell = ingredients
	$ItemList.clear()
	for ingredient_resource in ingredients_to_sell:
		$ItemList.add_item(Ingredient.IngredientType.keys()[ingredient_resource.ingredient_type] + ", cost : " + str(ingredient_resource.cost), ingredient_resource.icon)

func _on_recipe_successful():
	money_owned = money_owned + 1
	money_text.text = "Money : " + str(money_owned)
	
func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return
	
	if money_owned < ingredients_to_sell.get(index).cost:
		print("Not enough money")
		return
	
	money_owned -= ingredients_to_sell.get(index).cost
	money_text.text = "Money : " + str(money_owned)
	SignalManager.ingredient_unlocked.emit(ingredients_to_sell.get(index))
