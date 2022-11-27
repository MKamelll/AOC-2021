module aoc5;

import std.stdio;
import std.conv;
import std.array;
import std.string;
import std.algorithm;
import std.math;

Grid fileToGrid(string path)
{
    Line[] lines;
    auto f = File(path).byLine;   
    foreach (l; f)
    {
        auto points = l.split("->");
        auto p1 = points[0].strip.split(",");
        auto p2 = points[1].strip.split(",");
        lines ~= Line(Point(to!int(p1[0]), to!int(p1[1])), Point(to!int(p2[0]), to!int(p2[1])));
    }
    
    Grid grid = Grid(lines);
    return grid;
}

struct Point
{
    int x,y;

    bool opEquals(R)(const R other) const
    {
        return other.x == x && other.y == y;
    }

    string toString()
    {
        return "Point(x: " ~ to!string(x) ~ ", y: " ~ to!string(y) ~ ")";
    }
}

struct Line
{
    Point p1, p2;

    Point[] getPoints()
    {
        int[] xs;
        if (p1.x < p2.x) {
            for (int i = p1.x; i <= p2.x; i++) xs ~= i;
        } else {
            for (int i = p1.x; i >= p2.x; i--) xs ~= i;
        }

        int[] ys;
        if (p1.y < p2.y) {
            for (int i = p1.y; i <= p2.y; i++) ys ~= i;
        } else {
            for (int i = p1.y; i >= p2.y; i--) ys ~= i;
        }

        Point[] points;
        int i = 0;
        int j = 0;
        if (xs.length >= ys.length) {
            while (i < xs.length) {
                int x = xs[i];
                if (j < ys.length) {
                    int y = ys[j];
                    j++;
                    points ~= Point(x, y);
                } else {
                    points ~= Point(x, ys[$-1]);
                }
                i++;
            }
        } else {
            while (j < ys.length) {
                int y = ys[j];
                if (i < xs.length) {
                    int x = xs[j];
                    i++;
                    points ~= Point(x, y);
                } else {
                    points ~= Point(xs[$-1], y);
                }
                j++;
            }
        }

        return points;
    }

    bool isHorizontalOrVertical()
    {
        return p1.x == p2.x || p1.y == p2.y;
    }

    bool isDiagonal()
    {
        return abs(p1.x - p2.x) == abs(p1.y - p2.y);
    }

    bool hasPoint(Point p)
    {
        Point[] points = getPoints();
        return points.canFind(p);
    }

    string toString()
    {
        return "Line(p1: " ~ p1.toString ~ ", p2: " ~ p2.toString ~ ")";
    }
}

struct Grid
{
    Line[] lines;
    int[][] diagram;

    int rowsNo()
    {
        int max;
        foreach (line; lines)
        {
            if (line.p1.x > max) max = line.p1.x;
            if (line.p2.x > max) max = line.p2.x;
        }
        return max + 1;
    }

    int colsNo()
    {
        int max;
        foreach (line; lines)
        {
            if (line.p1.y > max) max = line.p1.y;
            if (line.p2.y > max) max = line.p2.y;
        }
        return max + 1;
    }

    int partOne()
    {
        startDiagram();
        Line[] hvLines;
        foreach (line; lines)
        {
            if (line.isHorizontalOrVertical) hvLines ~= line;
        }

        foreach (line; hvLines)
        {
            drawLine(line);
        }

        int result;
        foreach (row; diagram)
        {
            foreach (col; row)
            {
                if (col >= 2) result += 1;
            }
        }

        return result;
    }

    int partTwo()
    {
        startDiagram();
        Line[] hvdLines;
        foreach (line; lines)
        {
            if (line.isHorizontalOrVertical || line.isDiagonal) hvdLines ~= line;
        }

        foreach (line; hvdLines)
        {
            drawLine(line);
        }

        int result;
        foreach (row; diagram)
        {
            foreach (col; row)
            {
                if (col >= 2) result += 1;
            }
        }

        return result;
    }

    void startDiagram()
    {
        diagram = new int[][](colsNo(), rowsNo());
    }

    void drawLine(Line line)
    {
        foreach (point; line.getPoints)
        {
            drawPoint(point);
        }
    }

    void drawPoint(Point point)
    {
        diagram[point.y][point.x]++;
    }

    string toString()
    {
        string result;
        foreach (line; lines)
        {
            result ~= to!string(line.p1.x) ~ "," ~
                to!string(line.p1.y) ~ " -> " ~ to!string(line.p2.x) ~ "," ~ to!string(line.p2.y);
            
            result ~= "\n";
        }

        return result;
    }
}
