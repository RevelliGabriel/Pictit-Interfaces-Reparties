# Front Structure

Les front reçoivent les informations du jeu par le back via des socket. Le front de la board ne communique pas avec le back.
Le front du côté joueur renvoie les informations choisi par les utilisateurs via les sockets.
Les deux fronts sont dans le même projet car ils utilisent les mêmes modèles et services. Parmi ces services il y a le game-manager, qui est un singleton à jour de l'état de la game. L'affichage des vues se fait via un wrapper qui écoute les changements de l'état de la game et qui change son affichage en fonction.

Les pages sont affichées en fonction de l'état de la partie (la phase de jeu). L'utilisation de streambuilders est faite pour que les interfaces soient tout le temps à jours.