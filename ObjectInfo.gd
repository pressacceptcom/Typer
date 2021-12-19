tool
class_name PressAccept_Typer_ObjectInfo

# |=========================================|
# |                                         |
# |           Press Accept: Typer           |
# |    Generalized Type Testing In Godot    |
# |                                         |
# |=========================================|
#
# This module provides some static methods for pollin a script or objects
# footprint (their constants, methods, properties, and signals). The script
# functions operate on Scripts (or resource paths), and the object functions
# operate on Objects (instances).
#
# In general Godot offers method, property, and signal info as an Array of
# Dictionaries. I find this a bit difficult to work with when all I might really
# be interested in is the identifier. My methods return A Dictionary of
# Dictionaries, with each Key of the outer dictionary corresponding to the
# name (identifier) of the inner dictionary.
#
# By doing this, I also have the opportunity to filter the result in my for
# loop by masks. This also helps to make it easy for testing for membership
# of an identifier, since the 'in' operator works on Dictionary keys. In this
# vein, I provide script methods for testing if an identifier exists as a
# constant, method, property, or signal. Godot provides membership tests for
# methods and signals, so I only provide an identifier membership test for
# properties.
#
# The final piece of this module is a class offering reflection methods for a
# given value. This class, whenever assigned an Object for a value, renders
# inheritance, constant, method, property, and signal information. It also
# provides methos for testing membership in one of those areas, or all of those
# areas (useful for trying to resolve an identifier across the board). It also
# offers a method to automatically look up the method information of an value
# and pass it to validate signature, which validates the method signature with
# a given set of arguments to the best of its ability (with what Godot gives us)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Typer
# Class                  : ObjectInfo
#
# Organization        : Press Accept
# Organization URI    : https://pressaccept.com/
# Organization Social : @pressaccept
#
# Author        : Asher Kadar Wolfstein
# Author URI    : https://wunk.me/ (Personal Blog)
# Author Social : https://incarnate.me/members/asherwolfstein/
#                 @asherwolfstein (Twitter)
#                 https://ko-fi.com/asherwolfstein
#
# Copyright : Press Accept: Typer © 2021 The Novelty Factor LLC
#                 (Press Accept, Asher Kadar Wolfstein)
# License   : MIT (see LICENSE)
#
# |-----------|
# | Changelog |
# |-----------|
#
# 1.0.0    12/19/2021    First Release
#

# *************
# | Constants |
# *************

# property masks
#
# see: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-propertyusageflags

# 16383 = 0x3FFF = 0b0011111111111111
const INT_ALL_PROPERTIES_MASK      : int = 16383
# PROPERTY_USAGE_SCRIPT_VARIABLE = 8192 = 0x2000 = 0b0010000000000000
const INT_STANDARD_PROPERTIES_MASK : int = PROPERTY_USAGE_SCRIPT_VARIABLE

# 14847 = 0x39FF = 0b0011100111111111 - not sure how I arrived at this
const INT_ALL_METHODS_MASK      : int = 14847
# METHOD_FLAG_FROM_SCRIPT (deprecated?) + METHOD_FLAGS_DEFAULT = \
#     65 = 0x41 = 0b01000001
const INT_STANDARD_METHODS_MASK : int = \
	METHOD_FLAG_FROM_SCRIPT | METHOD_FLAGS_DEFAULT
# METHOD_FLAG_FROM_SCRIPT (deprecated?) = 64 = 0x40 = 0b01000000
const INT_USER_METHODS_MASK     : int = METHOD_FLAG_FROM_SCRIPT

# this would be in your script as
#     static func __script_constant_info(constants: Array) -> Array
const STR_SCRIPT_CONSTANT_INFO_METHOD : String = '__script_constant_info'
# this would be in your script as
#     static func __script_method_info(
#         method_info: Dictionary, mask: int) -> Dictionary
const STR_SCRIPT_METHOD_INFO_METHOD   : String = '__script_method_info'
# this would be in your script as
#     static func __script_property_info(
#         property_info: Dictionary, mask: int) -> Dictionary
const STR_SCRIPT_PROPERTY_INFO_METHOD : String = '__script_property_info'
# this would be in your script as
#     static func __script_signal_info(
#         signal_info: Dictionary, mask: int) -> Dictionary
const STR_SCRIPT_SIGNAL_INFO_METHOD   : String = '__script_signal_info'

