extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_message(text):
	$Message.text = text;
	$Message.show();
	$MessageTimer.start();

func show_game_over():
	show_message("Aw crap, game over! :/");
	# Wait until MessageTimer has counted down (yield = receive)
	yield($MessageTimer, "timeout");

	# $Message.text = "Go kitty, Dodge 'em all!";
	# $Message.show();
	$Logo.show();

	# Make a one-shot timer and wait them to finish
	yield(get_tree().create_timer(1), "timeout");
	$StartButton.show();

func update_score(score):
	$ScoreLabel.text = str(score);

func _on_MessageTimer_timeout() -> void:
	$Message.hide();

func _on_StartButton_pressed() -> void:
	$StartButton.hide();
	emit_signal("start_game");
