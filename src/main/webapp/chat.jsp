<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String username = request.getParameter("username");
  if (username == null || username.trim().isEmpty()) {
    response.sendRedirect("welcome.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chat Application</title>
  <style>
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

    .chat-container {
      width: 80%;
      max-width: 600px;
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
      display: flex;
      flex-direction: column;
    }

    .chat-header {
      background-color: #007bff;
      color: #fff;
      padding: 10px;
      text-align: center;
      border-radius: 10px 10px 0 0;
      font-size: 1.2em;
    }

    .chat-messages {
      flex-grow: 1;
      padding: 10px;
      overflow-y: auto;
      height: 300px;
      border-top: 1px solid #ddd;
      border-bottom: 1px solid #ddd;
    }

    .chat-messages p {
      margin: 5px 0;
      padding: 8px;
      border-radius: 5px;
    }

    .sent {
      background-color: #007bff;
      color: #fff;
      align-self: flex-end;
    }

    .received {
      background-color: #f0f0f0;
      color: #000;
      align-self: flex-start;
    }

    .chat-input {
      display: flex;
      padding: 10px;
      border-radius: 0 0 10px 10px;
      background-color: #f9f9f9;
    }

    .chat-input input {
      flex-grow: 1;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      margin-right: 10px;
      font-size: 1em;
    }

    .chat-input button {
      padding: 10px 20px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 1em;
    }

    .chat-input button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
<div class="chat-container">
  <div class="chat-header">Bienvenue, <%= username %> !</div>
  <div id="messages" class="chat-messages"></div>
  <div class="chat-input">
    <input type="text" id="message" placeholder="Entrez un message" />
    <button onclick="sendMessage()">Envoyer</button>
  </div>
</div>

<script type="text/javascript">
  const socket = new WebSocket("ws://192.168.1.167:8082/chat/chatEndPoint");
  const username = "<%= username %>";

  // Fonction appelée à l'ouverture de la connexion
  socket.onopen = () => {
    appendMessage("Connexion établie.", "received");
  };

  // Fonction appelée lors de la réception d'un message
  socket.onmessage = (event) => {
    try {
      const { message, sender } = JSON.parse(event.data);
      appendMessage(`${sender}: ${message}`, "received");
    } catch (error) {
      console.error("Erreur lors du traitement du message reçu : ", error);
    }
  };

  // Fonction appelée lorsque la connexion est fermée
  socket.onclose = () => {
    appendMessage("Connexion fermée.", "received");
  };

  // Fonction appelée en cas d'erreur avec WebSocket
  socket.onerror = (error) => {
    console.error("Erreur WebSocket : ", error);
    appendMessage("Une erreur est survenue avec le serveur.", "received");
  };

  // Fonction pour envoyer un message
  function sendMessage() {
    const messageInput = document.getElementById("message");
    const message = messageInput.value.trim();

    if (message && socket.readyState === WebSocket.OPEN) {
      const messageData = {
        message: message,
        sender: username
      };
      socket.send(JSON.stringify(messageData));
      appendMessage(`Moi: ${message}`, "sent");
      messageInput.value = ""; // Réinitialise le champ de saisie
    } else if (!message) {
      alert("Le message est vide !");
    } else {
      alert("Connexion au serveur non disponible.");
    }
  }

  // Fonction pour ajouter un message dans la liste des messages
  function appendMessage(message, type) {
    const messagesDiv = document.getElementById("messages");
    const newMessage = document.createElement("p");
    newMessage.textContent = message;
    newMessage.className = type;
    messagesDiv.appendChild(newMessage);
    messagesDiv.scrollTop = messagesDiv.scrollHeight; // Scroll automatiquement en bas
  }
</script>
</body>
</html>
