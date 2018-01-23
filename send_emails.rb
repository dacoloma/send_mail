require 'gmail'
require 'dotenv'
=begin
class Object
  def to_imap_date
    date = respond_to?(:utc) ? utc.to_s : to_s
    Date.parse(date).strftime('%d-%b-%Y')
  end
end
=end
Dotenv.load


def send_email_to_line
    gmail = Gmail.connect(ENV['email'],ENV['pass']) do |gmail|
        puts gmail.inbox.count(:unread)
        gmail.deliver do
            to "jeanmichel.lehacker@gmail.com"
            subject "Mail Test from terminal "
            body "Salut Jean Mich"
        end
    end
end

def go_through_all_the_lines

end

def get_the_email_html

end
