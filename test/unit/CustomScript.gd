tool
extends Reference

signal a_signal(an_arg)

const INT_CONSTANT: int = 0
const STR_CONSTANT: String = 'string'

var a_property: String = ''

static func __script_constant_info(ret: Dictionary) -> Dictionary:
	ret['CUSTOM_CONSTANT'] = 'custom'
	return ret


static func __script_method_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_method'] = {}
	return ret


static func __script_property_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_property'] = {}
	return ret


static func __script_signal_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_signal'] = {}
	return ret

