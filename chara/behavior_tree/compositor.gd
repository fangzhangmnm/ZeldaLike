# A Composite node controls the flow of execution of its children in a specific manner, 
# with only one child being executed at any one time.
@icon('./icons/category_composite.svg')
class_name BehaviorCompositor
extends BehaviorNode

var shuffled_children:Array[Node] = []
var running_child:BehaviorNode=null
var next_child_index:int=0

func start():
    assert(get_child_count()>0,"Composite node must have at least one child")
    for child in get_children():child._set_parent(self)
    shuffled_children = get_children()
    running_child=null
    next_child_index=0

func halt():
    halt_running_child_if_any()

func cleanup():
    assert(running_child==null)

func halt_running_child_if_any():
    if running_child:
        running_child.halt()
        running_child=null
