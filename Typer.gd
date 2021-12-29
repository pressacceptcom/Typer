tool
class_name PressAccept_Typer_Typer

# |=========================================|
# |                                         |
# |           Press Accept: Typer           |
# |    Generalized Type Testing In Godot    |
# |                                         |
# |=========================================|
#
# This module provides functions to determine/evaluate GDScript types.
#
# Even though GDScript is a dynamically typed language, sometimes we'd like to
# know about a variable's type and even compare/process that type. These
# utility functions utilize various means to determine a variable's type,
# from determining if it's a built-in type, to a built-in class (such as Node),
# to a custom script (attached/unattached to a node). Information on these
# three different sorts of type information come from different sources. These
# static functions hope to make sorting through these layers more intuitive and
# easy.
#
# The idea is that we normalize type values to 'cascade' against these layers.
# Retrieving each layer separately is achievable through existing GDScript
# functions, but returning the most specific information (if it has a script,
# that script, if it's a built-in class, that class, or if its a primitive, the
# primitive) given any particular value, and comparing that information is
# unique to this library.
#
# The "layers" of type are as follows:
#
#	A built-in primitive type, unrelated to the next two, identified ultimately
#	by an integer constant (here translated into a string constant).
#
#	A built in class derived from (or is) Object, these are only identified by
#	strings as their class name.
#
#	A script that may or may not identify a class that may or may not inherit
#	from classes defined in other scripts. These are only identified by strings
#	but unlike classes, they are always identified by their resource path:
#	res://.... (some script have class_names, some don't)
#
# Inner classes in this system will return the string version of their base
# class if they don't inherit from another script, otherwise they'll return a
# script path, like other objects. You can customize the inner classes value
# that's returned for its type by using a custom method with an identifier
# equivalent to STR_CUSTOM_CLASS_METHOD (__class_name)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Typer
# Class                  : Typer
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
# 1.0.0    06/04/2021    First Release
# 1.0.1    06/05/2021    Added STR_INDEXABLE_METHOD as method name
# 2.0.0    12/18/2021    Removed STR_INDEXABLE functionality
#                            To verify indexable,
#                                just use method STR_INDEXABLE_METHOD
#                        Added get_type_inheritance
#                                (type compatibility uses this now)
#                              get_type_methods
#                              get_type_method_names
#                        Changed STR_CUSTOM_CLASS to STR_CUSTOM_CLASS_METHOD
#                              get_type now expects a method return value
# 2.1.0    12/29/2021    Added STR_SET_INDEXABLE_METHOD
#                              STR_SET_INDEXABLE_BY_METHOD
#                              STR_INDICES_METHOD
#                              set_indexable_by
#                              set_idnexable
#                              get_indices
#

# ****************
# | Enumerations |
# ****************

# Custom enumeration of built-in TYPE_* enumeration
enum ENUM_TYPES {
	NULL,         #  0 - TYPE_NIL
	BOOL,         #  1 - TYPE_BOOL
	INT,          #  2 - TYPE_INT
	FLOAT,        #  3 - TYPE_REAL
	STRING,       #  4 - TYPE_STRING
	VECTOR2,      #  5 - TYPE_VECTOR2
	RECT2,        #  6 - TYPE_RECT2
	VECTOR3,      #  7 - TYPE_VECTOR3
	TRANSFORM2D,  #  8 - TYPE_TRANSFORM2D
	PLANE,        #  9 - TYPE_PLANE
	QUAT,         # 10 - TYPE_QUAT
	AABBOX,       # 11 - TYPE_AABB
	BASIS,        # 12 - TYPE_BASIS
	TRANSFORM,    # 13 - TYPE_TRANSFORM
	COLOR,        # 14 - TYPE_COLOR
	NODEPATH,     # 15 - TYPE_NODEPATH
	RESID,        # 16 - TYPE_RID
	OBJECT,       # 17 - TYPE_OBJECT
	DICT,         # 18 - TYPE_DICTIONARY
	ARRAY,        # 19 - TYPE_ARRAY
	BYTEARRAY,    # 20 - TYPE_RAW_ARRAY
	INTARRAY,     # 21 - TYPE_INT_ARRAY
	FLOATARRAY,   # 22 - TYPE_REAL_ARRAY
	STRINGARRAY,  # 23 - TYPE_STRING_ARRAY
	VECTOR2ARRAY, # 24 - TYPE_VECTOR2_ARRAY
	VECTOR3ARRAY, # 25 - TYPE_VECTOR3_ARRAY
	COLORARRAY    # 26 - TYPE_COLOR_ARRAY
}

