//import haxe.net.WebSocket;
import js.html.WebSocket;

class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static function test() 
    {
        trace('testing!');
        
        // ws = WebSocket.create("ws://echo.websocket.org", ['echo-protocol'], false);
        ws = new WebSocket("ws://echo.websocket.org");
        // ws = new WebSocket("ws://localhost:9999/");
        ws.onopen = function() 
        {
            trace('open!');
            ws.send('hello friend!');
        };
        ws.onmessage = function(message) 
        {
            trace('message from server!');
            trace(message.data);
        };
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }
    }

    public static function sendMessage(message: String)
    {
        if (isOpen)
        {
            ws.send(message);
        }
    }
}
