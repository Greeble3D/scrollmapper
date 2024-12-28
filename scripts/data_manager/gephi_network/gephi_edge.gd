extends GephiObject 

## A valid gephi edge / connection object that can be used in a gephi network.

class_name GephiEdge

var source: int = 0
var target: int = 0
var weight: float = 1.0

func get_source() -> int:
    return source

func get_target() -> int:
    return target

func get_weight() -> float:
    return weight