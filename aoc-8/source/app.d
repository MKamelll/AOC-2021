import std.stdio;
import std.conv;
import std.file;
import std.array;
import std.string;
import std.algorithm;

class Display
{
    private string[] mSignal;
    private string[] mOutput;

    this (string[] signal, string[] output)
    {
        mSignal = signal;
        mOutput = output;
    }

    string[] signal()
    {
        return mSignal;
    }

    string[] output()
    {
        return mOutput;
    }

    override string toString()
    {
        return "Display(signal: "
            ~ to!string(mSignal) ~ ", output: " ~ to!string(mOutput) ~ ")";
    }
}

Display fileToDisplay(string path)
{
    if (path.canFind("test")) {
        auto f = readText(path).split("\n");
        string[] signal;
        string[] output;
        for (long i = 0; i < f.length; i++) {
            if (i % 2 == 0) {
                signal ~= f[i].strip(" |");
            } else {
                output ~= f[i];
            }
        }
        return new Display(signal, output);
    }

    auto f = File(path, "r").byLine;
    string[] signal;
    string[] output;
    foreach (line; f) {
        auto data = line.split("|");
        signal ~= to!string(data[0].strip);
        output ~= to!string(data[1].strip);
    }

    return new Display(signal, output);
}

long partOne(Display display)
{
    long result;
    foreach (output; display.output)
    {
        result += output.split(" ").filter!(output => [2, 3, 4, 7].canFind(output.length)).array.length;
    }
    return result;
}

// 2: 5
// 3: 5
// 5: 5

// 0: 6
// 6: 6
// 9: 6

auto stringIntersection(string s1, string s2)
{
    return setIntersection(to!(char[])(s1).representation.sort.uniq,
        to!(char[])(s2).representation.sort.uniq).array;
}

auto stringSetEqual(string s1, string s2)
{
    return to!(char[])(s1).representation.sort.uniq == to!(char[])(s2).representation.sort.uniq;
}

auto partTwo(Display display)
{
    string[int] map;
    int[][] numbers;

    foreach (i, input; display.signal)
    {
        auto inputArr = input.split(" ");
        foreach (signal; inputArr)
        {
            switch (signal.length) {
                case 2: map[1] = signal; break;
                case 3: map[7] = signal; break;
                case 4: map[4] = signal; break;
                case 7: map[8] = signal; break;
                default: break;
            }
        }
        
        foreach (signal; inputArr)
        {
            if (signal.length == 6) {
                if (stringIntersection(signal, map[4]).length == 4) {
                    map[9] = signal;
                } else if (stringIntersection(signal, map[1]).length == 2) {
                    map[0] = signal;
                } else {
                    map[6] = signal;
                }
            }
        }

        foreach (signal; inputArr)
        {
            if (signal.length == 5) {
                if (stringIntersection(signal, map[1]).length == 2) {
                    map[3] = signal;
                } else if (stringIntersection(signal, map[6]).length == 5) {
                    map[5] = signal;
                } else {
                    map[2] = signal;
                }
            }    
        }

        int[] number;
        auto outArr = display.output[i].split(" ");
        foreach (output; outArr)
        {
            foreach (num, signal; map)
            {
                if (stringSetEqual(signal, output)) {
                    number ~= num;
                }
            }
        }
        numbers ~= number;
    }

    ulong result;

    foreach (arr; numbers)
    {
        result += to!ulong(arr.map!(ch => to!string(ch)).array.join(""));
    }

    return result;
}

void main()
{
    auto display = fileToDisplay("source/input.txt");
    writeln(partTwo(display));
}
