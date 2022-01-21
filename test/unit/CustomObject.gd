tool
extends Reference

signal a_signal(an_arg)

const A_CONSTANT: String = 'constant'

var a_property: String = ''

func __object_method_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_method',
		'flags' : PressAccept_Typer_ObjectInfo.INT_STANDARD_METHODS_MASK
	})

	return ret


func __object_property_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_property',
		'usage' : PressAccept_Typer_ObjectInfo.INT_STANDARD_PROPERTIES_MASK
	})

	return ret


func __object_signal_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_signal',
		'flags' : 1
	})

	return ret


func a_method(
		arg1: String,
		arg2: int) -> void:

	pass

