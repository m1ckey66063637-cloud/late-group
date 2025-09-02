import math

def solution_station_6(x: float) -> float:
    
    return math.sin(x)


if __name__ == "__main__":
    
    observations = [
        (0.3, 0.2955, 21),
        (1.4, 0.9854, 66),
        (1.6, 0.9996, 12),
    ]
    for sample_in, sample_out, real_input in observations:
        expected_sample = solution_station_6(sample_in)
        real_output = solution_station_6(real_input)
        print(f"Sample In: {sample_in} | Sample Out: {sample_out} (calc {expected_sample:.4f})")
        print(f"Input: {real_input} | Output: {real_output:.4f}")
        print("-" * 50)