# this would be in your script as
#     func __object_method_info(
#         method_info: Dictionary, mask: int) -> Dictionary
const STR_OBJECT_METHOD_INFO_METHOD   : String = '__object_method_info'
# this would be in your script as
#     func __object_property_info(
#         property_info: Dictionary, mask: int) -> Dictionary
const STR_OBJECT_PROPERTY_INFO_METHOD : String = '__object_property_info'
# this would be in your script as
#     func __object_signal_info(
#         signal_info: Dictionary, mask: int) -> Dictionary
const STR_OBJECT_SIGNAL_INFO_METHOD   : String = '__object_signal_info'

# ****************************
# | Private Static Functions |
# ****************************


# normalize a given input (path name) to a Script resource object
static func _normalize_script(
		script) -> Script:

	if script is String:
		if script.begins_with('res://'):
			return load(script) as Script

	if not script is Script:
		return null

	return script


# ***************************
# | Public Static Functions |
# ***************************

# validates an array of method arguments against the method's info dictionary
#
# The Method's Info Dictionary Format:
#
#	 name - method name
#	 args - array
#	 [
#		name - argument name
#		class_name - 
#		type - argument type
#		hint - 
#		hint_string - 
#		usage - 
#	 ]
#	 default_args [
#	 	...
#	 ]
#	 flags - int
#	 id - ?
#	 return
#	 {
#	 	name - 
#		class_name - 
#		type - return type
#		hint - 
#		hint_string - 
#		usage - 
#	 }
#
static func validate_signature(
		method_args: Array,
		method_info: Dictionary) -> bool:

		# test number of arguments
	if method_args.size() < method_info.args.size() or \
			method_args.size() > (
				method_info.args.size() + method_info.default_args.size()
			):
		return false
	
	# check types
	for i in range(method_args.size()):
		var dest   = method_args[i]
		var target = method_info.args[i]

		if target['type'] > 0:
			if typeof(dest) != target['type'] or \
				( target['type'] == TYPE_OBJECT and \
					target['class_name'] and \
					not dest.is_class(target['class_name'])):
				return false
	
	return true


# return method existence for a given script
#
# NOTE: script can be String (resource path) or Script object
static func script_has_method(
		script,
		method_name           : String,
		include_instance_base : bool = false) -> bool:

	script = _normalize_script(script)
	if not script is Script:
		return false

	var methods = \
		PressAccept_Typer_Typer.get_type_method_names(
			script,
			include_instance_base
		)

	if STR_SCRIPT_METHOD_INFO_METHOD in methods:
		var custom_methods: Dictionary = script.call(
			STR_SCRIPT_METHOD_INFO_METHOD,
			{},
			INT_ALL_METHODS_MASK
		)

		if method_name in custom_methods:
			return true

	return method_name in methods


# return the constants for a given script
#
# NOTE: script can be String (resource path) or Script object
static func script_constant_info(
		script) -> Dictionary:

	script = _normalize_script(script)
	if not script is Script:
		return {}

	var ret: Dictionary = script.get_script_constant_map()

	if script_has_method(script, STR_SCRIPT_CONSTANT_INFO_METHOD):
		ret = script.call(STR_SCRIPT_CONSTANT_INFO_METHOD, ret)

	return ret

# return constant existence for a given script
#
# NOTE: script can be String (resource path) or Script object
static func script_has_constant(
		script,
		constant_name: String) -> bool:

	var constants: Dictionary = script_constant_info(script)

	return constant_name in constants


# return a script's methods info as a dict of names and values (using mask:)
#
# See: https://docs.godotengine.org/en/stable/classes/class_script.html#class-script-method-get-script-method-list
#
# NOTE: script can be String (resource path) or Script object
static func script_method_info(
		script,
		mask                  : int  = INT_STANDARD_METHODS_MASK,
		include_instance_base : bool = false) -> Dictionary:

	script = _normalize_script(script)
	if not script is Script:
		return {}

	var methods : Array      = \
		PressAccept_Typer_Typer.get_type_methods(
			script,
			include_instance_base
		)
	var ret     : Dictionary = {}

	for method in methods:
		if method['flags'] & mask:
			ret[method['name']] = method

	if script_has_method(script, STR_SCRIPT_METHOD_INFO_METHOD):
		ret = script.call(STR_SCRIPT_METHOD_INFO_METHOD, ret, mask)

	return ret


