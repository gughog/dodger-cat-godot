# Init
extends Area2D;

signal hit;

# Variables
export var speed = 300; # Player's speed
var screen_size; # Game window size
var last_y_direction = "bottom";

# Constants
const ARROW_RIGHT = "ui_right";
const ARROW_LEFT = "ui_left";
const ARROW_UP = "ui_up";
const ARROW_DOWN = "ui_down";

const WALK = {
	"UP": "up",
	"DOWN": "down",
	"HORIZONTAL": "horizontal",
	"IDLE": "idle",
	"IDLE_TOP": "idle_top",
	"IDLE_HORIZONTAL": "idle_horizontal"
};

const SIGNAL_HIT = "hit";

# Override Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size;
	# hide();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Player's movement vector
	var velocity = Vector2.ZERO;

	# Variables
	var is_idle = velocity.x == 0 and velocity.y == 0;
	
	if Input.is_action_pressed(ARROW_UP):
		last_y_direction = "top";
		velocity.y -= 1;
	if Input.is_action_pressed(ARROW_DOWN):
		last_y_direction = "bottom";
		velocity.y += 1;
	if Input.is_action_pressed(ARROW_LEFT):
		last_y_direction = "left";
		velocity.x -= 1;
	if Input.is_action_pressed(ARROW_RIGHT):
		last_y_direction = "right";
		velocity.x += 1;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		
		# "$" is the shorthand for "get_node()",
		# so fully it would be: "get_node("AnimatedSprite2D").play()"
		$AnimatedSprite.play();
	if is_idle:
		$AnimatedSprite.play();
	else:
		$AnimatedSprite.stop();
		last_y_direction = "bottom";

	# This is to avoid player to go out of the screen, it clamps
	position += velocity * delta;
	position.x = clamp(position.x, 0, screen_size.x);
	position.y = clamp(position.y, 0, screen_size.y);
	
	# Choosing the right sprite:
	# Horizontal
	if velocity.x != 0:
		$AnimatedSprite.animation = WALK.HORIZONTAL;
		$AnimatedSprite.flip_v = false;
		$AnimatedSprite.flip_h = velocity.x > 0;
	elif velocity.y < 0:
		$AnimatedSprite.animation = WALK.UP;
	elif velocity.y > 0:
		$AnimatedSprite.animation = WALK.DOWN;
	# hadling idle animation, when player is not moving
	elif is_idle:
		if last_y_direction == "top":
			$AnimatedSprite.animation = WALK.IDLE_TOP;
		elif last_y_direction == "left":
			$AnimatedSprite.animation = WALK.IDLE_HORIZONTAL;
			$AnimatedSprite.flip_h = false;
		elif last_y_direction == "right":
			$AnimatedSprite.animation = WALK.IDLE_HORIZONTAL;
			$AnimatedSprite.flip_h = true;
		else:
			$AnimatedSprite.animation = WALK.IDLE;

func _on_Player_body_entered(body: Node) -> void:
	hide();
	emit_signal(SIGNAL_HIT);
	$CollisionShape2D.set_deferred("disabled", true);

# Regular Functions
func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
