import std.stdio;

import aoc6;

void main()
{
    auto fish = fileToFish("source/input.txt");
    auto family = new FishFamily(fish);
	//writeln(family.growBy(80));
    writeln(family.growByFaster(256));
}
