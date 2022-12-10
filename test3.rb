require 'base64'
require 'sqlite3'
require 'csv'

def data_words()
    db = SQLite3::Database.new("db/data.db")
    x = File.readlines("list.csv")
    x.each do |place|
        db.execute("INSERT INTO Words (word, new) VALUES (?, ?)", place.chomp, 1)
    end
end

data_words()