tool
extends Reference

signal a_signal(an_arg)

const INT_CONSTANT: int = 0
const STR_CONSTANT: String = 'string'

var a_property: String = ''

static func __script_constant_info(
		ret: Dictionary) -> Dictionary:

	ret['CUSTOM_CONSTANT'] = 'custom'
	return ret


static func __script_method_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_method',
		'flags' : PressAccept_Typer_ObjectInfo.INT_STANDARD_METHODS_MASK
	})

	return ret


static func __script_property_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_property',
		'usage' : PressAccept_Typer_ObjectInfo.INT_STANDARD_PROPERTIES_MASK
	})

	return ret


static func __script_signal_info(
		ret: Array) -> Array:

	ret.push_back({
		'name'  : 'custom_signal',
		'flags' : 1
	})

	return ret

