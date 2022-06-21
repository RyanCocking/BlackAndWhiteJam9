extends Node

export (PackedScene) var Mob  # Remember to load Mob.tscn in the inspector tab!
var score


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()  # Seed the RNG
    #new_game()  # Start the game


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
    $Music.stop()
    $DeathSound.play()
    $ScoreTimer.stop()
    $MobTimer.stop()
    $HUD.show_game_over()
    get_tree().call_group("mobs", "queue_free")  # Delete mobs when game over


func new_game():
    score = 0
    $Player.start($StartPosition.position)
    $StartTimer.start()
    $HUD.update_score(score)
    $HUD.show_message("Get Ready")
    $Music.play()


func _on_ScoreTimer_timeout():
    score += 1
    $HUD.update_score(score)


func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.offset = randi()
    # Create a Mob instance and add it to the scene, which may be done in several
    # ways:
    # 1. Load scene explicitly
    # Use 'load' instead of 'preload' if the path is unknown at compile time.
    # var mob = preload("res://Mob.tscn").instance()
    #
    # 2. Load PackedScene (see header of script)
    # Requires loading of Mob.tscn by using the inspector panel of the 'Main'
    # node, or 'Mob' will be Null and instancing will give an error.
    var mob = Mob.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction += rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Set the velocity (speed & direction).
    mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
    mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_StartTimer_timeout():
    $MobTimer.start()
    $ScoreTimer.start()
