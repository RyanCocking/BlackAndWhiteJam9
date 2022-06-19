extends Area2D

# Define custom signal
signal hit

export var SPEED = 400
var velocity = Vector2()

# ! horrible coupling
onready var arena = get_tree().get_root().get_node("Main/Background/Arena")
onready var arena_rect = arena.get_rect()

func start(pos):
    position = pos
    # target = pos  # Initial target is the start position
    show()
    $CollisionShape2D.disabled = false


func movement_8_way():
    if Input.is_physical_key_pressed(KEY_D):
        velocity.x += 1
    if Input.is_physical_key_pressed(KEY_A):
        velocity.x -= 1
    if Input.is_physical_key_pressed(KEY_S):
        velocity.y += 1
    if Input.is_physical_key_pressed(KEY_W):
        velocity.y -= 1
    velocity = velocity.normalized() * SPEED

func get_input():
    movement_8_way()

func wall_collide():
    # ! probably better to use collisions or overlaps here
    self.position.x = clamp(self.position.x, arena_rect.position.x, arena_rect.end.x)
    self.position.y = clamp(self.position.y, arena_rect.position.y, arena_rect.end.y)

func update_position(delta):
    # Clamp the position and prevent it from exceeding the edge of the screen.
    # 'delta' ensures that the position is consistent if the frame rate changes.
    self.position += velocity * delta
    wall_collide()
    look_at(get_global_mouse_position())


# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame
func _process(delta):

    velocity = Vector2()
    get_input()
    update_position(delta)


func _on_Player_body_entered(body):
    hide()  # player disappears after being hit
    emit_signal("hit")
    # Disable the collision shape when it is safe to do so ('deferred').
    # Prevents hits from triggering many times per collision
    $CollisionShape2D.set_deferred("disabled", true)
