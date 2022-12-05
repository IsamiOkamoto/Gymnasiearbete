
require 'sqlite3'
require 'csv'


def send_to_db(used_w, spelling, how_e, id)
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO rounds(Used_words, Spelling, How_end, Player) Values(#{used_w}, #{spelling}, #{how_e}, #{id})")
end

send_to_db(["noon", "neonate", "eel", "limb", "bomb", "brood", "drum", "metro", "owl", "lipoprotein", "nick", "kebab", "baby", "yogurt", "test", "tugboat", "tower", "ride"], [nil, nil, nil, nil, nil, nil, "drum", nil, nil, nil, nil, nil, nil, nil, nil, nil, "tower", nil], 1, "Isami")
#Kan inte spara arrayes