# *************
# | Constants |
# *************

# String representations of built-in types
const STR_NULL         : String = 'Null'
const STR_BOOL         : String = 'Boolean'
const STR_INT          : String = 'Integer'
const STR_FLOAT        : String = 'Float'
const STR_STRING       : String = 'String'
const STR_VECTOR2      : String = 'Vector2'
const STR_RECT2        : String = 'Rectangle2'
const STR_VECTOR3      : String = 'Vector3'
const STR_TRANSFORM2D  : String = 'Transform2D'
const STR_PLANE        : String = 'Plane'
const STR_QUAT         : String = 'Quaternion'
const STR_AABBOX       : String = 'Axis Aligned Bounding Box'
const STR_BASIS        : String = 'Basis'
const STR_TRANSFORM    : String = 'Transform'
const STR_COLOR        : String = 'Color'
const STR_NODEPATH     : String = 'Node Path'
const STR_RESID        : String = 'Resource ID'
const STR_OBJECT       : String = 'Object'
const STR_DICT         : String = 'Dictionary'
const STR_ARRAY        : String = 'Array'
const STR_BYTEARRAY    : String = 'Pool Byte Array'
const STR_INTARRAY     : String = 'Pool Int Array'
const STR_FLOATARRAY   : String = 'Pool Real Array'
const STR_STRINGARRAY  : String = 'Pool String Array'
const STR_VECTOR2ARRAY : String = 'Pool Vector2 Array'
const STR_VECTOR3ARRAY : String = 'Pool Vector3 Array'
const STR_COLORARRAY   : String = 'Pool Color Array'
const STR_UNKNOWN      : String = 'Unknown'

# Method defined on an inner class that returns custom (inner) class name
const STR_CUSTOM_CLASS_METHOD : String = '__class_name'

# method defined on a script that returns a value that is indexable
#
# indexable means the returned value can be accessed with []
#
# In 1.0 we used STR_INDEXABLE (: String = 'INDEXABLE') as a constant on a
# script to determine if that script supported being indexable. Since any
# script that provides a STR_INDEXABLE_METHOD method is thus indexable, the
# constant is not needed, we can simply test for the presence of the method
const STR_INDEXABLE_METHOD    : String = '__indexable'

# sets the indexable value
const STR_SET_INDEXABLE_METHOD    : String = '__set_indexable'

# sets an index in the indexable value
const STR_SET_INDEXABLE_BY_METHOD : String = '__set_indexable_by'

# returns the values that can be used to index
const STR_INDICES_METHOD          : String = '__indices'

