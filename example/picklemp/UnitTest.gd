extends Control

"""Test the pickler system"""

@onready var pickler: Pickler = $Pickler

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("class list: ", ClassDB.get_class_list())
	pickler.register_custom_class(CustomClassOne)
	pickler.register_custom_class(CustomClassTwo)
	pickler.register_native_class("SurfaceTool")
	
	var some_gdscript_data = {
		"one": CustomClassOne.new(),
		"two": CustomClassTwo.new(),
		3: CustomClassTwo.new(),
		"json_things": ["str", 42, {"foo":"bar"}, [1,2,3], true, false, null],
		"native": Vector3(0,1,2),
		"nativeobj": SurfaceTool.new(),
	}
	some_gdscript_data["one"].foo = 2.0
	some_gdscript_data["two"].qux = "r"
	
	
	var pre = pickler.pre_pickle(some_gdscript_data)
	
	var s = JSON.stringify(pre, "    ")
	print(s)
	
	# TODO:
	# - pickle_json
	# - pickle (bytes)
	# - gzip the bytes
	
	# people play games for mastery, connection, or expression
	# survival, villagers, techbuilds
	var post = pickler.post_unpickle(pre)
	#print(post)
	
	var pickle = pickler.pickle(some_gdscript_data)
	print("pickle size: ", len(pickle))
	#print(pickle)
	var unpickle = pickler.unpickle(pickle)
	
	print(unpickle)
	
	print('me: %s' % [ CustomClassOne ])
	##print('name: %s' % [ CustomClassOne.name ])
	#print('script path: %s' % [ CustomClassOne.resource_path ])
	#print('script filename: %s' % [ CustomClassOne.resource_path.get_file() ])
	#
	#print()
	#
	#var message = "This is a test message."
	#print_debug('%s "%s": %s' % [ self, name, message ])
	
	await get_tree().create_timer(1).timeout
	get_tree().quit()
