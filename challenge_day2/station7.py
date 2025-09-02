def solution_station_7(expr: str) -> float:
    a = 3
    b = -1
    c = 4
    d = 7
    e = 0.5

    values = {"a": a, "b": b, "c": c, "d": d, "e": e}
    
    return eval(expr, {}, values)


if __name__ == "__main__":
    test_exprs = ["d+b*c*e", "a+e", "d*e+b"]
    for expr in test_exprs:
        result = solution_station_7(expr)
        print(f"{expr} = {result}")
