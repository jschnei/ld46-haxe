package;

import flixel.math.FlxRandom;

class Randomizer
{
    public var rand:FlxRandom;
    public var grid:Grid;

    public var COLUMN_FREQS:Array<Int> = [0, 0, 0, 0, 0,
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
        var columnBag = COLUMN_FREQS.copy();
        currentBag_ = shuffle(columnBag);
    }

    // Copy-pasted Fisher-Yates shuffle because Haxe doesn't have a built-in one lol.
    public function shuffle<T>(arr:Array<T>):Array<T>
	{
		if (arr!=null) {
			for (i in 0...arr.length) {
				var j = rand.int(0, arr.length - 1);
				var a = arr[i];
				var b = arr[j];
				arr[i] = b;
				arr[j] = a;
			}
		}
		return arr;
	}
}