# String's equivalent to ENUM_TYPES labels
const ARR_TYPES_ENUM: Array = [
	'NULL',         #  0 - TYPE_NIL
	'BOOL',         #  1 - TYPE_BOOL
	'INT',          #  2 - TYPE_INT
	'FLOAT',        #  3 - TYPE_REAL
	'STRING',       #  4 - TYPE_STRING
	'VECTOR2',      #  5 - TYPE_VECTOR2
	'RECT2',        #  6 - TYPE_RECT2
	'VECTOR3',      #  7 - TYPE_VECTOR3
	'TRANSFORM2D',  #  8 - TYPE_TRANSFORM2D
	'PLANE',        #  9 - TYPE_PLANE
	'QUAT',         # 10 - TYPE_QUAT
	'AABBOX',       # 11 - TYPE_AABB
	'BASIS',        # 12 - TYPE_BASIS
	'TRANSFORM',    # 13 - TYPE_TRANSFORM
	'COLOR',        # 14 - TYPE_COLOR
	'NODEPATH',     # 15 - TYPE_NODEPATH
	'RESID',        # 16 - TYPE_RID
	'OBJECT',       # 17 - TYPE_OBJECT
	'DICT',         # 18 - TYPE_DICTIONARY
	'ARRAY',        # 19 - TYPE_ARRAY
	'BYTEARRAY',    # 20 - TYPE_RAW_ARRAY
	'INTARRAY',     # 21 - TYPE_INT_ARRAY
	'FLOATARRAY',   # 22 - TYPE_REAL_ARRAY
	'STRINGARRAY',  # 23 - TYPE_STRING_ARRAY
	'VECTOR2ARRAY', # 24 - TYPE_VECTOR2_ARRAY
	'VECTOR3ARRAY', # 25 - TYPE_VECTOR3_ARRAY
	'COLORARRAY'    # 26 - TYPE_COLOR_ARRAY
]

# Map indices (ENUM_TYPE) to strings
const ARR_TYPES: Array = [
	STR_NULL,         #  0 - TYPE_NIL
	STR_BOOL,         #  1 - TYPE_BOOL
	STR_INT,          #  2 - TYPE_INT
	STR_FLOAT,        #  3 - TYPE_REAL
	STR_STRING,       #  4 - TYPE_STRING
	STR_VECTOR2,      #  5 - TYPE_VECTOR2
	STR_RECT2,        #  6 - TYPE_RECT2
	STR_VECTOR3,      #  7 - TYPE_VECTOR3
	STR_TRANSFORM2D,  #  8 - TYPE_TRANSFORM2D
	STR_PLANE,        #  9 - TYPE_PLANE
	STR_QUAT,         # 10 - TYPE_QUAT
	STR_AABBOX,       # 11 - TYPE_AABB
	STR_BASIS,        # 12 - TYPE_BASIS
	STR_TRANSFORM,    # 13 - TYPE_TRANSFORM
	STR_COLOR,        # 14 - TYPE_COLOR
	STR_NODEPATH,     # 15 - TYPE_NODEPATH
	STR_RESID,        # 16 - TYPE_RID
	STR_OBJECT,       # 17 - TYPE_OBJECT
	STR_DICT,         # 18 - TYPE_DICTIONARY
	STR_ARRAY,        # 19 - TYPE_ARRAY
	STR_BYTEARRAY,    # 20 - TYPE_RAW_ARRAY
	STR_INTARRAY,     # 21 - TYPE_INT_ARRAY
	STR_FLOATARRAY,   # 22 - TYPE_REAL_ARRAY
	STR_STRINGARRAY,  # 23 - TYPE_STRING_ARRAY
	STR_VECTOR2ARRAY, # 24 - TYPE_VECTOR2_ARRAY
	STR_VECTOR3ARRAY, # 25 - TYPE_VECTOR3_ARRAY
	STR_COLORARRAY    # 26 - TYPE_COLOR_ARRAY
]

# types that have no callable methods or constants
const DICT_PRIMITIVES: Dictionary = {
	ENUM_TYPES.NULL  : STR_NULL,
	ENUM_TYPES.BOOL  : STR_BOOL,
	ENUM_TYPES.INT   : STR_INT,
	ENUM_TYPES.FLOAT : STR_FLOAT
}

# types that are castable to other types
const DICT_CASTABLE: Dictionary = {
	ENUM_TYPES.BOOL   : STR_BOOL,
	ENUM_TYPES.INT    : STR_INT,
	ENUM_TYPES.FLOAT  : STR_FLOAT,
	ENUM_TYPES.STRING : STR_STRING
}

