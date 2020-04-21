package;

import flixel.math.FlxRandom;

class Randomizer
{
    public static var rand:FlxRandom;

    public static var NAME_LENGTH = 8;
    public static var COLUMN_FREQS:Array<Int> = [0, 0, 0, 0,
                                                1, 1, 1, 1, 1, 1,
                                                2, 2, 2, 2, 2, 2,
                                                3, 3, 3, 3, 3, 3,
                                                4, 4 ,4, 4];
    static var currentBag_:Array<Int>;

    public static function initialize()
    {
        rand = new FlxRandom(Std.int(Date.now().getTime()/1000));

        currentBag_ = new Array<Int>();
    }

    public static function getColumn():Int
    {
        if (currentBag_.length == 0)
            generateNewBag();
        return currentBag_.pop();
    }

    public static function getLetter():String
    {
        return Registry.alphabet[rand.weightedPick(Registry.letterFreq)];
    }

    public static function getName():String
    {
        var name = "";

        for (i in 0...NAME_LENGTH)
        {
            name += getLetter();
        }

        return name;
    }

    private static function generateNewBag():Void
    {
        rand.shuffle(COLUMN_FREQS);
        currentBag_ = COLUMN_FREQS.copy();
    }
}