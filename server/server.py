#!/usr/bin/env python

# WS server example that synchronizes state across clients

import asyncio
import json
import logging
import websockets

from collections import defaultdict

logging.basicConfig()

SOCKETS = set()             # set of all open WebSocket objects
SOCKET_TO_NAME = dict()     # mapping from WebSockets to names
NAME_TO_SOCKET = dict()     # mapping from names to WebSockets
NAME_TO_ROOM = dict()       # mapping from names to rooms
NICKNAMES = dict()          # mapping from names to nicknames
ROOM_STATUS = dict()        # mapping from rooms to status
ROOMS = defaultdict(list)      # ROOMS[room] contains a list of all players in the room
BOARDS = defaultdict(str)      # BOARDS[name] is the board of player `name`

def players_message(room):
    name_str = ','.join(ROOMS[room])
    nickname_str = ','.join(NICKNAMES[name] for name in ROOMS[room])
    return json.dumps({"type": "players", 
                       "players": name_str,
                       "nicknames": nickname_str})

def join_message(name):
    return json.dumps({"type": "join", 
                       "name": name,
                       "nickname": NICKNAMES[name]})

def leave_message(name):
    return json.dumps({"type": "leave", "name": name})

def sync_message(name, board):
    return json.dumps({"type": "sync", 
                       "name": name,
                       "board": board})

def start_message():
    return json.dumps({"type": "start"})

def word_message(name, word):
    return json.dumps({"type": "word", 
                       "name": name,
                       "word": word})

async def notify_all(message):
    print("outgoing", message)
    if SOCKETS:
        await asyncio.wait([user.send(message) for user in SOCKETS])

async def notify_room(message, room):
    print("outgoing", message)
    room_sockets = [NAME_TO_SOCKET[name] for name in ROOMS[room]]
    if room_sockets:
        await asyncio.wait([user.send(message) for user in room_sockets])

async def notify_user(message, user):
    print("outgoing", message)
    await asyncio.wait([user.send(message)])

async def register(websocket):
    SOCKETS.add(websocket)
    # await notify_user(players_message(), websocket)

async def unregister(websocket):
    name = SOCKET_TO_NAME.get(websocket)
    remove_websocket(websocket)
    # TODO: It seems like there's a potential issue if people in different rooms have the same name?

    if name:
        await notify_all(leave_message(name))

def remove_websocket(websocket):
    if websocket in SOCKETS:
        SOCKETS.remove(websocket)

    if websocket in SOCKET_TO_NAME:
        name = SOCKET_TO_NAME[websocket]
        del SOCKET_TO_NAME[websocket]
        del NAME_TO_SOCKET[name]

        room = NAME_TO_ROOM[name]
        if name in ROOMS[room]:
            ROOMS[room].remove(name)
        del NAME_TO_ROOM[name]

def cleanup_room(room):
    if room not in ROOM_STATUS:
        return
    
    for player in ROOMS[room]:
        socket = NAME_TO_SOCKET[player]
        remove_websocket(socket)

    del ROOMS[room]
    del ROOM_STATUS[room]


async def counter(websocket, path):
    # register(websocket) sends user_event() to websocket
    await register(websocket)
    try:
        async for message in websocket:
            print("incoming:", message)

            try:
                data = json.loads(message)
                name = data["name"]
                room = data["room"]
                
                if data["type"] == "word":
                    word = data['message']
                    await notify_room(word_message(name, word), room)
                elif data["type"] == "join":  
                    can_join = True

                    if room not in ROOM_STATUS :
                        ROOMS[room] = []
                        ROOM_STATUS[room] = "created"
                    elif ROOM_STATUS[room] != "created":
                        print("cannot join, room already started")
                        can_join = False
                        # TODO (send error message to user)

                    if can_join:
                        nickname = data["message"]
                        NICKNAMES[name] = nickname

                        ROOMS[room].append(name)
                        NAME_TO_ROOM[name] = room

                        SOCKET_TO_NAME[websocket] = name
                        NAME_TO_SOCKET[name] = websocket

                        await notify_room(join_message(name), room)
                        await notify_user(players_message(room), websocket)
                elif data["type"] == "start":
                    await notify_room(start_message(), room)
                    ROOM_STATUS[room] = "started"

                elif data["type"] == "sync":
                    board = data['message']
                    BOARDS[name] = board
                    await notify_room(sync_message(name, board), room)
                elif data["type"] == "die":
                    await notify_room(leave_message(name), room)
                elif data["type"] == "end":
                    cleanup_room(room)
                else:
                    logging.error("unsupported event type: {}", data)
            except Exception as e:
                logging.error("error deserializing message: {}", e)
    finally:
        await unregister(websocket)


start_server = websockets.serve(counter, "0.0.0.0", 9999)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
