require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'
require 'json'
require 'pp'
require 'csv'

#récupère l'adresse email à partir de l'url d'une mairie
def get_the_email_of_a_townhal_from_its_webpage(url)

    page = Nokogiri::HTML(open(url))

    e_mails = page.css("tr > td.style27 > p.Style22") #recherche par CSS la section Adresse email
    e_mails.each{|adr|

        #parmis les infos collecter, recherche les données contenant le caractère @ pour déterminer si la donnée = email
        if adr.text.include? "@"
            return adr.text
        end
    }
end


def get_all_the_urls_of_val_de_marne_townhalls(url)
    page = Nokogiri::HTML(open(url))
    list_url={}
    website = page.xpath('//p/a')   #Recherche tous le code html des villes
    #/tr[3]/td/table/tbody/tr/td[1]/table[2]/tbody/tr[3]/td/table/tbody/tr/td[1]/p[2]/a       VDM
    #/tr[3]/td/table/tbody/tr/td[2]/p[2]/object/table/tbody/tr[2]/td/table/tbody/tr/td[1]/p/a[1] VDO
    website.each do |node|
        #infos = []
        url = "http://annuaire-des-mairies.com"+node['href'][1...node['href'].length]       #compléter l'URL de chaque mairie
        #infos <<  url
        #infos << get_the_email_of_a_townhal_from_its_webpage(url)
        list_url[node.text]=get_the_email_of_a_townhal_from_its_webpage(url)#infos       #Hash{ Ville => [URL_mairie, email_mairie]}
	end
    list_url
end

def put_in_spreadsheet(worksheet,get_hash)
    i = 1
    get_hash.each do |key,value|
        worksheet[i, 1] = key
        worksheet[i, 2] = value
        i += 1
    end
    worksheet.save
end

def put_in_json(get_hash)
    File.open("email_mairie.json","w") do |f|
        f.write(get_hash.to_json)
    end
end

def put_in_csv(get_hash)
    CSV.open("email_mairie.csv", "wb") do |csv|
        get_hash.each do |key,value|
            csv << [key,value]
        end

    end
end

#ouverture de session googledrive avec les clés
session = GoogleDrive::Session.from_config("config.json")

#Ouverture du fichier correspondant à la clé 1rgw...., worksheet 2
sheet = session.spreadsheet_by_key("1OfQxnGoIOkB05aLhEVapIO68qU7LYpls4cEr3EUcRHo")
#sheet.add_worksheet("Route de la mairie")
ws = sheet.worksheets[0]

URL_VAL_DE_MARNE= "https://www.annuaire-des-mairies.com/val-de-marne.html"

puts get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE)
put_in_spreadsheet(ws,get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
#put_in_json(get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
#put_in_csv(get_all_the_urls_of_val_de_marne_townhalls(URL_VAL_DE_MARNE))