# types that are indexable
const DICT_INDEXABLE: Dictionary = {
	ENUM_TYPES.STRING       : STR_STRING,
	ENUM_TYPES.OBJECT       : STR_OBJECT,
	ENUM_TYPES.ARRAY        : STR_ARRAY,
	ENUM_TYPES.DICT         : STR_DICT,
	ENUM_TYPES.BYTEARRAY    : STR_BYTEARRAY,
	ENUM_TYPES.INTARRAY     : STR_INTARRAY,
	ENUM_TYPES.FLOATARRAY   : STR_FLOATARRAY,
	ENUM_TYPES.STRINGARRAY  : STR_STRINGARRAY,
	ENUM_TYPES.VECTOR2ARRAY : STR_VECTOR2ARRAY,
	ENUM_TYPES.VECTOR3ARRAY : STR_VECTOR3ARRAY,
	ENUM_TYPES.COLORARRAY   : STR_COLORARRAY
}

# ***************************
# | Public Static Functions |
# ***************************


# Convert type enumeration to string representation
static func type2str(
		type_code: int) -> String:

	if type_code < 0 or type_code >= ARR_TYPES.size():
		return STR_UNKNOWN

	return ARR_TYPES[type_code]


# Convert string representation to enum integer
static func str2type(
		type_str: String) -> int:

	type_str = type_str.to_upper()
	for i in range(ARR_TYPES.size()):
		if type_str == ARR_TYPES[i].to_upper():
			return i
		if type_str == ARR_TYPES_ENUM[i]:
			return i

	return -1


# normalizes an int or String to String constant
static func normalize_type_to_str(
		type) -> String: # int | String

	match typeof(type):
		TYPE_INT:
			return type2str(type)
		TYPE_STRING:
			return type2str(str2type(type))

	return STR_UNKNOWN


# normalizes an int or String to an enumeration value
static func normalize_type_to_int(
		type) -> int: # int | String

	match typeof(type):
		TYPE_INT:
			if type in range(ARR_TYPES.size()):
				return type
		TYPE_STRING:
			return str2type(type)

	return -1


# returns true if the type has no methods or constants
static func is_primitive(
		type) -> bool: # int | String

	type = normalize_type_to_int(type)
	return type in DICT_PRIMITIVES


# returns trye if the type is castable to other built-in types
static func is_castable(
		type) -> bool: # int | String

	type = normalize_type_to_int(type)
	return type in DICT_CASTABLE


# returns true if the type is indexable via [] (Arrays, Dicts, Objects...)
static func is_indexable(
		type) -> bool: # int | String | Script

	if typeof(type) == ENUM_TYPES.STRING and type.begins_with('res://') \
			or type is Script:
		var methods: Array = get_type_method_names(type)
		if STR_INDEXABLE_METHOD in methods:
			return true

	type = normalize_type_to_int(type)
	return type in DICT_INDEXABLE


# return the indexable value from a given instance
static func get_indexable(
		instance: Object):

	if instance.has_method(STR_INDEXABLE_METHOD):
		return instance.call(STR_INDEXABLE_METHOD)

	return null


# sets the indexable value from a given instance
static func set_indexable_by(
		instance: Object,
		index,
		value) -> bool:

	if instance.has_method(STR_SET_INDEXABLE_BY_METHOD):
		return instance.call(STR_SET_INDEXABLE_BY_METHOD, index, value)

	return false


# sets the indexable value from a given instance
static func set_indexable(
		instance: Object,
		indexable) -> bool:

	if instance.has_method(STR_SET_INDEXABLE_METHOD):
		return instance.call(STR_SET_INDEXABLE_METHOD, indexable)

	return false


# return the indexable 'keys' from a given instance
static func get_indices(
		instance: Object) -> Array:

	if instance.has_method(STR_INDICES_METHOD):
		return instance.call(STR_INDICES_METHOD)

	return []


