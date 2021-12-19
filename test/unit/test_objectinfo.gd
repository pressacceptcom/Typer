extends 'res://addons/gut/test.gd'

# |=========================================|
# |                                         |
# |           Press Accept: Typer           |
# |    Generalized Type Testing In Godot    |
# |                                         |
# |=========================================|
#
# This is a 'test suite' to be used by GUT to make sure the included source
# is operating correctly. This code was not developed using TDD methodologies,
# and so these tests most likely break some TDD rules.
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
# 1.0    06/04/2021    First Release
#

# |---------|
# | Imports |
# |---------|

# see test/Utilities.gd
var TestUtilities : Script = PressAccept_Typer_Test_Utilities
# shorthand or our library class
var ObjectInfo    : Script = PressAccept_Typer_ObjectInfo

var CustomScript : Script = \
	load('res://addons/PressAccept/Typer/test/unit/CustomScript.gd')
var CustomObject : Script = \
	load('res://addons/PressAccept/Typer/test/unit/CustomObject.gd')

# |-------|
# | Tests |
# |-------|
#
# Tests follow this format -
#
# static method   - test_<method_identifier>
#

func test_validate_signature() -> void:

	var method_info: Dictionary = \
		ObjectInfo.script_method_info(CustomScript) \
			[ObjectInfo.STR_SCRIPT_METHOD_INFO_METHOD]

	var tests: Dictionary = {
		[ [ {}, 1 ], method_info ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ [ {}, 1, null ], method_info ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ [ {} ], method_info ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			}
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'validate_signature'))


func test_script_has_method() -> void:

	var tests: Dictionary = {
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			ObjectInfo.STR_SCRIPT_METHOD_INFO_METHOD
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, ObjectInfo.STR_SCRIPT_METHOD_INFO_METHOD ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'custom_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'reference', true ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'unknown_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'script_has_method'))


func test_script_constant_info() -> void:

	var expectation: Dictionary = CustomScript.get_script_constant_map()

	expectation['CUSTOM_CONSTANT'] = 'custom'

	assert_eq_shallow(
		ObjectInfo.script_constant_info(
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd'
		),
		expectation
	)

	assert_eq_shallow(
		ObjectInfo.script_constant_info(CustomScript),
		expectation
	)


func test_script_method_info() -> void:

	for mask in [
			ObjectInfo.INT_ALL_METHODS_MASK,
			ObjectInfo.INT_STANDARD_METHODS_MASK,
			ObjectInfo.INT_USER_METHODS_MASK ]:

		var methods: Array = PressAccept_Typer_Typer.get_type_methods(
			CustomScript,
			false
		)

		var expectation: Dictionary = {}

		for method in methods:
			if method['flags'] & mask:
				expectation[method['name']] = method

		expectation['custom_method'] = {}

		assert_eq_deep(
			ObjectInfo.script_method_info(
				'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
				mask
			),
			expectation
		)

		assert_eq_deep(
			ObjectInfo.script_method_info(CustomScript, mask),
			expectation
		)

		methods = PressAccept_Typer_Typer.get_type_methods(
			CustomScript,
			true
		)

		expectation = {}

		for method in methods:
			if method['flags'] & mask:
				expectation[method['name']] = method

		expectation['custom_method'] = {}

		assert_eq_deep(
			ObjectInfo.script_method_info(CustomScript, mask, true),
			expectation
		)


func test_script_property_info() -> void:

	for mask in [
			ObjectInfo.INT_ALL_PROPERTIES_MASK,
			ObjectInfo.INT_STANDARD_PROPERTIES_MASK ]:

		var properties  : Array = CustomScript.get_script_property_list()
		var expectation : Dictionary = {}

		for property in properties:
			if property['usage'] & mask:
				expectation[property['name']] = property

		expectation['custom_property'] = {}

		assert_eq_deep(
			ObjectInfo.script_property_info(
				'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
				mask
			),
			expectation
		)

		assert_eq_deep(
			ObjectInfo.script_property_info(CustomScript, mask),
			expectation
		)


func test_script_has_property() -> void:

	var tests: Dictionary = {
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'a_property'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'a_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'custom_property'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'custom_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'non_property'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ CustomScript, 'non_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			}
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'script_has_property'))


func test_script_signal_info() -> void:

	var signals     : Array = CustomScript.get_script_signal_list()
	var expectation : Dictionary = {}

	for _signal in signals:
		expectation[_signal['name']] = _signal

	expectation['custom_signal'] = {}

	assert_eq_deep(
		ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd'
		),
		expectation
	)

	assert_eq_deep(
		ObjectInfo.script_signal_info(CustomScript),
		expectation
	)


func test_script_has_signal() -> void:

	var tests: Dictionary = {
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'a_signal'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'a_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'custom_signal'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ CustomScript, 'custom_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[
			'res://addons/PressAccept/Typer/test/unit/CustomScript.gd',
			'non_signal'
		]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ CustomScript, 'non_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			}
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'script_has_signal'))


func test_object_method_info() -> void:

	var obj = CustomObject.new()

	for mask in [
			ObjectInfo.INT_ALL_METHODS_MASK,
			ObjectInfo.INT_STANDARD_METHODS_MASK,
			ObjectInfo.INT_USER_METHODS_MASK ]:

		var methods     : Array      = obj.get_method_list()
		var expectation : Dictionary = {}

		for method in methods:
			if method['flags'] & mask:
				expectation[method['name']] = method

		expectation['custom_method'] = {}

		assert_eq_deep(
			ObjectInfo.object_method_info(obj, mask),
			expectation
		)


