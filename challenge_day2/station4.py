def solution_station_4(sample_input: int, real_input: int) -> bool:
    
    try:
        return (real_input % sample_input) == 0
    except ZeroDivisionError:
        # If sample_input is zero, treat as not divisible
        return False
