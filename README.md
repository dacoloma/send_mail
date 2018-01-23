# send_mail

#scrapping.rb
Scrappe les adresses emails des mairies du Val-De-Marne et les envoie sur le spreadsheet du Drive , en feuille 1.
        Colonne A => Nom des villes
        Colonne B => Adresse email des mairies
Nécessite un fichier config.json sous la forme :
    {
        "client_id": #string,
        "client_secret": #string,
        "scope": #array[string,string],
        "refresh_token": #string
    }

#send-emails.rb
Envoie un mail à chaque adresse mail collectée via le spreadsheet. Créer un fichier .env (juste le format, pas de nom) dans le même répertoire du fichier .rb et copier-coller ces 2 lignes en raplaçant par vos données:
EMAIL="mon_adresse@gmail.com"
PASS="mon_mot_de_passe"
