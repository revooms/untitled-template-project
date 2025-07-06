extends Node3D

@export var worldsize: Vector2 = Vector2(4,4)

@onready var body: CSGBox3D = $Ground/Body
@onready var body_collision: CollisionShape3D = $Ground/Body/StaticBody3D/CollisionShape3D
@onready var boundaries: CollisionShape3D = $Boundaries/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#EventHub.worldsizechanged.connect(_on_worldsizechanged)
	change_world_size(worldsize)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_world_size(newsize: Vector2) -> void:
	#var oldsize = worldsize
	#var oldsize = Vector2(body.size.x, body.size.z)
	worldsize = newsize
	resize_ground_and_boundaries()
	#EventHub.emit_signal("worldsizechanged", oldsize, newsize)

func resize_ground_and_boundaries() -> void:
	# Resize ground
	body.size = Vector3(worldsize.x, 1.0, worldsize.y)
	# Resize collisionshape
	body_collision.shape.size = Vector3(worldsize.x, 1.0, worldsize.y)
	# Resize boundaries area
	boundaries.shape.size = Vector3(worldsize.x, 10.0, worldsize.y)

#func _on_worldsizechanged(old, new) -> void:
	#Logger.out(self, "From %s to %s" % [old,new])
