<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chat Login</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .login-container {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      text-align: center;
    }

    .login-container input {
      width: 80%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 5px;
    }

    .login-container button {
      padding: 10px 20px;
      border: none;
      background-color: #007bff;
      color: white;
      border-radius: 5px;
      cursor: pointer;
    }

    .login-container button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
<div class="login-container">
  <h2>Bienvenue au Chat</h2>
  <input type="text" id="userName" placeholder="Entrez votre nom" />
  <button onclick="startChat()">Valider</button>
</div>

<script>
  function startChat() {
    const userName = document.getElementById("userName").value.trim();
    if (userName) {
      const targetURL = "chat.jsp?username=" + encodeURIComponent(userName);
      window.location.href = targetURL;
    } else {
      alert("Veuillez entrer votre nom !");
    }
  }
</script>

</body>
</html>
