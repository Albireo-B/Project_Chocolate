class_name Ingredient
extends Resource

enum IngredientType
{
	PouletDePouletPointFR,
	DindeRotieDeHubert
}

@export var ingredient : IngredientType
@export var mesh: Mesh
