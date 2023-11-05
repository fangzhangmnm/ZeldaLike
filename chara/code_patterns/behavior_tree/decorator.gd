# A Decorator node controls the flow of execution of its child in a specific manner
@icon('../icons/category_decorator.svg')
class_name BehaviorDecorator
extends BehaviorNode

var running_child:BehaviorNode=null

func start():
    assert(get_child_count()==1,"Decorator must have exactly one child")
    get_child(0)._set_parent(self)
    running_child=null

func halt():
    halt_running_child_if_any()

func cleanup():
    assert(running_child==null)

func halt_running_child_if_any():
    if running_child:
        running_child.halt()
        running_child=null