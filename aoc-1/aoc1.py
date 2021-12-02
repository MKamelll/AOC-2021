def part_one(data):
    result = 0
    for i in range(len(data)):
        if i + 1 < len(data) and data[i + 1] > data[i]:
            result += 1
    return result

# recursion overflow
def part_two(data, curr_sum = 0, result = 0, memo=None):
    if not memo: memo = {}
    if len(data) < 3: return result
    
    next_pair = (data[1], data[2])
    if next_pair not in memo:
        memo[next_pair] = next_pair[0] + next_pair[1]

    summ = data[0] + memo[next_pair]
    if summ > curr_sum:
        result += 1
    elif summ < curr_sum:
        result -= 1
    curr_sum = summ
    return part_two(data[1:], curr_sum, result, memo)

def part_two_iter(data):
    curr_sum = sum(data[0:3])
    result = 0
    i = 1
    while (i + 3) <= len(data):
        summ = sum(data[i:i+3])
        if summ > curr_sum:
            result += 1
        
        curr_sum = summ
        i += 1
        #print(summ, result)

    return result

def main():
    data = []
    with open("input.txt") as f:
        for line in f:
            data.append(int(line))
    
    #print(part_two(data))
    print(part_two_iter(data))

if __name__ == "__main__":
    main()