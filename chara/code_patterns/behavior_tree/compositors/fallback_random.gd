@icon('../../icons/selector_random.svg')
class_name BehaviorFallbackRandom
extends BehaviorFallback
func start():
    shuffled_children = get_children()
    shuffled_children.shuffle()
    running_child=null
    next_child_index=0