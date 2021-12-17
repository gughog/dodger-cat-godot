extends Node

# allow us to choose the Mob scene we want to instance
export(PackedScene) var Mob;
var score;

func _ready() -> void:
	randomize();
	$MenuMusic.play();
	# new_game();

func new_game() -> void:
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();

	$MenuMusic.stop();
	$Music.play();

	$HUD.update_score(score);
	$HUD.show_message("Get ready...");

func game_over() -> void:
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();
	
	$Music.stop();
	$GameoverSound.play();
	
	yield(get_tree().create_timer(1.5), "timeout");
	$MenuMusic.play();
	# Deletes all mobs in the "mobs" group
	# get_tree().call_group("mobs", "queue_free");

func _on_ScoreTimer_timeout() -> void:
	score += 1;
	$HUD.update_score(score);

func _on_StartTimer_timeout() -> void:
	$MobTimer.start();
	$ScoreTimer.start();

# Will handle mob spawn
func _on_MobTimer_timeout() -> void:
	# note: why using PI? "In functions requiring angles, GDScript uses radians, not degrees."
	# choosing a random location on path2D
	$MobPath/MobSpawnLocation.offset = randi();
	# creating a mob instance and add it to the scene
	var mob = Mob.instance();
	add_child(mob);
	# setting the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2;
	# setting the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position;
	# adding randomness to the direction
	direction += rand_range(-PI / 4, PI / 4);
	mob.rotation = direction;
	# setting the velocity (speed and direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0);
	mob.linear_velocity = mob.linear_velocity.rotated(direction);
	pass;
