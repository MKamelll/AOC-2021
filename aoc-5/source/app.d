import std.stdio;

import aoc5;

void main()
{
    Grid grid = fileToGrid("source/input.txt");
    writeln(grid.partTwo());
}
