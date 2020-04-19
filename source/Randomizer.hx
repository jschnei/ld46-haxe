package;

import flixel.math.FlxRandom;

class Randomizer
{
    public var rand:FlxRandom;
    public var grid:Grid;

    public var columnFreqs:Array<Int> = [0, 0, 0, 0, 0,
                                         1, 1, 1, 1, 1, 1, 
                                         2, 2, 2, 2, 2, 2, 2,
                                         3, 3, 3, 3, 3, 3,
                                         4, 4 ,4, 4, 4];
    var currentBag_:Array<Int>;

    public function new(grid:Grid)
    {
        this.grid = grid;
        rand = new FlxRandom(Std.int(Date.now().getTime()/1000));

        currentBag_ = new Array<Int>();
    }

    public function getColumn():Int
    {
        if (currentBag_.length == 0)
            generateNewBag();
        return currentBag_.pop();
    }

    public function getLetter():String
    {
        return Registry.alphabet[rand.weightedPick(Registry.letterFreq)];
    }

    private function generateNewBag():Void
    {
        rand.shuffle(columnFreqs);
        currentBag_ = columnFreqs.copy();
    }
}