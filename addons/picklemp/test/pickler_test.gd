# GdUnit generated TestSuite
class_name PicklerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/picklemp/pickler.gd'


var _pickler:Pickler = Pickler.new()
var _data = {
		"one": CustomClassOne.new(),
		"two": CustomClassTwo.new(),
		"3": CustomClassTwo.new(),
		"json_things": ["str", 42, {"foo":"bar"}, [1,2,3], true, false, null],
		"native": Vector3(0,1,2),
		"nativeobj": SurfaceTool.new(),
	}
	
func before():
	_data["one"].foo = 2.0
	_data["two"].qux = "r"


func before_test():
	_pickler.clear()
	_pickler.strict_dictionary_keys = true


func test_register_custom_class() -> void:
	_pickler.register_custom_class(CustomClassOne)
	assert_that(_pickler.has_custom_class(CustomClassOne))


func test_register_native_class() -> void:
	_pickler.register_native_class("SurfaceTool")
	assert_that(_pickler.has_native_class("SurfaceTool"))


func test_pickle_roudtrip() -> void:
	_pickler.register_custom_class(CustomClassOne)
	_pickler.register_custom_class(CustomClassTwo)
	_pickler.register_native_class("SurfaceTool")
	assert_that(_pickler.has_custom_class(CustomClassOne))
	assert_that(_pickler.has_custom_class(CustomClassTwo))
	assert_that(_pickler.has_native_class("SurfaceTool"))
	
	#print("tostring: ", _data["one"].get_script())
	#print("please print something")
	var p = _pickler.pickle(_data)
	var u = _pickler.unpickle(p)
	assert_dict(_data).contains_same_keys(u.keys())
	assert_object(_data["one"]).is_equal(u["one"])
	assert_object(_data["native"]).is_equal(u["native"])
	assert_object(_data["nativeobj"]).is_equal(u["nativeobj"])
	assert_array(_data["json_things"]).contains_same_exactly(u["json_things"])
	
func test_pickle_getstate_setstate():
	_pickler.register_custom_class(CustomClassTwo)
	assert_that(_pickler.has_custom_class(CustomClassTwo))
	var two = CustomClassTwo.new()
	var p = _pickler.pickle(two)
	assert_int(two.volatile_int).is_equal(-1)
	var u = _pickler.unpickle(p)
	assert_int(u.volatile_int).is_equal(99)
	
func test_filtering_bad_keys():
	var questionable_data = {
		"foo": "bar",
		3: "baz",
	}
	
	_pickler.strict_dictionary_keys = true
	var bad_pickle = _pickler.pre_pickle(questionable_data)
	assert_that(bad_pickle).is_null()
	var bad_unpickle = _pickler.post_unpickle(questionable_data)
	assert_that(bad_unpickle).is_null()
	
	
	_pickler.strict_dictionary_keys = false
	var good_pickle = _pickler.pre_pickle(questionable_data)
	assert_dict(good_pickle).contains_keys(questionable_data.keys())
	var good_unpickle = _pickler.post_unpickle(questionable_data)
	assert_that(good_unpickle).contains_keys(questionable_data.keys())
	
func test_pickle_json():
	_pickler.register_custom_class(CustomClassOne)
	_pickler.register_custom_class(CustomClassTwo)
	_pickler.register_native_class("SurfaceTool")
	var j = _pickler.pickle_json(_data)
	var u = _pickler.unpickle_json(j)
	
	var p_data = JSON.parse_string(j)
	assert_dict(p_data).contains_same_keys(_data.keys())
	
	_pickler.strict_dictionary_keys = false
	var j2 = _pickler.pickle_json(_data)
	assert_str(j2).is_empty()
	
