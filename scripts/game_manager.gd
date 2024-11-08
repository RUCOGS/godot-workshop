extends Node
class_name GameManager


@export var ui_manager: UIManager
@export var spawn_point: Node2D
@export var player: Player
@export var time_label: Label
@export var spawn_fx: CPUParticles2D

var time = 0


func _ready() -> void:
	player.died.connect(restart)
	ui_manager.restart_pressed.connect(restart)
	restart()
	
	for goal: Goal in get_tree().get_nodes_in_group("goal"):
		goal.player_reached.connect(win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position.y > 650:
		player.kill()
	time += delta
	time_label.text = "TIME: %.2f" % time


func restart():
	player.active = true
	player.velocity = Vector2.ZERO
	player.global_position = spawn_point.global_position
	time = 0
	ui_manager.show_overlay_ui()
	spawn_fx.restart()


func win():
	player.active = false
	ui_manager.show_win(time)
