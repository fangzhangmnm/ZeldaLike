# A Composite node controls the flow of execution of its children in a specific manner, 
# with possibly multiple children being executed at any one time.
class_name BehaviorCompositorParallel
extends BehaviorNode

var shuffled_children:Array[Node] = []
var running_children:Array[Node] = []
var next_child_index:int=0

func start():
    shuffled_children = get_children()
    running_children=[]
    next_child_index=0

func halt():
    halt_running_children_if_any()

func cleanup():
    assert(running_children.size()==0)

func halt_running_children_if_any():
    for child in running_children:
        child._halt()
    running_children=[]