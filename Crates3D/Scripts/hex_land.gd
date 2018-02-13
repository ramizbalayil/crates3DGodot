extends Spatial

var gimball

func _ready():
	gimball = GlobalUtils.get_main_node().get_node("gimball")
	if(gimball != null):
		set_process(true)
	pass

func _process(delta):
	if(self.get_translation().distance_to(gimball.get_translation()) > 100):
		queue_free()
