extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get list of animation names, then randomly select the animation
	# for an enemy from this list.
	# randi returns a random unsigned 32-bit int
	# randi() % n returns a random int from 0 to n-1
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Remove enemy when it hits the screen edge
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
