<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chat</title>
</head>
<body>
<h3>Chat</h3>
<textarea id="output" rows="10" cols="50" readonly></textarea><br>
<input type="text" id="message" placeholder="Entrez un message" />
<button onclick="sendMessage()">Envoyer</button>
<button onclick="closeSocket()">Fermer</button>

<script type="text/javascript">

    const socket = new WebSocket("ws://localhost:8082/chat_war/chatEndPoint");

    socket.onopen = () => {
        console.log("### open");
        document.getElementById("output").value += "Connexion ouverte\n";
    };

    socket.onmessage = (event) => {
        document.getElementById("output").value += "Serveur : " +event.data + "\n";
    };

    socket.onclose = () => {
        document.getElementById("output").value += "Connextion fermée \n";
    };
    /*
function sendMessage() {
const message = document.getElementById("message").value;
socket.send(message);
}*/

    function sendMessage() {
        const message = document.getElementById("message").value;

        // Vérifie si le WebSocket est ouvert
        if (socket.readyState === WebSocket.OPEN) {
            socket.send(message);
            document.getElementById("message").value = ""; // Réinitialise le champ après l'envoi
        } else {
            console.error("Le WebSocket n'est pas connecté.");
            alert("Impossible d'envoyer le message. La connexion WebSocket est fermée.");
        }
    }

    function closeSocket() {
        socket.close();
    }
</script>
</body>
</html>