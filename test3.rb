require 'base64'
require 'sqlite3'
require 'csv'

def data_words()
    db = SQLite3::Database.new("db/data.db")
    x = File.readlines("list.csv")
    x.each do |place|
        db.execute("INSERT INTO Words (word) VALUES (?)", place.chomp)
    end
end
def word_exists(input)
    p input[0]
    p "a"
    db = SQLite3::Database.new("db/data.db")
    arr = db.execute("SELECT * FROM Words WHERE word LIKE '#{input[0]}%'")
end
def word_exists2()
    db = SQLite3::Database.new("db/data.db")
    return arr = db.execute("SELECT * FROM Words WHERE word LIKE 'applle'")
end
def ai_lose(a)
    db = SQLite3::Database.new("db/data.db")
    arr = db.execute("SELECT * FROM Words WHERE word LIKE '#{a}%'")
    hold = arr.length
    i = 0
    n = 0
    while i < session[:used_words].length
        if session[:used_words][i][0] == a
            n += 1
        end
        if n == hold
            session[:still_play] = 4
            return false
        end
        i += 1
    end
    return true
end
p similar_length("yellow")