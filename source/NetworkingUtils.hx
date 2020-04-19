import haxe.net.WebSocket;

class NetworkingUtils {
    public static var ws:WebSocket;
    public static var isOpen:Bool = true;

    public static function test() 
    {
        trace('testing!');
        
        // ws = WebSocket.create("ws://echo.websocket.org", ['echo-protocol'], false);
        ws = WebSocket.create("ws://localhost:9999/", ['echo-protocol'], false);
        ws.onopen = function() 
        {
            trace('open!');
            ws.sendString('hello friend!');
        };
        ws.onmessageString = function(message) 
        {
            trace('message from server!' + message);
        };
        ws.onclose = function() 
        {
            trace('socket closed!');
            isOpen = false;
        }
    }

    public static function process()
    {
        // trace(isOpen);
        if (isOpen)
        {
            ws.process();
        }
    }

    public static function sendMessage(message: String)
    {
        if (isOpen)
        {
            ws.sendString(message);
        }
    }
}
