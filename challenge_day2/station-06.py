import math

def station6_output(x: float) -> float:
    """Calculate the output as sine of the input (in radians)."""
    return math.sin(x)

# Given observations:
observations = [
    (0.3, 0.2955, 21),  # sample_in, sample_out, input
    (1.4, 0.9854, 66),
    (1.6, 0.9996, 12),
]

if __name__ == "__main__":
    for sample_in, sample_out, real_input in observations:
        expected_sample = station6_output(sample_in)
        real_output = station6_output(real_input)
        print(f"Sample In: {sample_in} | Sample Out: {sample_out} (calc {expected_sample:.4f})")
        print(f"Input: {real_input} | Output: {real_output:.4f}")
        print("-" * 50)
