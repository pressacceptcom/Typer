# Press Accept: Typer
## Generalized Type Testing In Godot

This module provides functions to determine/evaluate GDScript types.

Even though GDScript is a dynamically typed language, sometimes we'd like to know about a variable's type and even compare/process that type. These utility functions utilize various means to determine a variable's type, from determining if it's a built-in type, to a built-in class (such as Node), to a custom script (attached/unattached to a node). Information on these three different sorts of type information come from different sources. These static functions hope to make sorting through these layers more intuitive and easy.

The idea is that we normalize type values to 'cascade' against these layers. Retrieving each layer separately is achievable through existing GDScript functions, but returning the most specific information (if it has a script, that script, if it's a built-in class, that class, or if its a primitive, the primitive) given any particular value, and comparing that information is unique to this library.

The "layers" of type are as follows:

- A built-in primitive type, unrelated to the next two, identified ultimately by an integer constant (here translated into a string constant).
- A built in class derived from (or is) Object, these are only identified by strings as their class name.
- A script that may or may not identify a class that may or may not inherit from classes defined in other scripts. These are only identified by strings but unlike classes, they are always identified by their resource path: res://.... (some scripts have class_names, some don't)

Inner classes in this system will return the string version of their base class if they don't inherit from another script, otherwise they'll return a script path, like other objects. You can customize the inner classes value that's returned for its type by using a custom property with an identifier equivalent to STR_CUSTOM_CLASS (__class_name)

Type expects to be installed at:

- res://addons/PressAccept/Typer/

### Documentation

Here Typer -> PressAccept_Typer_Typer

Typer.ENUM_TYPES mirrors TYPE_* global constants.

Typer.ARR_TYPES gives a human friendly string representation at Typer.ENUM_TYPES index. (Typer.ARR_TYPES_ENUM give a string equivalent equal to their identifier )

Typer.DICT_PRIMITIVES has ENUM_TYPES as indices and string representations as values of data types that have no callable methods or constants

Typer.DICT_CASTABLE has ENUM_TYPES as indices and string representations as values of data types that can be cast to one another.

Typer.DICT_INDEXABLE has ENUM_TYPES as indices and string representations as values of data types that can be indexed using the GDScript [] operator.

is_primitive(), is_castbale(), and is_indexable() test for membership in these dictionaries. is_indexable() will also return true if the value of STR_INDEXABLE is defined as a constant in a given class. NOTE: only define this constant in a class if the static indexable() function returns the indexable value given an instance.

You can use type2str, str2type, normalize_type_to_str, and normalize_type_to_int to convert between ENUM_TYPES and human friendly String representations, but type_to_str should be your go to for normalizing as it also will accept Script objects and normalize them to their resource paths.

Use is_type() to verify a value against a given type (int, String, or Script). Use get_type() to retrieve a variable's type in normalized String format. Use types_compatible() to determine if two types (not values) are equivalent or have a common ancestor, and value_types_compatible() to do the same for two values (and their types)

NOTE: if you don't pass true to the third argument of types_compatible() or value_types_compatible() then Script's will only compare their inheritance paths on the 'script layer'. If you desire for two scripts that extend Reference, for example, to be equivalent because of the built-in class Reference you must pass true for include_instance_base.

### Testing

This package uses the GUT testing framework to ensure that the script is working as intended. This module was not developed with TDD practices, and so, the tests themselves most likely break some TDD rules. They are there more to ensure proper behavior, and not as part of some larger conceptual framework.

### Side Effects

Creates the following class names:

- PressAccept\_Typer\_Typer

### Meta Information

#### Namespace

- Organization Namespace: PressAccept
- Package Namespace: Typer
- Class: Typer

#### Organization Information

- Organization - Press Accept
- Organization URI - https://pressaccept.com/
- Organization Social - [@pressacceptcom](https://twitter.com/pressacceptcom)

#### Author Information

- Author - Asher Kadar Wolfstein
- Author URI - https://wunk.me/
- Author Social - https://incarnate.me/members/asherwolfstein/, [@asherwolfstein](https://twitter.com/asherwolfstein)

#### Copyright And License

- Copyright - Press Accept: Byter © 2021 The Novelty Factor LLC, (Press Accept, Asher Kadar Wolfstein)
- License - MIT (see LICENSE)

### Changelog

1.0.0 06/04/2021 First Release

### Notes On Style

I knowingly took liberties with the Godot Coding Style Guide. It's easier on my eyes despite its collaborative drawbacks. Therefore, there is no need to notify me that it doesn't follow the style guide.
