//import haxe.net.WebSocket;

class NetworkingUtils {
    public static var room = "hi";

    public static function initialize() 
    {
        
    }

    public static function sendMessage(type: String, ?message: String = "")
    {
        if (type=="start")
        {
            Registry.curGame.started = true;
        }
    }

    public static function getTrackedBoard():String 
    {
        return "";
    }
    
}
