module aoc6;

import std.stdio;
import std.array;
import std.conv;
import std.algorithm;

Fish[] fileToFish(string path)
{
    Fish[] result;
    auto lines = File(path, "r").byLine;
    foreach (line; lines)
    {
        auto timers = line.split(",");
        foreach (timer; timers)
        {
            result ~= new Fish(to!int(timer));
        }
    }
    return result;
}

class Fish
{
    private int mTimer;
    bool mRecentlyProduced;
    
    this (int timer)
    {
        mTimer = timer;
    }

    int timer()
    {
        return mTimer;
    }
    
    bool shouldProduce()
    {
        return mTimer == 0;
    }

    bool recentlyProduced()
    {
        bool oldState = mRecentlyProduced;
        mRecentlyProduced = false;
        return oldState;
    }

    void passADay()
    {
        dec();
    }

    private void dec()
    {
        if (mTimer > 0) mTimer--;
    }

    void produce()
    {
        mRecentlyProduced = true;
        mTimer = 6;
    }

    override string toString()
    {
        return "Fish(" ~ to!string(mTimer) ~ ")";
    }
}

class FishFamily
{
    private Fish[] mAllFish;
    private ulong[ulong] mAllFishMap;

    this (Fish[] fish)
    {
        mAllFish = fish;
        
        foreach (f; mAllFish)
        {
            if (f.timer !in mAllFishMap) {
                mAllFishMap[f.timer] = 1;
            } else {
                mAllFishMap[f.timer]++;
            }
        }
    }

    auto growBy(int days)
    {
        if (days == 0) return mAllFish.length;
        foreach (fish; mAllFish)
        {
            if (fish.shouldProduce) {
                fish.produce();
                mAllFish ~= new Fish(8);
            }
            
            if (!fish.recentlyProduced) fish.passADay();
        }
        return growBy(days - 1);
    }

    auto growByFaster(int days)
    {
        if (days == 0) return mAllFishMap.values.sum;

        ulong[ulong] count;
        foreach (timer, fish; mAllFishMap)
        {
            if (timer == 0) {
                count[8] += fish;
                count[6] += fish;
            } else {
                count[timer-1] += fish;
            }

        }
        mAllFishMap = count;
        return growByFaster(days - 1);
    }

    auto length()
    {
        return mAllFish.length;
    }

    override string toString()
    {
        return to!string(mAllFish);
    }
}