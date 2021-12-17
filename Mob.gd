extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.playing = true;
	# Array with all available animations for that Mob Scene
	var mob_types = $AnimatedSprite.frames.get_animation_names();
	# Get a random animation from available types
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()];

# on mob screen exit, maybe it will destrou the mob instance
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free();
