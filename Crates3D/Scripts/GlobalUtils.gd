extends Node

var selected = []
var obj1
var obj2
var count = 0
signal next_level
var currentScene

func _ready():
	get_tree().set_auto_accept_quit(false)
	#On load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	scene_change.get_child(1).play("fade_out")

func add_object_to_selected_array(object):
	selected.push_front(object)
	if(selected.size()>1):
		var same = check_textures()
		if(same):
			obj1.kill_object()
			obj2.kill_object()
			count += 1
			if(count > 7):
				emit_signal("next_level")
				count = 0
		else:
			obj1.reset_texture()
			obj2.reset_texture()
		obj1 = null
		obj2 = null
		selected = []
	pass

func get_main_node():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count()-1)

# create a function to switch between scenes 
func setScene(scene):
	scene_change.get_child(1).play("fade_in")
	yield(scene_change.get_child(1), "finished")
   #clean up the current scene
	currentScene.queue_free()
   #load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
   #create an instance of our scene
	currentScene = s.instance()
	get_tree().set_current_scene(currentScene)
   # add scene to root
	get_tree().get_root().add_child(currentScene)
	scene_change.get_child(1).play("fade_out")


func check_textures():
	obj1 = selected[0]
	obj2 = selected[1]
	if(obj1.get_crate_texture() == obj2.get_crate_texture() and obj1 != obj2):
		return true
	else:
		return false