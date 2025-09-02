
def main():
    # Define variables
    a = 3
    b = -1
    c = 4
    d = 7
    e = 0.5

    values = {"a": a, "b": b, "c": c, "d": d, "e": e}

    print("Defined variables:")
    for k, v in values.items():
        print(f"{k} = {v}")

    total = sum(values.values())
    average = total / len(values)
    maximum = max(values.values())
    minimum = min(values.values())

    print("\nCalculated results:")
    print(f"Sum = {total}")
    print(f"Average = {average}")
    print(f"Max = {maximum}")
    print(f"Min = {minimum}")

if __name__ == "__main__":
    main()
