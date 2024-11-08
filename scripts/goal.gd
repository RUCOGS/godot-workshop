extends Area2D
class_name Goal


signal player_reached


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached.emit()
