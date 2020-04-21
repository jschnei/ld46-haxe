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
import flixel.addons.ui.FlxInputText;

class NameState extends FlxState
{
    var _name_label:FlxInputText;
    var instructionText:FlxText;
	override public function create():Void
	{	
        FlxG.autoPause = false;
		bgColor = new FlxColor(0xff303030);

        _name_label = new FlxInputText(200, 250, 400, "", 20, FlxColor.ORANGE, bgColor);
        _name_label.callback = updateString;
        add(_name_label);

        instructionText = new FlxText(200, 200);
        instructionText.setFormat(AssetPaths.Action_Man__ttf, 30, FlxColor.ORANGE);
        instructionText.text = "Enter your nickname:";
        add(instructionText);
		super.create();
	}	

    override public function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.switchState(new WaitingState());
        }

        super.update(elapsed);
    }

    public function updateString(oldString:String, newString:String) {
        Registry.name = oldString;
    }
}