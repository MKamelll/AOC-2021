import std.stdio;
import std.algorithm;
import std.array;
import std.file;
import std.conv;
import std.typecons;
import std.math;

alias Result = Tuple!(long, "pos", long, "fuel");

int[] fileToPos(string path)
{
    auto f = readText(path).split(",");
    auto result = f.map!(pos => to!int(pos)).array;
    return result;
}

auto maxTuple(Result[] tuples)
{
    Result maxT;
    foreach (t; tuples)
    {
        if (t.fuel > maxT.fuel) {
            maxT = t;
        }
    }

    return maxT;
}

Result partOne(int[] poss)
{
    long possMax = maxElement(poss);
    long currFuel;
    long bestPos;
    for (long i = 1; i < possMax; i++) {
        long[] fuel;
        foreach (p; poss) fuel ~= abs(p - i);

        long fuelSum = fuel.sum;
        if (currFuel <= 0 || currFuel > fuelSum) {
            currFuel = fuelSum;
            bestPos = i;
        }
    }

    return Result(bestPos, currFuel);
}

long sumTill(long num)
{
    return (num * (num + 1)) / 2;
}

Result partTwo(int[] poss)
{
    long possMax = maxElement(poss);
    long currFuel;
    long bestPos;
    for (long i = 1; i < possMax; i++) {
        long[] fuel;
        foreach (p; poss) fuel ~= sumTill(abs(p - i));

        long fuelSum = fuel.sum;
        if (currFuel <= 0 || currFuel > fuelSum) {
            currFuel = fuelSum;
            bestPos = i;
        }
    }

    return Result(bestPos, currFuel);
}

void main()
{
    auto poss = fileToPos("source/input.txt");
    writeln(partTwo(poss));
}
