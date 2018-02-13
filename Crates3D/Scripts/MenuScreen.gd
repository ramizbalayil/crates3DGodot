extends Node


func _on_play_released():
	GlobalUtils.setScene("res://Scenes/GameScene.tscn")


func _on_settings_released():
	get_tree().quit()



