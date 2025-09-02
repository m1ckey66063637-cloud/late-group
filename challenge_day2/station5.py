import re

def _normalize_name(name: str) -> str:
    return re.sub(r"[^A-Za-z]", "", name).lower()

def _pos(ch: str) -> int:
    return ord(ch) - 96

def solution_station_5(name: str) -> int:
    s = _normalize_name(name)
    if not s:
        return 0  

    first = _pos(s[0])
    last = _pos(s[-1])
    return (3 * last - first) % 9
