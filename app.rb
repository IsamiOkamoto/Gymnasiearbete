require 'slim'
require 'sinatra'
require 'sqlite3'
enable :sessions

$abc_array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
def rows()
    db = SQLite3::Database.new("db/data.db")
    return db.execute("SELECT * FROM Words").length
end
def is_used(word)
    i = 0
    while i <session[:used_words].length
        if session[:used_words][i] == word
            session[:still_play] = 2
            return false
        end
        i += 1
    end
    return true
end
def last_word(input)
    if input[0] == session[:last_played][session[:last_played].length - 1]
        session[:still_play] = 1
        return true
    end
    return false
end
def which_letter_index(letter)
    i = 0
    while i < $abc_array.length
        if letter == $abc_array[i]
            return i
        end
        i += 1
    end
end
def word_exists(input)
    db = SQLite3::Database.new("db/data.db")
    arr = db.execute("SELECT * FROM Words WHERE word = ?", input)
    if arr.length == 1
        return true
    end
    session[:out] = spelling(input)
    if session[:out].length != 0
        redirect('/spelling')
    else
        redirect("/addmm")
    end
    session[:still_play] = 3
    return false
end
def valied_word(input)
    if last_word(input) && is_used(input) && word_exists(input)
        session[:used_words].append(input)
        session[:last_played] = input
        return true
    else
        return false
    end
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
def ai_select_word()
    a = session[:last_played][session[:last_played].length - 1]
    if ai_lose(a)
        i = 0
        db = SQLite3::Database.new("db/data.db")
        arr = db.execute("SELECT * FROM Words WHERE word LIKE '#{a}%'")
        while i < 1
            word = arr[rand(0..arr.length)][0].chomp #[0] on nil?
            if valied_word(word)
                i += 1
            end
        end
        return word
    else 
        return ""
    end
end
def similar_length(word)
    a = word[0]
    db = SQLite3::Database.new("db/data.db")
    arr = db.execute("SELECT * FROM Words WHERE word LIKE '#{a}%'")
    output = []
    arr.each do |thing|
        if thing[0].chomp.length == word.length or thing[0].chomp.length == word.length - 1 or thing[0].chomp.length == word.length + 1
            output.append(thing[0].chomp)
        end
    end
    return output
end
def not_in_array(word, arr)
    i = 0
    while i < arr.length
        if word == arr[i]
            return false
        end
        i += 1
    end
    return true
end
def letters_compare(arr, word_arr) #kolla så output är en float
    i = 0
    output = 0
    while i < arr.length
        if not_in_array(arr[i], word_arr) == false
            output += 1
        end
        i += 1
    end
    return output/word_arr.length.to_f
end
def find_word_v2(word, arr)
    i = 0
    correct = []
    while i < arr.length
        correct.append(0)
        j = 0
        while j < word.length
            if arr[i].length == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j] == word[j] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length - 1 == word.length 
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length + 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j - 1] == word[j] or arr[i][j - 1] == word[j - 1]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    while i < correct.length
        if correct[i]/word.length.to_f >= 0.75
            output.append(arr[i])
        end
        i += 1
    end
    return output
end
def find_word_v1(word, arr)
    i = 0
    correct = []
    while i < arr.length
        correct.append(0)
        j = 0
        while j < arr[i].length
            if arr[i].length == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length + 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length - 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j - 1] 
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    while i < correct.length
        if correct[i]/word.length.to_f >= 0.75
            output.append(arr[i])
        end
        i += 1
    end
    return output
end
def find_word_main(word, arr)
    arr1 = find_word_v1(word, arr)
    arr2 = find_word_v2(word, arr)
    priority = []
    i = 0
    while i < arr1.length
        j = 0
        while j < arr2.length
            if arr1[i] == arr2[j]
                if not_in_array(arr1[i], priority)
                    priority.append(arr1[i])
                end
            end
            j += 1
        end
        i += 1
    end
    if arr2.length < arr1.length
        arr3 = arr2 + arr1
    else
        arr3 = arr1 + arr2
    end
    i = 0
    while i < arr3.length
        if not_in_array(arr3[i], priority)
            priority.append(arr3[i])
        end
        i += 1
    end
    return priority