# Convert a type (int, Script, or string) to an identifiable string.
#
# if the type is a script it returns the uniquely identifiable resource path.
# Not to be confused with type2str. This is used elsewhere to normalize type
# information.
static func type_to_str(
		type) -> String: # int | String | Script

	match typeof(type):
		ENUM_TYPES.INT:
			return normalize_type_to_str(type)
		ENUM_TYPES.STRING:
			if not type.begins_with('res://'):
				var type_str: String = normalize_type_to_str(type)
				# normalize to primitive or built-in class name
				return type if type_str == STR_UNKNOWN else type_str

	if type is Script:
		return type.resource_path

	return type


# Checks if a variant value is of a type (String or Script)
#
# NOTE: string should be a built-in class name or resource path. Strings of
#       names of classes (class_name) doesn't work, provide the Script by
#       referencing the class_name instead
static func is_type(
		variable_value, # any
		type) -> bool:  # int | String (built-in class name or path) | Script

	if not type is Script:
		type = type_to_str(type)
		if type.begins_with('res://'):
			# convert to a script
			type = load(type)
		else:
			if type in ARR_TYPES:
				# primitive type
				return typeof(variable_value) == ARR_TYPES.find(type)

			if typeof(variable_value) == ENUM_TYPES.OBJECT:
				# built-in class
				return variable_value.is_class(type)
			else:
				# variable_value isn't a class but not testing for a primitive 
				return false

	# failed load causes type to be null
	if type and type is Script:
		# is variable_value an instance of this script (does inheritance)
		return variable_value is type

	# testing for a script but variable_value isn't a script
	return false


# Returns a variant's type information as a string
#
# Built-in types are converted to above string constants, built-in classes
# return their class names and Scripts return their resource path.
#
# NOTE: scripts override built-in classes, Script objects return their paths
#       If you want a variable's built-in class just use .get_class()
#
# Inner classes return their inherited *built-in* class unless the __class_name
# property has been defined.
static func get_type(
		variable_value) -> String:

	var type = typeof(variable_value)

	if type == TYPE_OBJECT:
		if variable_value is Script:
			type = variable_value
		else:
			type = variable_value.get_class()
			# do we have a script?
			var script = variable_value.get_script()
			if script:
				# override the class information
				if script.resource_path:
					# return the Script object defining this variable
					type = script
				else:
					# did this presumably inner class inherit from a script?
					var base_script = script.get_base_script()
					if base_script is Script and base_script.resource_path:
						type = base_script
					elif variable_value.has_method(STR_CUSTOM_CLASS_METHOD):
						# fall back to custom property
						return variable_value.call(STR_CUSTOM_CLASS_METHOD);

	return type_to_str(type)


# Builds an inheritance path as an array (base->end) for a given type
static func get_type_inheritance(
		type, # String | Script
		include_instance_base: bool = false) -> Array:

	# we're dealing with potential strings or scripts
	var type_str = type_to_str(type) \
		if not typeof(type) == ENUM_TYPES.STRING \
		else type

	var type_arr: Array = []
	var base: String = ''

	if type_str.begins_with('res://'):
		# we're dealing with a script
		# build inheritance stack base->end
		type = type if type is Script else load(type)
		type_arr.push_front(type.resource_path)
		var base_script: Script = type.get_base_script()
		while base_script:
			type_arr.push_front(base_script.resource_path)
			base_script = base_script.get_base_script()
		base = type.get_instance_base_type()

	if not include_instance_base:
		return type_arr

	base = base if base else type_str
	while base:
		type_arr.push_front(base)
		base = ClassDB.get_parent_class(base)

	return type_arr


