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
# shorthand for our library class
var Typer         : Script = PressAccept_Typer_Typer

# |---------------|
# | Configuration |
# |---------------|

# random seed for deterministic randomized tests
var INT_RANDOM_SEED : int = hash('PressAccept_Typer_Typer')

# |-------|
# | Tests |
# |-------|
#
# Tests follow this format -
#
# static method   - test_<method_identifier>
#

func test_type2str() -> void:

	var tests: Dictionary = {
		[ -1 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : Typer.STR_UNKNOWN
			},
		[ 27 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : Typer.STR_UNKNOWN
			}
	}

	for i in range(Typer.ARR_TYPES.size()):
		tests[[ i ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : Typer.ARR_TYPES[i]
		}

	TestUtilities.batch(self, tests, funcref(Typer, 'type2str'))


func test_str2type() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var tests: Dictionary = {
		[ 'random' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : -1
			},
	}

	for i in range(Typer.ARR_TYPES.size()):
		var key  : String = Typer.ARR_TYPES[i]
		var beg  : int    = random.randi_range(0, key.length())
		var _len : int    = random.randi_range(0, key.length())

		key = key.replace(
			key.substr(beg, _len),
			key.substr(beg, _len).to_upper()
		)

		tests[[ key ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : i
		}

	TestUtilities.batch(self, tests, funcref(Typer, 'str2type'))


func test_normalize_type_to_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var tests: Dictionary = {
		[ 'random' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : Typer.STR_UNKNOWN
			},
	}

	for i in range(Typer.ARR_TYPES.size()):
		var key  : String = Typer.ARR_TYPES[i]
		var beg  : int    = random.randi_range(0, key.length())
		var _len : int    = random.randi_range(0, key.length())

		key = key.replace(
			key.substr(beg, _len),
			key.substr(beg, _len).to_upper()
		)

		tests[[ i ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : Typer.ARR_TYPES[i]
		}

		tests[[ key ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : Typer.ARR_TYPES[i]
		}

	TestUtilities.batch(self, tests, funcref(Typer, 'normalize_type_to_str'))


func test_normalize_type_to_int() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var tests: Dictionary = {
		[ -1 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : -1
			},
		[ Typer.ARR_TYPES.size() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : -1
			}
	}

	for i in range(Typer.ARR_TYPES.size()):
		var key  : String = Typer.ARR_TYPES[i]
		var beg  : int    = random.randi_range(0, key.length())
		var _len : int    = random.randi_range(0, key.length())

		key = key.replace(
			key.substr(beg, _len),
			key.substr(beg, _len).to_upper()
		)

		tests[[ i ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : i
		}

		tests[[ key ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : i
		}

	TestUtilities.batch(self, tests, funcref(Typer, 'normalize_type_to_int'))


func test_is_indexable() -> void:

	var tests: Dictionary = {
		[ -1 ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
		[ Typer.STR_RESID ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Typer.ENUM_TYPES.ARRAY ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'random' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'res://addons/PressAccept/Typer/test/unit/Indexable.gd' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(Typer, 'is_indexable'))


func test_type_to_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var tests: Dictionary = {
		[ -1 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : Typer.STR_UNKNOWN
			},
		[ Typer.ARR_TYPES.size() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : Typer.STR_UNKNOWN
			},
		[ 'Node' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'Node'
			},
		[ 'BuiltInClass' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'BuiltInClass'
			},
		[ 'res://addons/PressAccept/Typer/test/unit/Indexable.gd' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 
					'res://addons/PressAccept/Typer/test/unit/Indexable.gd'
			},
		[ 'res://random/nonexistent' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'res://random/nonexistent'
			}
	}

	for i in range(Typer.ARR_TYPES.size()):
		var key  : String = Typer.ARR_TYPES[i]
		var beg  : int    = random.randi_range(0, key.length())
		var _len : int    = random.randi_range(0, key.length())

		key = key.replace(
			key.substr(beg, _len),
			key.substr(beg, _len).to_upper()
		)

		tests[[ i ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : Typer.ARR_TYPES[i]
		}

		tests[[ key ]] = {
			TestUtilities.ASSERTION   : TestUtilities.EQUALS,
			TestUtilities.EXPECTATION : Typer.ARR_TYPES[i]
		}

	TestUtilities.batch(self, tests, funcref(Typer, 'type_to_str'))


func _random_except(
		rng       : RandomNumberGenerator,
		exception : int,
		min_int   : int = 0,
		max_int   : int = Typer.ARR_TYPES.size() - 1) -> int:

	var ret: int = rng.randi_range(min_int, max_int)

	while ret == exception:
		ret = rng.randi_range(min_int, max_int)

	return ret


func test_is_type() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var Inherited: Script = \
		load('res://addons/PressAccept/Typer/test/unit/Inherited.gd')

	var tests: Dictionary = {
		[ null, Typer.ARR_TYPES[Typer.ENUM_TYPES.NULL] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ null, _random_except(random, Typer.ENUM_TYPES.NULL) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ null, 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ null, 'res://addons/PressAccept/Typer/test/unit/Indexable.gd' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ false, Typer.ARR_TYPES[Typer.ENUM_TYPES.BOOL] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ false, _random_except(random, Typer.ENUM_TYPES.BOOL) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 0, Typer.ARR_TYPES[Typer.ENUM_TYPES.INT] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 0, _random_except(random, Typer.ENUM_TYPES.INT) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 0.5, Typer.ARR_TYPES[Typer.ENUM_TYPES.FLOAT] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 0.5, _random_except(random, Typer.ENUM_TYPES.FLOAT) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'test', Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'test', _random_except(random, Typer.ENUM_TYPES.STRING) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Vector2(0, 0), Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR2] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Vector2(0, 0), _random_except(random, Typer.ENUM_TYPES.VECTOR2) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Rect2(0, 0, 0, 0), Typer.ARR_TYPES[Typer.ENUM_TYPES.RECT2] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Rect2(0, 0, 0, 0), _random_except(random, Typer.ENUM_TYPES.RECT2) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Vector3(0, 0, 0), Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR3] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Vector3(0, 0, 0), _random_except(random, Typer.ENUM_TYPES.VECTOR3) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			Transform2D(0, Vector2(0, 0)),
			Typer.ARR_TYPES[Typer.ENUM_TYPES.TRANSFORM2D]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Transform2D(0, Vector2(0, 0)),
			_random_except(random, Typer.ENUM_TYPES.TRANSFORM2D)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Plane(0, 0, 0, 0), Typer.ARR_TYPES[Typer.ENUM_TYPES.PLANE] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Plane(0, 0, 0, 0), _random_except(random, Typer.ENUM_TYPES.PLANE) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Quat(0, 0, 0, 0), Typer.ARR_TYPES[Typer.ENUM_TYPES.QUAT] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Quat(0, 0, 0, 0), _random_except(random, Typer.ENUM_TYPES.QUAT) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			AABB(Vector3(0, 0, 0), Vector3(0, 0, 0)),
			Typer.ARR_TYPES[Typer.ENUM_TYPES.AABBOX]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			AABB(Vector3(0, 0, 0), Vector3(0, 0, 0)),
			_random_except(random, Typer.ENUM_TYPES.AABBOX)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			Basis(Vector3(0, 0, 0)),
			Typer.ARR_TYPES[Typer.ENUM_TYPES.BASIS]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Basis(Vector3(0, 0, 0)),
			_random_except(random, Typer.ENUM_TYPES.BASIS)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			Transform(Basis(Vector3(0, 0, 0))),
			Typer.ARR_TYPES[Typer.ENUM_TYPES.TRANSFORM]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Transform(Basis(Vector3(0, 0, 0))),
			_random_except(random, Typer.ENUM_TYPES.TRANSFORM)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Color(0), Typer.ARR_TYPES[Typer.ENUM_TYPES.COLOR] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Color(0), _random_except(random, Typer.ENUM_TYPES.COLOR) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ NodePath('.'), Typer.ARR_TYPES[Typer.ENUM_TYPES.NODEPATH] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ NodePath('.'), _random_except(random, Typer.ENUM_TYPES.NODEPATH) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
			
		# no constructor of 'RID' matches the signature Object?
		
		#[ RID(self as Object), Typer.ARR_TYPES[Typer.ENUM_TYPES.RESID] ]:
		#	{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		#[ RID(self), _random_except(random, Typer.ENUM_TYPES.RESID) ]:
		#	{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		
		[ self, Typer.ARR_TYPES[Typer.ENUM_TYPES.OBJECT] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ self, _random_except(random, Typer.ENUM_TYPES.OBJECT) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ {'test': 1}, Typer.ARR_TYPES[Typer.ENUM_TYPES.DICT] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ {'test': 1}, _random_except(random, Typer.ENUM_TYPES.DICT) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ [ 0, 1, 2 ], Typer.ARR_TYPES[Typer.ENUM_TYPES.ARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ [ 0, 1, 2 ], _random_except(random, Typer.ENUM_TYPES.ARRAY) ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolByteArray(), Typer.ARR_TYPES[Typer.ENUM_TYPES.BYTEARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolByteArray(),
			_random_except(random, Typer.ENUM_TYPES.BYTEARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolIntArray(), Typer.ARR_TYPES[Typer.ENUM_TYPES.INTARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolIntArray(),
			_random_except(random, Typer.ENUM_TYPES.FLOATARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolRealArray(), Typer.ARR_TYPES[Typer.ENUM_TYPES.FLOATARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolRealArray(),
			_random_except(random, Typer.ENUM_TYPES.FLOATARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolStringArray(), Typer.ARR_TYPES[Typer.ENUM_TYPES.STRINGARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolStringArray(),
			_random_except(random, Typer.ENUM_TYPES.STRINGARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolVector2Array(), Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR2ARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolVector2Array(),
			_random_except(random, Typer.ENUM_TYPES.VECTOR2ARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolVector3Array(), Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR3ARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolVector3Array(),
			_random_except(random, Typer.ENUM_TYPES.VECTOR3ARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ PoolColorArray(), Typer.ARR_TYPES[Typer.ENUM_TYPES.COLORARRAY] ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			PoolColorArray(),
			_random_except(random, Typer.ENUM_TYPES.COLORARRAY)
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Node.new(), 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Node.new(), 'Node2D' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Control.new(), 'Control' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Reference.new(), 'Control' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Reference.new(), Typer.ENUM_TYPES.INT]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			Reference.new(),
			'res://addons/PressAccept/Typer/test/unit/Indexable.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		
		# test built-in class inheritance
		[ Node2D.new(), 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		
		# custom scripts
		[
			Inherited.new(),
			'res://addons/PressAccept/Typer/test/unit/Inherited.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Inherited.new(),
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Inherited.new(), 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		# built-in class
		[ Inherited.new(), 'Reference' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		# inheritance
		[
			Inherited.new(),
			'res://addons/PressAccept/Typer/test/unit/Indexable.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE }
		
	}

	TestUtilities.batch(self, tests, funcref(Typer, 'is_type'))


func test_get_type() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var Inherited: Script = \
		load('res://addons/PressAccept/Typer/test/unit/Inherited.gd')

	var tests: Dictionary = {
		[ null ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.NULL]
			},
		[ false ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.BOOL]
			},
		[ 0 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.INT]
			},
		[ 0.5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.FLOAT]
			},
		[ 'test' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING]
			},
		[ Vector2(0, 0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR2]
			},
		[ Rect2(0, 0, 0, 0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.RECT2]
			},
		[ Vector3(0, 0, 0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR3]
			},
		[ Transform2D(0, Vector2(0, 0)) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.TRANSFORM2D]
			},
		[ Plane(0, 0, 0, 0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.PLANE]
			},
		[ Quat(0, 0, 0, 0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.QUAT]
			},
		[ AABB(Vector3(0, 0, 0), Vector3(0, 0, 0)) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.AABBOX]
			},
		[ Basis(Vector3(0, 0, 0)) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.BASIS]
			},
		[ Transform(Basis(Vector3(0, 0, 0))) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.TRANSFORM]
			},
		[ Color(0) ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.COLOR]
			},
		[ NodePath('.') ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.NODEPATH]
			},
		[ { 'test': 1 } ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.DICT]
			},
		[ [ 0, 1, 2 ] ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.ARRAY]
			},
		[ PoolByteArray() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.BYTEARRAY]
			},
		[ PoolIntArray() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.INTARRAY]
			},
		[ PoolRealArray() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.FLOATARRAY]
			},
		[ PoolStringArray() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.STRINGARRAY]
			},
		[ PoolVector2Array() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR2ARRAY]
			},
		[ PoolVector3Array() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.VECTOR3ARRAY]
			},
		[ PoolColorArray() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					Typer.ARR_TYPES[Typer.ENUM_TYPES.COLORARRAY]
			},
		[ Node.new() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'Node'
			},
		[ Node2D.new() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'Node2D'
			},
		[ self ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					'res://addons/PressAccept/Typer/test/unit/test_typer.gd'
			},
		[ Inherited.new() ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : \
					'res://addons/PressAccept/Typer/test/unit/Inherited.gd'
			}
	}

	TestUtilities.batch(self, tests, funcref(Typer, 'get_type'))


func test_types_compatible() -> void:

	var Nonindexable : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Nonindexable.gd')
	var Indexable    : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Indexable.gd')
	var Inherited    : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Inherited.gd')

	var TestNode   : Script = \
		load('res://addons/PressAccept/Typer/test/unit/TestNode.gd')
	var TestNode2D : Script = \
		load('res://addons/PressAccept/Typer/test/unit/TestNode2D.gd')

	var tests: Dictionary = {
		[ Typer.ENUM_TYPES.NULL, Typer.ENUM_TYPES.NULL ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Typer.ENUM_TYPES.NULL, Typer.ENUM_TYPES.INT ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Typer.ENUM_TYPES.INT, Typer.ENUM_TYPES.INT ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING],
			Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING],
			Typer.ARR_TYPES[Typer.ENUM_TYPES.INT]
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'Node', 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'Node', 'Reference' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'Node2D', 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'Node', 'Node2D' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'Node', Typer.ENUM_TYPES.INT ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'Node', Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING] ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Nonindexable, Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable, Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Indexable, Inherited ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Typer.ENUM_TYPES.INT, Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable, Typer.ENUM_TYPES.INT ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable, Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING] ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Typer.ARR_TYPES[Typer.ENUM_TYPES.STRING], Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable, 'Node' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'Node', Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },

		# don't have to pass true if one of the types is a built-in class
		[ Indexable, 'Reference' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },

		[ Indexable, 'res://addons/PressAccept/Typer/test/unit/Indexable.gd' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Indexable,
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'res://addons/PressAccept/Typer/test/unit/Indexable.gd', Indexable ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd',
			Indexable
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd',
			Indexable,
			true
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			Indexable,
			'res://addons/PressAccept/Typer/test/unit/Inherited.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			'res://addons/PressAccept/Typer/test/unit/Indexable.gd',
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[
			'res://addons/PressAccept/Typer/test/unit/Indexable.gd',
			'res://addons/PressAccept/Typer/test/unit/Nonindexable.gd',
			true
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[
			'res://addons/PressAccept/Typer/test/unit/Indexable.gd',
			'res://addons/PressAccept/Typer/test/unit/Inherited.gd'
		]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ TestNode, TestNode2D ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ TestNode, TestNode2D, true ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE }
	}

	TestUtilities.batch(self, tests, funcref(Typer, 'types_compatible'))


func test_value_types_compatible() -> void:

	var Nonindexable : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Nonindexable.gd')
	var Indexable    : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Indexable.gd')
	var Inherited    : Script = \
		load('res://addons/PressAccept/Typer/test/unit/Inherited.gd')

	var TestNode   : Script = \
		load('res://addons/PressAccept/Typer/test/unit/TestNode.gd')
	var TestNode2D : Script = \
		load('res://addons/PressAccept/Typer/test/unit/TestNode2D.gd')

	var tests: Dictionary = {
		[ null, null ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ null, 5 ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 5, 7 ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'test', 'value' ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 'test', 7 ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Node.new(), Node.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Node.new(), Reference.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Node2D.new(), Node.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Node.new(), Node2D.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Node.new(), 5 ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Node.new(), 'test' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Nonindexable.new(), Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable.new(), Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ Indexable.new(), Inherited.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ 5, Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable.new(), 5 ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable.new(), 'test' ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ 'test', Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Indexable.new(), Node.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Node.new(), Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },

		# a built-in class without a script defaults the test to built-in class
		[ Indexable.new(), Reference.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },

		# a built-in class with script won't default test against built-in
		[ Nonindexable.new(), Indexable.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ Nonindexable.new(), Indexable.new(), true ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE },
		[ TestNode.new(), TestNode2D.new() ]:
			{ TestUtilities.ASSERTION: TestUtilities.FALSE },
		[ TestNode.new(), TestNode2D.new(), true ]:
			{ TestUtilities.ASSERTION: TestUtilities.TRUE }
	}

	TestUtilities.batch(self, tests, funcref(Typer, 'value_types_compatible'))

