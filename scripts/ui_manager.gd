extends CanvasLayer
class_name UIManager

signal restart_pressed

@export var win_screen: Control
@export var win_time_label: Label
@export var overlay_ui: Control
@export var bg_music: AudioStreamPlayer
@export var win_sfx: AudioStreamPlayer

var original_bg_volume: float


func _ready() -> void:
	original_bg_volume = bg_music.volume_db


func show_win(time: float):
	win_time_label.text = "TIME: %.2f" % time
	win_screen.visible = true
	overlay_ui.visible = false
	bg_music.volume_db = original_bg_volume - 10
	win_sfx.play()


func show_overlay_ui():
	win_screen.visible = false
	overlay_ui.visible = true
	bg_music.volume_db = original_bg_volume


func _on_restart_button_pressed() -> void:
	restart_pressed.emit()