# Collects all methods (dict objects) as an array based on inheritance
static func get_type_methods(
		type, # String | Script
		include_instance_base: bool = false) -> Array:

	if type is String:
		if type.begins_with('res://'):
			type = load(type)

	var methods      : Array = []
	var method_names : Array = []

	if not type is String:
		var script_methods: Array = type.get_script_method_list()
		for method in script_methods:
			if not method['name'] in method_names:
				methods.push_back(method)
				method_names.push_back(method['name'])
		if not include_instance_base:
			return methods
		type = type.get_instance_base_type()

	# we're querying a built-in class
	var class_methods: Array = ClassDB.class_get_method_list(type)
	for method in class_methods:
		if not method['name'] in method_names:
			methods.push_back(method)
			method_names.push_back(method['name'])

	return methods


# Collects all method names as an array based on inheritance
static func get_type_method_names(
		type, # String | Script
		include_instance_base: bool = false) -> Array:

	var methods      : Array = get_type_methods(type, include_instance_base)
	var method_names : Array = []

	for method in methods:
		method_names.push_back(method['name'])

	return method_names


# Compares two types to see if they are equivalent or have a common ancestor
#
# true means they are the same type or they inherit from an equivalent base
# class.  By default this doesn't include the built-in inherited class
# (Reference, Node...) but passing true to include_instance_base will include
# the base class (get_instance_base_type). If you include the built-in
# inherited class the algorithm will test the two classes for inheritance.
#
# NOTE: this compares *types* not variable values, you must retrieve a
#       variable's type information prior to using this function
static func types_compatible(
		type1,
		type2,
		include_instance_base = false) -> bool:

	# we're dealing with potential integers or scripts
	var type1_str: String = type_to_str(type1) \
		if not typeof(type1) == ENUM_TYPES.STRING \
		else type1
	var type2_str: String = type_to_str(type2) \
		if not typeof(type2) == ENUM_TYPES.STRING \
		else type2

	if not type1_str.begins_with('res://') or \
			not type2_str.begins_with('res://'):
		# at least one type is a built-in class or primitive
		var type_str: String = normalize_type_to_str(type1_str)
		type1_str = type1_str if type_str == STR_UNKNOWN else type_str

		type_str = normalize_type_to_str(type2_str)
		type2_str = type2_str if type_str == STR_UNKNOWN else type_str

		if not type1_str in ARR_TYPES and not type2_str in ARR_TYPES:
			# normalize to built-in class
			if type1_str.begins_with('res://'):
				type1_str = load(type1_str).get_instance_base_type() \
					if not type1 is Script \
					else type1.get_instance_base_type()
			if type2_str.begins_with('res://'):
				type2_str = load(type2_str).get_instance_base_type() \
					if not type2 is Script \
					else type2.get_instance_base_type()

			# types are built-in classes
			return type1_str == type2_str or \
				ClassDB.is_parent_class(type1_str, type2_str) or \
				ClassDB.is_parent_class(type2_str, type1_str)

		# at least one type is a primitive
		return type1_str == type2_str

	if type1_str.begins_with('res://') and type2_str.begins_with('res://'):
		# both types are scripts
		type1 = load(type1_str) if not type1 is Script else type1
		type2 = load(type2_str) if not type2 is Script else type2

		# if this is true we don't have to do the rest
		if type1 == type2:
			return true

		# build inheritance stack base->end
		var type1_arr : Array = \
			get_type_inheritance(type1, include_instance_base)
		var type2_arr : Array = \
			get_type_inheritance(type2, include_instance_base)

		# test inheritance stack
		for i in type1_arr:
			for j in type2_arr:
				if i == j:
					return true

		if include_instance_base:
			return ClassDB.is_parent_class(type1_arr[0], type2_arr[0]) or \
				ClassDB.is_parent_class(type2_arr[0], type1_arr[0]) 

	# failed, or didn't understand the types passed
	return false


# Compares to variant's types to each other.
#
# use this function to determine if the values of two variables are of
# compatible types
static func value_types_compatible(
		value1,
		value2,
		include_instance_base = false) -> bool:

	return types_compatible(
		get_type(value1),
		get_type(value2),
		include_instance_base
	)

