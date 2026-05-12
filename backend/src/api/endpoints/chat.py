"""Chat endpoints for websocket and Swagger-visible access."""

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, status
from pydantic import ValidationError

from src.api.depends import ChatServiceDependency
from src.api.schemas import ChatClientMessage, ChatServerMessage
from src.service.chat import ChatService


router = APIRouter(prefix="/chat", tags=["chat"])


async def _generate_chat_reply(
    chat_service: ChatService,
    user_message: str,
    history: list[dict[str, str]] | None = None,
) -> ChatServerMessage:
    result = await chat_service.reply(user_message=user_message, history=history)

    return ChatServerMessage(
        type="assistant",
        message=result.message,
        total_chunks=result.total_chunks,
    )


@router.post(
    "/message",
    response_model=ChatServerMessage,
    status_code=status.HTTP_200_OK,
)
async def chat_message(payload: ChatClientMessage, chat_service: ChatServiceDependency):
    """Generate a single chat reply for Swagger and simple clients."""

    return await _generate_chat_reply(chat_service, payload.message)


@router.websocket("/ws")
async def chat_socket(websocket: WebSocket, chat_service: ChatServiceDependency):
    """Accept chat turns and stream back assistant replies."""

    await websocket.accept()

    history: list[dict[str, str]] = []
    await websocket.send_json(
        ChatServerMessage(
            type="ready",
            message="Chat connection established",
        ).model_dump()
    )

    try:
        while True:
            raw_message = await websocket.receive_text()
            client_message = ChatClientMessage.model_validate_json(raw_message)

            history.append({"role": "user", "content": client_message.message})

            response = await _generate_chat_reply(
                chat_service,
                user_message=client_message.message,
                history=history,
            )

            history.append({"role": "assistant", "content": response.message})

            await websocket.send_json(response.model_dump())
    except WebSocketDisconnect:
        return
    except ValidationError:
        await websocket.send_json(
            ChatServerMessage(
                type="error",
                message="Invalid chat payload",
            ).model_dump()
        )
        await websocket.close(code=1003)
    except Exception as exc:
        await websocket.send_json(
            ChatServerMessage(type="error", message=str(exc)).model_dump()
        )
        await websocket.close(code=1011)
