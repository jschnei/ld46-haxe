//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

import js.html.MessageEvent;
import js.html.WebSocket;


class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static var name:String;

    public static var playerBoards:Map<String, String>;

    public static function initialize() 
    {   
        // ws = WebSocket.create("ws://echo.websocket.org", ['echo-protocol'], false);
        // ws = new WebSocket("ws://echo.websocket.org"); 
        name = Randomizer.getName();
        trace('name:', name);

        playerBoards = new Map<String, String>();

        ws = new WebSocket("ws://localhost:9999/");
        ws.onopen = function() 
        {
            trace('open!');
            // ws.send('hello friend!');
        };
        
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }

        ws.onmessage = onMessage;
    }

    public static function sendMessage(type: String, message: String)
    {
        if (isOpen)
        {
            var messageBlob:Dynamic<String> = {};
            messageBlob.type = type;
            messageBlob.name = name;
            messageBlob.message = message;
            ws.send(Json.stringify(messageBlob));
        }
    }

    public static function onMessage(message:MessageEvent)
    {
        // trace('message from server!');
        trace(message.data);
        var messageObject = Json.parse(message.data);

        switch (messageObject.type)
        {
            case "sync":
                trace("sync message");
            case "state":
                trace("state message");
            case "users":
                trace("users message");
            
        }
    }

    public static function processSyncMessage(message:Dynamic)
    {
        var name:String = message.name;
        var board:String = message.board;
        
        playerBoards.set(name, board);
    }
}
