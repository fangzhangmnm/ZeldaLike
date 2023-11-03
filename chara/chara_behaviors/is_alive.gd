extends CharaBehaviorCondition

func condition():
    return not chara.is_dead()
