def solution_station_4(sample_input: int, real_input: int) -> bool:
    """
    Station 4 Rule:
    Return True if real_input is divisible by sample_input,
    otherwise return False.

    Parameters
    ----------
    sample_input : int
        The Sample Input shown on the left side (e.g., 58, 50, 85, 15, 96, 8).
    real_input : int
        The Input shown on the right side (e.g., 3194, 5182, 6492, 4410, 1258, 8658).
    """
    try:
        return (real_input % sample_input) == 0
    except ZeroDivisionError:
        # If sample_input is zero, treat as not divisible
        return False
