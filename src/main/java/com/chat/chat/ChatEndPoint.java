package com.chat.chat;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chatEndPoint")
public class ChatEndPoint {

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Connexion ouverte : " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("Message reçu : " + message);
        try {
            session.getBasicRemote().sendText("Message reçu : " + message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("Connexion fermée : " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.out.println("Erreur détectée : " + throwable.getMessage());
    }
}