# return a script's property info as a dict of names and values (using mask:)
#
# See: https://docs.godotengine.org/en/stable/classes/class_script.html#class-script-method-get-script-property-list
#
# NOTE: script can be String (resource path) or Script object
static func script_property_info(
		script,
		mask: int = INT_STANDARD_PROPERTIES_MASK) -> Dictionary:

	script = _normalize_script(script)
	if not script is Script:
		return {}

	var properties : Array      = script.get_script_property_list()
	var ret        : Dictionary = {}

	for property in properties:
		if property['usage'] & mask:
			ret[property['name']] = property

	if script_has_method(script, STR_SCRIPT_PROPERTY_INFO_METHOD):
		ret = script.call(STR_SCRIPT_PROPERTY_INFO_METHOD, ret, mask)

	return ret


# return property existence for a given script
#
# NOTE: script can be String (resource path) or Script object
static func script_has_property(
		script,
		property_name: String) -> bool:

	var properties = script_property_info(script, INT_ALL_PROPERTIES_MASK)

	return property_name in properties


# return a script's signal info as a dict of names and values (using mask:)
#
# See: https://docs.godotengine.org/en/stable/classes/class_script.html#class-script-method-get-script-signal-list
#
# NOTE: script can be String (resource path) or Script object
static func script_signal_info(
		script,
		mask: int = 1) -> Dictionary:

	script = _normalize_script(script)
	if not script is Script:
		return {}

	var signals : Array      = script.get_script_signal_list()
	var ret     : Dictionary = {}

	for _signal in signals:
		if _signal['flags'] & mask:
			ret[_signal['name']] = _signal

	if script_has_method(script, STR_SCRIPT_SIGNAL_INFO_METHOD):
		ret = script.call(STR_SCRIPT_SIGNAL_INFO_METHOD, ret, mask)

	return ret


# return signal existence for a given script
#
# NOTE: script can be String (resource path) or Script object
static func script_has_signal(
		script,
		signal_name: String) -> bool:

	var signals = script_signal_info(script)

	return signal_name in signals


# return object methods as dict of names and values using mask
#
# See: https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-get-method-list
#      as well as https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-method-flags-default
static func object_method_info(
		obj  : Object,
		mask : int = INT_STANDARD_METHODS_MASK) -> Dictionary:

	if not obj is Object:
		return {}

	var methods : Array      = obj.get_method_list()
	var ret     : Dictionary = {}

	for method in methods:
		if method['flags'] & mask:
			ret[method['name']] = method

	if obj.has_method(STR_OBJECT_METHOD_INFO_METHOD):
		ret = obj.call(STR_OBJECT_METHOD_INFO_METHOD, ret, mask)
	
	return ret


# return object properties as dict of names and info using mask
#
# See: https://docs.godotengine.org/en/stable/classes/class_object.html#id2
#      as well as https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-propertyusageflags
static func object_property_info(
		obj  : Object,
		mask : int = INT_STANDARD_PROPERTIES_MASK) -> Dictionary:

	if not obj is Object:
		return {}

	var properties : Array      = obj.get_property_list()
	var ret        : Dictionary = {}
	
	for property in properties:
		if property['usage'] & mask:
			ret[property['name']] = property

	if obj.has_method(STR_OBJECT_PROPERTY_INFO_METHOD):
		ret = obj.call(STR_OBJECT_PROPERTY_INFO_METHOD, ret, mask)
	
	return ret


# return proeprty existence for a given script
static func object_has_property(
		obj           : Object,
		property_name : String) -> bool:

	var properties: Dictionary = \
		object_property_info(obj, INT_ALL_PROPERTIES_MASK)

	if property_name in properties:
		return true

	return false


# return object signals as dict of names and info using mask
#
# See: https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-get-signal-list
static func object_signal_info(
		obj  : Object,
		mask : int = 1) -> Dictionary:

	if not obj is Object:
		return {}
	
	var signals : Array      = obj.get_signal_list()
	var ret     : Dictionary = {}
	
	for _signal in signals:
		if _signal['flags'] & mask:
			ret[_signal['name']] = _signal
	
	if obj.has_method(STR_OBJECT_SIGNAL_INFO_METHOD):
		ret = obj.call(STR_OBJECT_SIGNAL_INFO_METHOD, ret, mask)
	
	return ret

# ***********
# | Signals |
# ***********

signal value_changed(new_value, old_value, emitter)

# *********************
# | Public Properties |
# *********************

# The value we're examining
var value                 : Object setget set_value
# Whether to include built-in classes where Applicable
var include_instance_base : bool
# An Array of the inheritance path by type (see Typer) origin->endpoint
var inheritances          : Array

