# Front Structure

Les front reçoivent les informations du jeu par le back via des socket. Le front de la board ne communique pas avec le back.
Le front du côté joueur renvoie les informations choisi par les utilisateurs via les sockets.
Les deux fronts sont dans le même projet car ils utilisent les mêmes modèles et services.

Les pages sont affichées en fonction de l'état de la partie (la phase de jeu). L'utilisation de streambuilders est faite pour que les interfaces soient tout le temps à jours.