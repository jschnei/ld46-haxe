package;

import haxe.io.Eof;
import openfl.utils.Assets;
import polygonal.ds.IntHashSet;

class Registry
{
    public static var SERVER_ADDRESS = "ws://slime.jschnei.com:9999/";
    // public static var SERVER_ADDRESS = "ws://localhost:9999/";

    public static var PLAYFIELD_WIDTH = 5;
    public static var PLAYFIELD_HEIGHT = 10;
    public static var GRID_SIZE = 64;
    public static var FALL_SPEED:Int = 200;
    public static var letterFreq:Array<Float> = [0.08167,0.01492,0.02202,0.04253,0.12702,0.02228,0.02015,0.06094,0.06966,0.00153,0.01292,0.04025,0.02406,0.06749,0.07507,0.01929,0.0095,0.05987,0.06327,0.09356,0.02758,0.00978,0.02560,0.0015,0.01994,0.00077];
    public static var alphabet:Array<String> = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    public static var TILE_PERIOD = 1;

    // # of blocks per second initially
    public static var START_FREQ = .5;
    // Current frequency is START_FREQ+(time elapsed in seconds)*FREQ_SCALING.
    // See Grid.update for details.
    public static var FREQ_SCALING = .005;

    public static var WORD_LIST:Array<String>;

    public static var rand:Randomizer;
    public static var curGame:MultiplayerGame;

    public static var nickname:String = "";

    public static function initializeGame()
    {
        if (curGame == null) 
            curGame = new MultiplayerGame();
    }

    public static function initializeWordList()
    {
        var dictString:String = Assets.getText(AssetPaths.enable1__txt);
        WORD_LIST = dictString.split('\n');
    }

    public static function isWord(word:String): Bool 
    {
        if (word.length < 3) return false;

        var left:Int = 0;
        var right:Int = WORD_LIST.length;

        while (right - left > 1)
        {
            var mid = (left + right) >> 1;
            var mword = WORD_LIST[mid];
            if (word >= mword)
            {
                left = mid;
            }
            else
            {
                right = mid;
            }
        }

        return (WORD_LIST[left] == word);
    }
}
