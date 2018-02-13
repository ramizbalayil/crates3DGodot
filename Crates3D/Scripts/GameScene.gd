
onready var crates = preload("res://Scenes/crates.scn")
onready var hex_land = preload("res://Scenes/hex_land.scn")
onready var level = 4
onready var count = 0
onready var origin_crates = Vector3(-13,6.2,-13)
onready var origin_land = Vector3(38,0,68)
onready var land_x_offset = -38
onready var land_y_offset = -68
onready var gimball = get_node("gimball")
onready var innergimball = get_node("gimball/innergimball")
onready var gui = get_node("gui")
var offset = 1
var color_indices
var curve 
var pos_array = []
var node_array = []
var difficulty = 0


func _ready():
	GlobalUtils.connect("next_level", self, "goto_next_level")
	curve = Curve3D.new()
	create_level()
	pass


func create_level():
	difficulty += 1
	create_land()
	color_indices = [0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3]
	create_crates()
	if(difficulty > 4):
		start_tween()


func start_tween():
	for i in range (pos_array.size()):
		var tween = node_array[i].get_node("Tween")
		tween.connect("tween_complete",self,"tween_looper",[i,(i+1)%pos_array.size()])
		tween.interpolate_property(node_array[i], "transform/translation", pos_array[i], pos_array[(i+1)%pos_array.size()], 2.0, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()

func tween_looper(obj,key,from,to):
	var idx = pos_array.find(obj.get_translation())
	obj.get_node("Tween").interpolate_property(obj, "transform/translation", obj.get_translation(), pos_array[(idx+1)%pos_array.size()] , 2.0, Tween.TRANS_SINE, Tween.EASE_IN)



func create_land():
	var land_inst = hex_land.instance()
	land_inst.set_translation(origin_land + Vector3(land_x_offset,0,land_y_offset))
	land_x_offset *= -1
	add_child(land_inst)
	origin_land = land_inst.get_translation()
	pass



func create_crates():
	node_array = []
	pos_array = []
	for i in range(0,level):
		for j in range(0,level):
			var inst = crates.instance()
			inst.set_translation(origin_land + origin_crates + Vector3(i*10-offset,0,j*10-offset))
			inst.tag = i+j*4
			var index = get_color_indices()
			inst.set_crate_texture(color_indices[index])
			color_indices.remove(index)
			if(i+j*4 == 5) or (i+j*4 == 6) or (i+j*4 == 9) or (i+j*4 == 10):
				node_array.append(inst)
				pos_array.append(inst.get_translation())
			add_child(inst)
	switch_array_pos(node_array, node_array.size()-1, node_array.size()-2)
	switch_array_pos(pos_array, pos_array.size()-1, pos_array.size()-2)

func switch_array_pos(array,i,j):
	var temp = array[i]
	array[i] = array[j]
	array[j] = temp
	pass


func goto_next_level():
	gui.reset_variables()
	create_level()
	move_camera_to_pos()

func move_camera_to_pos():
	var tween = gimball.get_node("Tween")
	tween.interpolate_property(gimball, "transform/translation", gimball.get_translation(), origin_land, 2.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()

func get_color_indices():
	randomize()
	var index = randi()%color_indices.size()
	return index

