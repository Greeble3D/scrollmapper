# Argument Parser Addon for Godot 4.3

## Overview

This addon provides a robust argument parser for GDScript, allowing you to handle command-line arguments similar to those used in Linux.

## Installation

1. Copy the `addons/arg_parser` folder to your project's `addons` directory.
2. Enable the addon in the Project Settings under the `Plugins` tab.

## Usage

Here's how to use the `ArgParser` in your project:

```gdscript
extends Node

func _ready():
	var parser = ArgParser.new()
	parser.add_option("-o", "--output", "Output file", "default_output.txt")
	parser.add_option("-i", "--input", "Input file")
	parser.add_flag("-v", "--verbose", "Enable verbose mode")

	var args = ["-o", "output.txt", "-i", "input.txt", "-v"]
	parser.parse(args)

	print("Output file: %s" % parser.get_option("-o"))
	print("Input file: %s" % parser.get_option("-i"))
	print("Verbose mode: %s" % parser.get_flag("-v"))

	parser.print_help()
```
## API
```
add_option(short_flag: String, long_flag: String, description: String, default_value=null)
```
Adds an option that requires a value.

```
add_flag(short_flag: String, long_flag: String, description: String)
```
Adds a flag that does not require a value.

```
parse(args: Array)
```
Parses the command-line arguments.

```
get_option(short_flag: String)
```
Retrieves the value of a specified option.

```
get_flag(short_flag: String)
```
Checks if a specified flag is set.

```
print_help()
```
Prints the help message showing all options and flags.