# The class stores info about an object's reflections in the following Dicts
var constants             : Dictionary setget _set_constants
var methods               : Dictionary setget _set_methods
var properties            : Dictionary setget _set_properties
var signals               : Dictionary setget _set_signals

# The class generates Arrays for quick look-up based on the keys of the above
var constant_names        : Array
var method_names          : Array
var property_names        : Array
var signal_names          : Array

# ***************
# | Constructor |
# ***************


# initialize the object with an object value to reflect on
func _init(
		init_value: Object = null,
		init_include_instance_base: bool = false) -> void:
	include_instance_base = init_include_instance_base
	self.value = init_value


# ********************
# | Built-In Methods |
# ********************


func _to_string() -> String:
	return __output('')


func __output(
		prefix   : String,
		tab_char : String = "\t") -> String:
	var method_keys   : Array = methods.keys()
	var property_keys : Array = properties.keys()
	var constant_keys : Array = constants.keys()

	var ret: String = prefix + "ObjectInfo:\n" + prefix + tab_char + "value:\n"
	if value.has_method('__output'):
		ret += value.__output(tab_char, prefix + tab_char + tab_char)
	else:
		ret += str(value) + "\n"

	ret += "\n" + prefix + tab_char + "methods:\n"
	for method in method_keys:
		ret += prefix + tab_char + tab_char + method + "\n"

	ret += "\n" + prefix + tab_char + "properties:\n"
	for property in property_keys:
		ret += prefix + tab_char + tab_char + property + "\n"

	ret += "\n" + prefix + tab_char + "constants:\n"
	for constant in constant_keys:
		ret += prefix + tab_char + tab_char + constant + "\n"

	ret += "\n"

	return ret


# ******************
# | SetGet Methods |
# ******************


# NOTE: set resolve_script_obj to false to inspect Script object
func set_value(
		new_value          : Object,
		resolve_script_obj : bool = true) -> void:

	var old_value: Object = value
	value = new_value

	if value:
		if value is Script and resolve_script_obj:
			inheritances = \
				PressAccept_Typer_Typer.get_type_inheritance(
					value,
					include_instance_base
				)
			self.constants    = script_constant_info(value)
			self.methods      = script_method_info(
				value,
				INT_ALL_METHODS_MASK,
				include_instance_base
			)
			self.properties   = \
				script_property_info(value, INT_ALL_PROPERTIES_MASK)
			self.signals      = script_signal_info(value)
		else:
			inheritances = \
				PressAccept_Typer_Typer.get_type_inheritance(
					PressAccept_Typer_Typer.get_type(value),
					include_instance_base
				)
			self.constants    = script_constant_info(value.get_script())
			self.methods      = \
				object_method_info(value, INT_ALL_METHODS_MASK)
			self.properties   = \
				object_property_info(value, INT_ALL_PROPERTIES_MASK)
			self.signals      = object_signal_info(value)
	else:
		inheritances = []
		self.constants    = {}
		self.methods      = {}
		self.properties   = {}
		self.signals      = {}

	emit_signal('value_changed', value, old_value, self)


func _set_constants(
		new_constants: Dictionary) -> void:

	constants = new_constants
	constant_names = constants.keys()


func _set_methods(
		new_methods: Dictionary) -> void:

	methods = new_methods
	method_names = methods.keys()


func _set_properties(
		new_properties: Dictionary) -> void:

	properties = new_properties
	property_names = properties.keys()


func _set_signals(
		new_signals: Dictionary) -> void:

	signals = new_signals
	signal_names = signals.keys()


# ******************
# | Public Methods |
# ******************


func obj_has_constant(
		constant_name: String) -> bool:

	return constant_name in constant_names


func obj_has_method(
		method_name: String) -> bool:

	return method_name in method_names


func obj_has_property(
		property_name: String) -> bool:

	return property_name in property_names


func obj_has_signal(
		signal_name: String) -> bool:

	return signal_name in signal_names


# test existence of identifier anywhere in the namespace of the object
func obj_has_identifier(
		identifier: String) -> bool:

	return identifier in constant_names \
		or identifier in method_names \
		or identifier in property_names \
		or identifier in signal_names


# helper method that pulls method_info by name and submits to validate_signature
func validate_method_signature(
		method_args: Array,
		method_name: String) -> bool:

	if obj_has_method(method_name):
		return validate_signature(method_args, methods[method_name])

	return false

