package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import haxe.io.Eof;

class WaitingState extends FlxState
{
    var _name_label:FlxText;
    var _room_label:FlxText;

    var _lobby_users:FlxText;
    var _lobby_users_label:FlxText;

    var update_lobby_timer:Float = 0;
    public static var UPDATE_LOBBY_FREQ = 0.5;
	
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

        Randomizer.initialize();
        Registry.initializeGame();
		Registry.initializeWordList();
        NetworkingUtils.initialize();

        _name_label = new FlxText(200, 250);
        _name_label.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.ORANGE, FlxTextAlign.LEFT);
        _name_label.text = "Name: " + Registry.curGame.myName;
        add(_name_label);

        _room_label = new FlxText(200, 300);
        _room_label.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.ORANGE, FlxTextAlign.LEFT);
        _room_label.text = "Room: " + NetworkingUtils.room;
        add(_room_label);

        _lobby_users_label = new FlxText(200, 350);
        _lobby_users_label.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.ORANGE, FlxTextAlign.LEFT);
        _lobby_users_label.text = "Players: ";
        add(_lobby_users_label);

        _lobby_users = new FlxText(200, 400);
        _lobby_users.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.RED, FlxTextAlign.LEFT);
        add(_lobby_users);

		super.create();
	}	

    override public function update(elapsed:Float):Void
    {
        update_lobby_timer += elapsed;
        if (update_lobby_timer > UPDATE_LOBBY_FREQ)
        {
            updateLobbyText();
            update_lobby_timer = 0;
        }

        if (Registry.curGame.started)
        {
            FlxG.switchState(new PlayState());
        }

        if (FlxG.keys.justPressed.P)
        {
            NetworkingUtils.sendMessage("start");
        }

        super.update(elapsed);
    }

    public function updateLobbyText()
    {
        var users:Array<String> = Registry.curGame.getCurrentPlayers();
        _lobby_users.text = users.join("\n");
    }


    
}