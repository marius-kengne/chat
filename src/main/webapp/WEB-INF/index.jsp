<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Application</title>
    <style>
        /* Général */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Conteneur principal */
        .chat-container {
            background-color: #ffffff;
            width: 100%;
            max-width: 400px;
            height: 600px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
        }

        /* En-tête */
        .chat-header {
            background-color: #007bff;
            color: #ffffff;
            padding: 10px;
            text-align: center;
            font-weight: bold;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }

        /* Zone des messages */
        .chat-messages {
            flex: 1;
            padding: 10px;
            overflow-y: auto;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
        }

        .chat-messages p {
            margin: 5px 0;
            padding: 10px;
            border-radius: 15px;
            max-width: 70%;
        }

        .chat-messages .sent {
            background-color: #d1e7dd;
            align-self: flex-end;
            color: #000;
        }

        .chat-messages .received {
            background-color: #f1f1f1;
            align-self: flex-start;
            color: #000;
        }

        /* Barre d'envoi */
        .chat-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ddd;
        }

        .chat-input input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 20px;
            outline: none;
            margin-right: 10px;
        }

        .chat-input button {
            padding: 10px 15px;
            border: none;
            background-color: #007bff;
            color: #ffffff;
            border-radius: 20px;
            cursor: pointer;
        }

        .chat-input button:hover {
            background-color: #0056b3;
        }

        .chat-input button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">Chat Application</div>
        <div id="messages" class="chat-messages"></div>
        <div class="chat-input">
            <input type="text" id="message" placeholder="Entrez un message" />
            <button onclick="sendMessage()">Envoyer</button>
        </div>
    </div>

    <script type="text/javascript">
        const socket = new WebSocket("ws://192.168.1.167:8082/chat/chatEndPoint");

        // Identifiant unique pour distinguer l'utilisateur courant
        const userId = Math.random().toString(36).substring(7);

        // Ouverture de la connexion
        socket.onopen = () => {
            console.log("Connexion ouverte");
            appendMessage("Connexion établie", "received");
        };

        // Réception des messages
        socket.onmessage = (event) => {
            const messageData = JSON.parse(event.data);
            const { message, senderId } = messageData;

            // Si le message est d'un autre utilisateur
            if (senderId !== userId) {
                appendMessage(message, "received");
            }
        };

        // Fermeture de la connexion
        socket.onclose = () => {
            console.log("Connexion fermée");
            appendMessage("Connexion fermée", "received");
        };

        // Envoi des messages
        function sendMessage() {
            const messageInput = document.getElementById("message");
            const message = messageInput.value.trim();

            if (message && socket.readyState === WebSocket.OPEN) {
                const messageData = {
                    message: message,
                    senderId: userId
                };
                console.log("messageData : "+messageData);
                socket.send(JSON.stringify(messageData)); // Envoie sous forme JSON
                console.log("##message envoyé");
                appendMessage(message, "sent");
                messageInput.value = ""; // Réinitialise le champ
            } else {
                alert("Connexion non disponible ou message vide.");
            }
        }

        // Ajouter un message dans la liste
        function appendMessage(message, type) {
            const messagesDiv = document.getElementById("messages");
            const newMessage = document.createElement("p");
            newMessage.textContent = message;
            newMessage.className = type; // "sent" ou "received"
            messagesDiv.appendChild(newMessage);
            messagesDiv.scrollTop = messagesDiv.scrollHeight; // Scroller vers le bas
        }
    </script>
</body>
</html>
