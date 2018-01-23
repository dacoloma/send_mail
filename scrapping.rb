require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'pp'
require 'csv'
require 'pry'


#récupère l'adresse email à partir de l'url d'une mairie
def get_the_email_of_a_townhal_from_its_webpage(url)

    page = Nokogiri::HTML(open(url))
    #recherche par CSS la section Adresse email
    e_mails = page.css("tr > td.style27 > p.Style22")
    e_mails.each{|adr|
        #parmis les infos collecter, recherche les données contenant le caractère @ pour déterminer si la donnée = email
        if adr.text.include? "@"
            #binding.pry
            return adr.text[1...adr.text.length]# .strip pour effacer les éventuels espace avant et après le string
        end
    }
end


def get_all_the_urls_of_val_de_marne_townhalls(url)
    page = Nokogiri::HTML(open(url))
    list_url={}
    #Recherche tous le code html des villes
    website = page.xpath('//p/a')

    website.each do |node|
        #compléter l'URL de chaque mairie
        url = "http://annuaire-des-mairies.com"+node['href'][1...node['href'].length]

        #ajout dans un hash : Ville => email
        list_url[node.text]=get_the_email_of_a_townhal_from_its_webpage(url)
	end
    list_url
end

def put_in_spreadsheet(worksheet,get_hash)
    i = 1
    # Pour chaque key dans mon hash
    get_hash.each do |key,value|
        #affecter les keys dans chaque ligne dans la première colonne
        worksheet[i, 1] = key
        #affecter les keys dans chaque ligne dans la deuxième colonne
        worksheet[i, 2] = value
        i += 1
    end
    worksheet.save
end

module Scrap
    #ouverture de session googledrive avec les clés
    SESSION = GoogleDrive::Session.from_config("config.json")

    #Ouverture du fichier correspondant à la clé 1rgw...., worksheet 2
    SHEET = SESSION.spreadsheet_by_key("1OfQxnGoIOkB05aLhEVapIO68qU7LYpls4cEr3EUcRHo")
    #sheet.add_worksheet("Route de la mairie")
    WS= SHEET.worksheets[0]


URL_VAL_DE_MARNE= "https://www.annuaire-des-mairies.com/val-de-marne.html"

get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE)
put_in_spreadsheet(WS,get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
#put_in_json(get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
#put_in_csv(get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
end
