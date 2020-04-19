package;

import flixel.math.FlxRandom;

class Randomizer
{
    public var rand:FlxRandom;
    public var grid:Grid;

    public function new(grid:Grid)
    {
        this.grid = grid;
        rand = new FlxRandom(Std.int(Date.now().getTime()/1000));
    }

    public function getColumn(numColumns:Int):Int
    {
        return rand.int(0, numColumns-1);
    }

    public function getLetter():String
    {
        return Registry.alphabet[rand.weightedPick(Registry.letterFreq)];
    }
}