from enum import Enum, auto


def part_one(data):
    result = [[0,0] for i in range(max(map(len, data)))]
    for i in range(len(data)):
        for j in range(len(data[i])):
            result[j][int(data[i][j])] += 1
    
    gamma_rata = int("".join([str(i.index(max(i))) for i in result]), base=2)
    epsilon = int("".join([str(i.index(min(i))) for i in result]), base=2)

    return gamma_rata * epsilon


def part_two(data):
    def count(data):
        count = [[0,0] for i in range(max(map(len, data)))]
        for i in range(len(data)):
            for j in range(len(data[i])):
                count[j][int(data[i][j])] += 1
        return count
    
    class State(Enum):
        CO2_SCRUBBER_RATING = 0
        OXYGEN_GENERATOR_RATING = 1

    def aux(data, j=0, state=None):
        if len(data) == 1: return data
        if state == State.OXYGEN_GENERATOR_RATING:
            fun = max
        elif state == State.CO2_SCRUBBER_RATING:
            fun = min
        
        indices = []
        for i in count(data):
            if i[0] == i[1]:
                indices.append(state.value)
            else:
                indices.append(i.index(fun(i)))
        
        acc = []
        for i in range(len(data)):
            if int(data[i][j]) == int(indices[j]):
                acc.append(data[i])
        
        return aux(acc, j=(j + 1), state=state)
    
    oxygen_generator = int(aux(data, state=State.OXYGEN_GENERATOR_RATING)[0], base=2)
    co2_scrubber = int(aux(data, state=State.CO2_SCRUBBER_RATING)[0], base=2)

    return oxygen_generator * co2_scrubber


def main(file):
    data = []
    with open(f"{file}.txt") as f:
        for line in f:
            data.append(line.strip("\n"))
    
    print(part_two(data))


if __name__ == "__main__":
    main("input")