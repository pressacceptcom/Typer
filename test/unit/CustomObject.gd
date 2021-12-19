tool
extends Reference

signal a_signal(an_arg)

const A_CONSTANT: String = 'constant'

var a_property: String = ''

func __object_method_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_method'] = {}
	return ret


func __object_property_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_property'] = {}
	return ret


func __object_signal_info(ret: Dictionary, mask: int) -> Dictionary:
	ret['custom_signal'] = {}
	return ret


func a_method(arg1: String, arg2: int) -> void:
	pass

