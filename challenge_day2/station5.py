def station5(name1: str, name2: str) -> int:
    set1 = set(name1.lower().replace(" ", ""))
    set2 = set(name2.lower().replace(" ", ""))
    return len(set1 & set2)

