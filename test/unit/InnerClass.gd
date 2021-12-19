tool

class InnerClass:

	func _init() -> void:
		pass


class InheritedInnerClass:
	extends 'res://addons/PressAccept/Typer/test/unit/Inherited.gd'

	func _init() -> void:
		pass


class CustomInnerClass:

	func __class_name() -> String:
		return 'CustomInnerClass'

