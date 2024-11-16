@tool
extends Resource

class_name CmdStyle

"""
CmdStyle Resource

This resource defines the color scheme for the command interface.
The default colors are set to a blue on black theme, similar to Fedora and Godot combined.
"""

@export var background_color: Color = Color(0.117, 0.117, 0.117, 1.0)  # background color (dark gray/black)
@export var main_text_color: Color = Color(0.341, 0.612, 0.839, 1.0)  # main text color (light blue)
@export var secondary_text_color: Color = Color(0.612, 0.863, 0.996, 1.0)  # secondary text color (lighter blue)
@export var tertiary_text_color: Color = Color(0.306, 0.788, 0.690, 1.0)  # tertiary text color (aqua)
@export var quaternary_text_color: Color = Color(0.863, 0.863, 0.667, 1.0)  # quaternary text color (light yellow)
@export var quinary_text_color: Color = Color(0.773, 0.525, 0.753, 1.0)  # quinary text color (light purple)

# Method to color text with the main text color
func color_main_text(text: String) -> String:
	return "[color=%s]%s[/color]" % [main_text_color.to_html(), text]

# Method to color text with the secondary text color
func color_secondary_text(text: String) -> String:
	return "[color=%s]%s[/color]" % [secondary_text_color.to_html(), text]

# Method to color text with the tertiary text color
func color_tertiary_text(text: String) -> String:
	return "[color=%s]%s[/color]" % [tertiary_text_color.to_html(), text]

# Method to color text with the quaternary text color
func color_quaternary_text(text: String) -> String:
	return "[color=%s]%s[/color]" % [quaternary_text_color.to_html(), text]

# Method to color text with the quinary text color
func color_quinary_text(text: String) -> String:
	return "[color=%s]%s[/color]" % [quinary_text_color.to_html(), text]

# Method to bold text
func bold_text(text: String) -> String:
	return "[b]%s[/b]" % text

# Method to italicize text
func italic_text(text: String) -> String:
	return "[i]%s[/i]" % text

# Method to color user input based on command elements
func color_command_input(command: String) -> String:
	var parser:ArgParser = ArgParser.new()
	var colored_command = ""
	var args = command.split(" ")
	parser.parse(args)

	colored_command += color_main_text(args[0])

	for i in range(1, args.size()):
		if args[i].begins_with("-"):
			colored_command += " " + color_secondary_text(args[i])
		else:
			colored_command += " " + color_tertiary_text(args[i])

	return colored_command
