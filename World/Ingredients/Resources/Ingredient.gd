class_name Ingredient
extends Resource

enum IngredientType
{
	PouletDePouletPointFR,
	DindeRotieDeHubert
}

@export var ingredient_type : IngredientType
@export var mesh: Mesh
@export var icon: Texture2D
@export var cost: int
