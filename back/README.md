# Back structure

L'entrée du programme est `index.js` dans lequel le serveur est créé et écoute sur le port 3000

Une fois créé, un objet de type server (voir `server.js`) est créé, dans lequel la connexion aux sockets s'oppere.
A chaque connexion d'un client, on créé un objet `Player` (voir `Player.js`) à l'aide de son nom et son id de socket, puis on l'ajoute à la partie à l'aide du GameManager (voir `game-manager.js`)

Une fois tous les joueurs présent, le game-manager lance la partie grâce à la fonction `launch` de la Game (voir `Game.js`). Le jeu s'articule ensuite autour de cette fonction qui lance les bonnes actions en fonction de l'etat de la partie.