func test_object_property_info() -> void:

	var obj = CustomObject.new()

	for mask in [
			ObjectInfo.INT_ALL_PROPERTIES_MASK,
			ObjectInfo.INT_STANDARD_PROPERTIES_MASK ]:

		var properties  : Array      = obj.get_property_list()
		var expectation : Dictionary = {}

		for property in properties:
			if property['usage'] & mask:
				expectation[property['name']] = property

		expectation['custom_property'] = {}

		assert_eq_deep(
			ObjectInfo.object_property_info(obj, mask),
			expectation
		)


func test_object_has_property() -> void:

	var obj = CustomObject.new()

	var tests: Dictionary = {
		[ obj, 'a_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ obj, 'custom_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ obj, 'non_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			}
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'object_has_property'))


func test_object_signal_info() -> void:

	var obj = CustomObject.new()

	var signals     : Array      = obj.get_signal_list()
	var expectation : Dictionary = {}

	for _signal in signals:
		expectation[_signal['name']] = _signal

	expectation['custom_signal'] = {}

	assert_eq_deep(
		ObjectInfo.object_signal_info(obj),
		expectation
	)


func test__init() -> void:

	var object_info: PressAccept_Typer_ObjectInfo = \
		ObjectInfo.new(CustomObject.new(), false)

	assert_false(
		object_info.include_instance_base,
		'object_info.include_instance_base'
	)

	object_info = ObjectInfo.new(CustomObject.new(), true)

	assert_true(
		object_info.include_instance_base,
		'object_info.include_instance_base'
	)

# requires doubling, can't currently double static methods
#
#func test_value_setget() -> void:
#
#	assert_setget(ObjectInfo, 'value', 'set_value', 'get_value')


func test_set_value() -> void:

	var object_info: PressAccept_Typer_ObjectInfo = \
		ObjectInfo.new(CustomObject, false)

	var inheritances : Array      = \
		PressAccept_Typer_Typer.get_type_inheritance(CustomObject)
	var constants    : Dictionary = ObjectInfo.script_constant_info(CustomObject)
	var methods      : Dictionary = \
		ObjectInfo.script_method_info(
			CustomObject,
			ObjectInfo.INT_ALL_METHODS_MASK
		)
	var properties   : Dictionary = \
		ObjectInfo.script_property_info(
			CustomObject,
			ObjectInfo.INT_ALL_PROPERTIES_MASK
		)
	var signals      : Dictionary = ObjectInfo.script_signal_info(CustomObject)

	assert_eq_shallow(object_info.inheritances, inheritances)
	assert_eq_shallow(object_info.constants, constants)
	assert_eq_deep(object_info.methods, methods)
	assert_eq_deep(object_info.properties, properties)
	assert_eq_deep(object_info.signals, signals)

	object_info.value = CustomScript

	inheritances = \
		PressAccept_Typer_Typer.get_type_inheritance(CustomScript, false)
	constants    = ObjectInfo.script_constant_info(CustomScript)
	methods      = \
		ObjectInfo.script_method_info(
			CustomScript,
			ObjectInfo.INT_ALL_METHODS_MASK
		)
	properties   = \
		ObjectInfo.script_property_info(
			CustomScript,
			ObjectInfo.INT_ALL_PROPERTIES_MASK
		)
	signals      = ObjectInfo.script_signal_info(CustomScript)

	assert_eq_shallow(object_info.inheritances, inheritances)
	assert_eq_shallow(object_info.constants, constants)
	assert_eq_deep(object_info.methods, methods)
	assert_eq_deep(object_info.properties, properties)
	assert_eq_deep(object_info.signals, signals)

	object_info.value = null

	assert_eq_shallow(object_info.inheritances, [])
	assert_eq_shallow(object_info.constants, {})
	assert_eq_shallow(object_info.methods, {})
	assert_eq_shallow(object_info.properties, {})
	assert_eq_shallow(object_info.signals, {})

func test_obj_has_identifier() -> void:

	var object_info: PressAccept_Typer_ObjectInfo = \
		ObjectInfo.new(CustomObject.new(), false)

	var tests: Dictionary = {
		[ 'A_CONSTANT' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'NON_CONSTANT' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ 'a_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'custom_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'non_signal' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ 'a_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'custom_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'non_property' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		[ 'reference' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ '__object_method_info' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'custom_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ 'non_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
	}

	TestUtilities.batch(self, tests, funcref(object_info, 'obj_has_identifier'))


func test_validate_method_signature() -> void:

	var object_info: PressAccept_Typer_ObjectInfo = \
		ObjectInfo.new(CustomObject.new(), false)

	var tests: Dictionary = {
		[ [ 'test', 5 ], 'a_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.TRUE
			},
		[ [ 'test', 5 ], 'non_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			},
		# This test shouldn't pass, but it does because type == 0
		#
		#[ [ 5, 'test' ], 'a_method' ]:
		#	{
		#		TestUtilities.ASSERTION: TestUtilities.FALSE
		#	},
		[ [ 'test', 5, null ], 'a_method' ]:
			{
				TestUtilities.ASSERTION: TestUtilities.FALSE
			}
	}

	TestUtilities.batch(
		self,
		tests,
		funcref(object_info, 'validate_method_signature')
	)