end
def similar_letters(word, arr)
    i = 0
    letters = []
    while i < word.length
        if not_in_array(word[i], letters)
            letters.append(word[i])
        end
        i += 1
    end
    i = 0
    arr_letters = []
    while i < arr.length
        j = 0
        arr_letters.append([])
        while j < arr[i].length
            if not_in_array(arr[i][j], arr_letters[i])
                arr_letters[i].append(arr[i][j])
            end
            j += 1
        end
        i += 1
    end
    output = []
    correct = []
    i = 0
    while i < arr.length #Något här
        correct.append(0)
        correct[i] = letters_compare(arr_letters[i], letters)
        i += 1
    end
    i = 0
    if word.length >= 4
        while i < correct.length
            if correct[i] >= 0.75
                output.append(arr[i])
            end
            i += 1
        end
    else
        while i < correct.length
            if correct[i] >= 0.66
                output.append(arr[i])
            end
            i += 1
        end
    end
    return output
end
def similar_letters_v2(word, arr)
    i = 0
    letters = []
    while i < word.length
        if not_in_array(word[i], letters)
            letters.append(word[i])
        end
        i += 1
    end
    i = 0
    arr_letters = []
    while i < arr.length
        j = 0
        arr_letters.append([])
        while j < arr[i].length
            if not_in_array(arr[i][j], arr_letters[i])
                arr_letters[i].append(arr[i][j])
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    correct =[]
    while i < arr.length
        correct.append(0)
        correct[i] = letters_compare(letters, arr_letters[i])
        i += 1
    end
    i = 0
    if word.length >= 4
        while i < correct.length
            if correct[i] >= 0.75
                output.append(arr[i])
            end
            i += 1
        end
    else
        while i < correct.length
            if correct[i] > 0.67
                output.append(arr[i])
            end
            i += 1
        end
    end
    return output
end
def spelling(word) #100% högre prio, tre bokstäver
    word = word.downcase
    session[:words] = word
    session[:output] = []
    ii = similar_length(session[:words])
    arr = find_word_main(session[:words], ii)
    output = similar_letters(session[:words], arr)
    output = similar_letters_v2(session[:words], output)
    return output
end
def start()
    i = rand(0..25)
    session[:last_played] = $abc_array[i]
end
def add_word_db(word)
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO words(word, new) VALUES(?, ?)",word, 2)
end
def send_to_db()
    db = SQLite3::Database.new("db/data.db")
    db.execute("INSERT INTO rounds (Used_words, Spelling, How_end, Player) VALUES(?,?,?,?)", session[:used_words].join(","), session[:spell_used].join(","), session[:still_play], session[:name])
end
get("/play") do 
    slim(:input)
end
get("/addmm") do
    slim(:add_m)
end
get("/start") do
    if session[:name] == nil
        redirect('/name')
    end
    session[:used_words] = []
    session[:last_played] = ""
    session[:still_play] = 0
    session[:spell_used] = []
    start()
    redirect("/play")
end
get('/name') do
    slim(:name)
end
post('/name') do 
    session[:name] = params[:nickn]
    redirect("/start")
end
post('/name2') do
    session[:name] = params[:nickn]
    redirect("/")
end
get('/') do
    slim(:home)
end
get('/lost') do
    send_to_db()
    session[:used_words] = [] 
    session[:spell_used] = []
    slim(:lost)
end
get('/spelling') do
    session[:out] = spelling(session[:worrd])
    session[:print] = ""
    session[:out].each do |hold|
        session[:print] += hold.upcase + ", "
    end
    session[:print][session[:print].length - 2] = "."
    slim(:spelling)
end
post("/spelling") do
    session[:newword] = params[:word]
    if session[:newword] == "0"
        session[:still_play] = 3
        slim(:lost)
    else
        session[:valied]  = valied_word(session[:newword])
        if session[:valied] 
            session[:spell_used].append(session[:newword])
            ai_select_word()
        else
            redirect('/lost')
        end
        redirect('/play')
    end 
end
post("/playy") do
    session[:worrd] = params[:word].downcase #Snyggare med stor bokstav?
    session[:valied] = valied_word(session[:worrd])
    if session[:valied]
        session[:spell_used].append(nil)
        ai_select_word()
    else 
        redirect('/lost')
    end
    redirect("/play")
end
get("/add") do
    slim(:new_word)
end
get("/info") do
    slim(:info)
end
get("/name") do
    slim(:name2)
end
post("/adding") do
    add_word_db(params[:add])
    session[:valied] = valied_word(params[:add])
    if session[:valied]
        session[:spell_used].append(nil)
        ai_select_word()
    else 
        redirect('/lost')
    end
    redirect("/play")
end
post("/llose") do
    session[:still_play] = 3
    redirect('/lost')
end
post("/new_word") do
    add_word_db(params[:newword])
    redirect("/")
end