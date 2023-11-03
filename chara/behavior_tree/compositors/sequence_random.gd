@icon('../icons/sequence_random.svg')
class_name BehaviorSequenceRandom
extends BehaviorSequence

func start():
    shuffled_children = get_children()
    shuffled_children.shuffle()
    running_child=null
    next_child_index=0