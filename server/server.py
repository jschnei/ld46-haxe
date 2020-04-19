#!/usr/bin/env python

# WS server example that synchronizes state across clients

import asyncio
import json
import logging
import websockets

logging.basicConfig()

BOARDS = {}

USERS = set()

def users_event():
    return json.dumps({"type": "users", "count": len(USERS)})

async def notify_sync(name, board):
    message = json.dumps({"type": "sync", 
                          "name": name,
                          "board": board})
    if USERS:  # asyncio.wait doesn't accept an empty list
        await asyncio.wait([user.send(message) for user in USERS])


async def notify_users():
    if USERS:  # asyncio.wait doesn't accept an empty list
        message = users_event()
        await asyncio.wait([user.send(message) for user in USERS])


async def register(websocket):
    USERS.add(websocket)
    await notify_users()


async def unregister(websocket):
    USERS.remove(websocket)
    await notify_users()


async def counter(websocket, path):
    # register(websocket) sends user_event() to websocket
    await register(websocket)
    try:
        # await websocket.send(users_event())
        async for message in websocket:
            data = json.loads(message)
            print(data)
            if data["type"] == "word":
                pass
            elif data["type"] == "sync":
                name = data["name"]
                board = data["message"]

                BOARDS[name] = board
                await notify_sync(name, board)
                pass
            else:
                logging.error("unsupported event: {}", data)
    finally:
        await unregister(websocket)


start_server = websockets.serve(counter, "localhost", 9999)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
