extends Spatial

var gray_mat = FixedMaterial.new()
var selected = false
var tiles = [preload("res://Assets/pngs/crate_tiles/blue.png"),
                   preload("res://Assets/pngs/crate_tiles/green.png"),
                   preload("res://Assets/pngs/crate_tiles/red.png"),
                   preload("res://Assets/pngs/crate_tiles/yellow.png")]

onready var anim = get_node("AnimationPlayer")
var tag = 0


func _ready():
	pass
	get_node("RigidBody").connect("input_event", self, "crates_input_event")
#	set_fixed_process(true)
#	set_process_input(true)



func _fixed_process(delta):
	var pos = get_translation()
	var cam = get_tree().get_root().get_camera()
	var screenPos = cam.unproject_position(pos)
	get_node("tag").set_pos(screenPos)
	get_node("tag").set_text(String(tag))


func set_crate_texture(color):
	gray_mat.set_texture(0,tiles[color])
	pass

func get_crate_texture():
	return gray_mat.get_texture(0)

func get_crates_material_override():
	return get_node("RigidBody/mesh").get_material_override()

func reset_texture():
	anim.play("stay")
	yield(anim,"finished")
	get_node("RigidBody/mesh").set_material_override(null)
	selected = false

func kill_object():
	anim.play("dissappear")
	yield(anim,"finished")
	queue_free()


func crates_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if (event.type==InputEvent.SCREEN_TOUCH and event.pressed):
		if (not selected):
			get_node("RigidBody/mesh").set_material_override(gray_mat)
			GlobalUtils.add_object_to_selected_array(self)
		else:
			get_node("RigidBody/mesh").set_material_override(null)
		selected = not selected



