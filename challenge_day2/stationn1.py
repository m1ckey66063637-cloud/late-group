def solution_station_1(n: int) -> int:
    
    if n < 0:
        raise ValueError("n cannot be negative")
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

if __name__ == "__main__":

    assert solution_station_1(18) == 2584

    print("passed")