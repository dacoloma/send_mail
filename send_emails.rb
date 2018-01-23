require 'gmail'
require 'dotenv'
require './scrapping'

Dotenv.load

#En paramètre : nom de la ville, @email
def send_email_to_line(town,mail)
    Gmail.connect(ENV['email'],ENV['pass']) do |gmail|

        gmail.deliver do
            to mail
            subject "Formation gratuite : The Hacking Project"
            html_part do
                content_type 'text/html; charset=UTF-8'
                body "Bonjour,
                Je m'appelle Daniel, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle <a href='http://thehackingproject.org/'>The Hacking Project</a>. Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquels nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.

                Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{town}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{town}!

                Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80"
            end
       end
    end
end

def go_through_all_the_lines(ws)
    # Itération sur chaque ligne non vide du spreadsheet (grâce à la méthode .num_rows)
    (1..ws.num_rows).each do |row|
        # Envoi de mail en passant en paramètre : celulle_ville, cellule_adresse
        send_email_to_line(ws[row, 1],ws[row, 2])
        sleep(3)
    end
end

def get_the_email_html

end

#Fais appel à la constante WS qui correspond à mon worksheet dans le fichier scrapping.rb
go_through_all_the_lines(Scrap::WS)
