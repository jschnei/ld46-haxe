import haxe.net.WebSocket;

class NetworkingUtils {
    public static var ws:WebSocket;

    public static function test() {
        trace('testing!');
        ws = WebSocket.create("ws://localhost:9999/", ['echo-protocol'], false);
        ws.onopen = function() {
            trace('open!');
            ws.sendString('hello friend!');
        };
        ws.onmessageString = function(message) {
            trace('message from server!' + message);
        };

        // #if sys
        // while (true) {
        //     ws.process();
        //     Sys.sleep(0.1);
        // }
        // #end
    }
}
