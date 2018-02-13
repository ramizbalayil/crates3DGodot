extends Control

onready var bar = get_node("bar")
onready var tween = get_node("Tween")
onready var timer = Timer.new()
onready var score = get_node("score")
onready var timer_text = get_node("timer")
var bar_delay_score = 30 
var bar_original_pos
var score_text = 0
onready var game_over = preload("res://Scenes/GameOver.tscn")

func _ready():
	get_node("play").hide()
	get_node("pause").show()
	get_node("menu").hide()
	get_node("pause").connect("released", self, "pause_game")
	get_node("play").connect("released", self, "pause_game")
	get_node("menu").connect("released", self, "go_to_mainmenu")
	bar_original_pos = bar.get_pos()
	timer.set_wait_time(1)
	timer.connect("timeout", self, "on_timeout")
	add_child(timer)
	timer.start()
	start_tweening()
	pass




func pause_game():
	if(!get_tree().is_paused()):
		get_node("play").show()
		get_node("pause").hide()
		get_node("menu").show()
		get_node("AnimationPlayer").play("show_menu_button")
		get_tree().set_pause(true)
	else:
		get_node("play").hide()
		get_node("pause").show()
		get_tree().set_pause(false)
		get_node("AnimationPlayer").play_backwards("show_menu_button")
		yield(get_node("AnimationPlayer"),"finished")
		get_node("menu").hide()


func start_tweening():
	tween.interpolate_property(bar, "rect/pos", bar.get_pos(), bar.get_pos()-Vector2(bar.get_size().width,0), 30.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.connect("tween_complete", self, "game_over")
	tween.start()

func reset_variables():
	tween.stop(bar, "rect/pos")
	bar.set_pos(bar_original_pos)
	start_tweening()
	set_score()

func set_score():
	score_text += bar_delay_score
	bar_delay_score = 30
	score.set_text(String(score_text))


func on_timeout():
	bar_delay_score -=1
	timer_text.set_text(String(bar_delay_score))

func game_over(object,string):
	tween.stop(bar, "rect/pos")
	timer.stop()
	var GO = game_over.instance()
	add_child(GO)
	GO.get_node("SCORE").set_text("Score: " + String(score_text))
	GO.get_node("return").show()
	GO.get_node("menu").show()
	GO.get_node("return").connect("released", self, "restart_game")
	GO.get_node("menu").connect("released", self, "go_to_mainmenu")

func restart_game():
	GlobalUtils.count = 0
	GlobalUtils.setScene("res://Scenes/GameScene.tscn")

func go_to_mainmenu():
	if(get_tree().is_paused()):
		get_tree().set_pause(false)
	GlobalUtils.setScene("res://Scenes/MenuScreen.tscn")