def solution_station_4(sample_input: int, real_input: int) -> bool:
    from sympy import isprime
    if sample_input == 0:
        return False
    if real_input % sample_input != 0:
        return False
    return isprime(real_input // sample_input)

