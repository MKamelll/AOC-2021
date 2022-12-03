import std.stdio;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.typecons;

long[][] fileToPoints(string path)
{
    auto f = File(path).byLine;
    return f.map!(line => line.split("")).map!(list => list.map!(ch => to!long(ch)).array).array;
}

alias Point = Tuple!(long, "value", long, "x", long, "y");

auto partOne(long[][] positions)
{
    Point[] lowP;
    long[] currNbrs;
    for (long i = 0; i < positions.length; i++)
    {
        for (long j = 0; j < positions[i].length; j++) {
            if (j + 1 < positions[i].length) currNbrs ~= positions[i][j+1];
            if (j > 0) currNbrs ~= positions[i][j-1];
            if (i + 1 < positions.length) currNbrs ~= positions[i+1][j];
            if (i > 0) currNbrs ~= positions[i-1][j];
            if (positions[i][j] < minElement(currNbrs)) lowP ~= Point(positions[i][j], i, j);
            currNbrs = [];
        }
    }

    return tuple(lowP.map!(lowp => lowp.value + 1).sum, lowP);
}

auto partTwo(long[][] positions, Point[] points)
{   
    Point[][] basins = [];

    foreach (point; points)
    {
        basins ~= flood(positions, point);
    }

    return basins.map!(basin => basin.length).array.sort[$-3..$].reduce!((a, b) => a * b);
}

Point[] flood(long[][] positions, Point point, Point[] visited = [])
{
    if (visited.canFind(point)) return visited;
    visited ~= point;
    if (point.y + 1 < positions[point.x].length)
    {
        auto nextPoint = Point(positions[point.x][point.y+1], point.x, point.y+1);
        if (nextPoint.value != 9) visited = flood(positions, nextPoint, visited);
    }
    if (point.y > 0)
    {
        auto nextPoint = Point(positions[point.x][point.y-1], point.x, point.y-1);
        if (nextPoint.value != 9) visited = flood(positions, nextPoint, visited);
    }
    if (point.x + 1 < positions.length)
    {
        auto nextPoint = Point(positions[point.x+1][point.y], point.x+1, point.y);
        if (nextPoint.value != 9) visited = flood(positions, nextPoint, visited);
    }
    if (point.x > 0)
    {
        auto nextPoint = Point(positions[point.x-1][point.y], point.x-1, point.y);
        if (nextPoint.value != 9) visited = flood(positions, nextPoint, visited);
    }
    return visited;
}

void main()
{
    auto source = "source/input.txt";
    auto result = partOne(fileToPoints(source));
    writeln(partTwo(fileToPoints(source), result[1]));
}
