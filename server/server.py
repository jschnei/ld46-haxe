#!/usr/bin/env python

# WS server example that synchronizes state across clients

import asyncio
import json
import logging
import websockets

logging.basicConfig()

BOARDS = {}

USERS = set()
SOCKET_TO_NAME = dict()
NAME_TO_SOCKET = dict()

STARTED = False

def players_message():
    return json.dumps({"type": "players", 
                       "players": ",".join(list(NAME_TO_SOCKET.keys()))})

def join_message(name):
    return json.dumps({"type": "join", "name": name})

def leave_message(name):
    return json.dumps({"type": "leave", "name": name})

def sync_message(name, board):
    return json.dumps({"type": "sync", 
                       "name": name,
                       "board": board})

def start_message():
    return json.dumps({"type": "start"})

async def notify_all(message):
    print("outgoing", message)
    if USERS:
        await asyncio.wait([user.send(message) for user in USERS])

async def notify_user(message, user):
    print("outgoing", message)
    await asyncio.wait([user.send(message)])

async def register(websocket):
    USERS.add(websocket)
    await notify_user(players_message(), websocket)


async def unregister(websocket):
    name = SOCKET_TO_NAME[websocket]
    USERS.remove(websocket)

    del SOCKET_TO_NAME[websocket]
    del NAME_TO_SOCKET[name]
    
    await notify_all(leave_message(name))


async def counter(websocket, path):
    # register(websocket) sends user_event() to websocket
    await register(websocket)
    try:
        async for message in websocket:
            data = json.loads(message)
            print("incoming:", message)
            if data["type"] == "word":
                pass
            elif data["type"] == "join":
                name = data["name"]
                SOCKET_TO_NAME[websocket] = name
                NAME_TO_SOCKET[name] = websocket

                await notify_all(join_message(name))
            elif data["type"] == "start":
                STARTED = True
                await notify_all(start_message())

            elif data["type"] == "sync":
                name = data["name"]
                board = data["message"]

                BOARDS[name] = board
                await notify_all(sync_message(name, board))
            else:
                logging.error("unsupported event type: {}", data)
    finally:
        await unregister(websocket)


start_server = websockets.serve(counter, "localhost", 9999)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
