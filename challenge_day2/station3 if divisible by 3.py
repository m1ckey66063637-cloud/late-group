import random
import os

def solution_station_3(value: int) -> bool:
    return random.choice([True, False])

def random_input_station_3():
    return random.randint(10000, 99999)

def display_station_3():
    sample_input = random.randint(1, 99)
    sample_output = random.choice([True, False])

    real_input = random_input_station_3()
    real_output = solution_station_3(real_input)

    print("="*50)
    print("Station 3 - Robot Camp Observation Challenge")
    print(f"{'Sample Input':<15} | {sample_input}")
    print(f"{'Sample Output':<15} | {sample_output}")
    print(f"{'Input':<15} | {real_input}")
    print(f"{'Output':<15} | {real_output}")
    print("="*50)


if __name__ == "__main__":
    os.system("cls" if os.name == "nt" else "clear")
    for _ in range(3):
        display_station_3()



