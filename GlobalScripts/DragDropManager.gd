extends Node3D

@export var raycast: RayCast3D
@export var camera: Camera3D
@export var drag_speed: float = 0.25
@export var return_speed: float = 0.05
@export var drop_target_holder: Node3D

var drag_plane: Plane
var dragged_object: Node3D
var returning_objects: Array[Node3D]
var drop_target: Node3D

func _ready():
	drop_target = drop_target_holder.get_node(drop_target_holder.get_meta("drop_target"))
	
func update_dragged_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var ray_direction = get_viewport().get_camera_3d().project_ray_normal(mouse_pos)
	var intersection = drag_plane.intersects_ray(ray_origin, ray_direction)
	if intersection != null:
		dragged_object.global_position = dragged_object.global_position.lerp(intersection, drag_speed)
	
func update_returning_objects():
	for object in returning_objects:
		object.global_position = object.global_position.lerp(object.get_parent_node_3d().global_position, return_speed)
		if (object.get_parent_node_3d().global_position - object.global_position).length() < 0.1:
			object.position = Vector3.ZERO
			returning_objects.erase(object)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pickable_clicked(event)
	
func _process(delta):
	if dragged_object:
		update_dragged_position()
	
	if not returning_objects.is_empty():
		update_returning_objects()
	
func pickable_clicked(event: InputEvent):
	if event.is_pressed():
		# Cast a ray to check for pickable objects		
		var mouse_ray_end =  camera.global_position + camera.project_ray_normal(event.position) * 30
		raycast.target_position =  raycast.to_local(mouse_ray_end)
		raycast.force_raycast_update()
		#DebugDraw3D.draw_sphere(mouse_ray_end, 0.3, Color.RED, 10)
		if raycast.is_colliding() && raycast.get_collider().has_meta("draggable"):
			dragged_object = raycast.get_collider()
			dragged_object.enable_outline(true)
			dragged_object.dragged = true
			if returning_objects.has(dragged_object):
				returning_objects.erase(dragged_object)
			var camera_forward = -camera.global_transform.basis.z.normalized()
			drag_plane = Plane(camera_forward, drop_target.global_position)
	
	if event.is_released() && dragged_object:
		if drop_target.get_meta("on_target"):
			drop_target.add_ingredient(dragged_object.get_meta("ingredient_index") as IngredientResource.Ingredient)
			if returning_objects.has(dragged_object):
				returning_objects.erase(dragged_object)
				
			dragged_object.queue_free()
			return
		
		if not returning_objects.has(dragged_object):
			returning_objects.append(dragged_object)
		
		dragged_object.dragged = false
		dragged_object.enable_outline(false)
		dragged_object = null
