package;

import haxe.io.Eof;
import openfl.utils.Assets;
import polygonal.ds.IntHashSet;

class Registry
{
    public static var PLAYFIELD_WIDTH = 5;
    public static var PLAYFIELD_HEIGHT = 10;
    public static var GRID_SIZE = 64;
    public static var FALL_SPEED:Int = 200;
    public static var letterFreq:Array<Float> = [0.08167,0.01492,0.02202,0.04253,0.12702,0.02228,0.02015,0.06094,0.06966,0.00153,0.01292,0.04025,0.02406,0.06749,0.07507,0.01929,0.0095,0.05987,0.06327,0.09356,0.02758,0.00978,0.02560,0.0015,0.01994,0.00077];
    public static var alphabet:Array<String> = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    public static var TILE_PERIOD = 1;

    // # of blocks per second initially
    public static var START_FREQ = 0.5;
    // Current frequency is START_FREQ+(time elapsed in seconds)*FREQ_SCALING.
    // See Grid.update for details.
    public static var FREQ_SCALING = .01;

    public static var WORD_LIST:IntHashSet;

    public static var rand:Randomizer;

    public static var word_prime = 14821; 
    public static function signature(word:String):Int
    {
        var ans = 0;
        for (i in 0...word.length)
        {
            ans *= word_prime;
            ans += word.charCodeAt(i);
        }

        return ans;
    }

    public static function initializeWordList()
    {
        var dictString:String = Assets.getText(AssetPaths.enable1__txt);
        var words = dictString.split('\n');

        WORD_LIST = new IntHashSet(100000);
        for (word in words) 
        {
            if (word.length >= 3)
                WORD_LIST.set(signature(word));
        }
        // WORD_LIST = WORD_LIST.map(function(str) return str.trim());

        // try
        // {
        //     trace("file content:");
        //     while( true )
        //     {
        //         WORD_LIST.push(dictFile.readLine());
        //     }
        // }
        // catch( ex:haxe.io.Eof ) 
        // {}
    }

    public static function isWord(word:String): Bool 
    {
        return WORD_LIST.has(signature(word));
    }
}
