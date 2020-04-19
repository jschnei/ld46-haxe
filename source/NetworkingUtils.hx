//import haxe.net.WebSocket;
import haxe.DynamicAccess;
import haxe.Json;

import js.html.WebSocket;


class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static var name:String;

    public static function initialize() 
    {   
        // ws = WebSocket.create("ws://echo.websocket.org", ['echo-protocol'], false);
        // ws = new WebSocket("ws://echo.websocket.org"); 
        name = Randomizer.getName();
        trace('name:', name);

        ws = new WebSocket("ws://localhost:9999/");
        ws.onopen = function() 
        {
            trace('open!');
            // ws.send('hello friend!');
        };
        ws.onmessage = function(message) 
        {
            // trace('message from server!');
            trace(message.data);
        };
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }
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
}
