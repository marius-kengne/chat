package com.chat.chat;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import org.json.JSONObject;

@ServerEndpoint("/chatEndPoint")
public class ChatEndPoint {

    private static final Set<Session> clients = new CopyOnWriteArraySet<>();
    private static final Map<Session, String> userNames = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        clients.add(session);
        System.out.println("Connexion ouverte, client : " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            // Supposons que le message JSON contienne le nom de l'utilisateur et le contenu du message
            JSONObject messageJson = new JSONObject(message);
            String username = messageJson.getString("sender");
            String content = messageJson.getString("message");
            String senderId = messageJson.getString("senderId");

            // Enregistrez le nom de l'utilisateur si ce n'est pas déjà fait
            userNames.putIfAbsent(session, username);

            // Ajoutez le nom de l'utilisateur au message à transmettre
            JSONObject outgoingMessage = new JSONObject();
            outgoingMessage.put("sender", username);
            outgoingMessage.put("message", content);
            outgoingMessage.put("senderId", senderId);

            System.out.println("Message : " +outgoingMessage.toString());

            // Diffusez le message à tous les clients
            for (Session client : clients) {
                if (client.isOpen()) {
                    client.getAsyncRemote().sendText(outgoingMessage.toString());
                }
            }
        } catch (Exception e) {
            System.err.println("Erreur lors du traitement du message : " + e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        userNames.remove(session);
        System.out.println("Session fermée : " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Erreur dans la session " + session.getId() + ": " + throwable.getMessage());
    }
}
