package;

import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxSave;

class PlayerInfo
{   
    public var name:String;
    public var alive:Bool = true;
    public var board:String;

    public function new(name:String)
    {
        this.name = name;
    }

    public function setBoard(board:String)
    {
        this.board = board;
    }

}

