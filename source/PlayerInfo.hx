package;

import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxSave;

class PlayerInfo
{   
    public var name:String;
    public var board:String;

    public var alive:Bool = true;
    public var self:Bool = false;

    public function new(name:String, ?self:Bool=false)
    {
        this.name = name;
        this.self = self;
    }

    public function setBoard(board:String)
    {
        this.board = board;
    }

}

