def part_one(pairs):
    horizontal = 0
    depth = 0
    for pair in pairs:
        mov, val = pair
        if mov == "forward":
            horizontal += val
        elif mov == "up":
            depth -= val
        elif mov == "down":
            depth += val
    
    return horizontal * depth

def part_two(pairs):
    horizontal = 0
    depth = 0
    aim = 0
    for pair in pairs:
        mov, val = pair
        if mov == "forward":
            horizontal += val
            depth += (aim * val)
        elif mov == "up":
            aim -= val
        elif mov == "down":
            aim += val
    
    return horizontal * depth

def main():
    data = []
    with open("input.txt") as f:
        for line in f:
            data.append(line.strip('\n'))
    
    pairs = []
    for i in data:
        mov, val = i.split(" ")
        pairs.append((mov, int(val)))
    
    print(part_two(pairs))

if __name__ == "__main__":
    main()