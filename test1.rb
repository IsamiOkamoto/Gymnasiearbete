require 'slim'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'csv'
enable :sessions

$alphabet_count = [0,381,810,1606,1982,2247,2540,2771,3036,3242,3303,3364,3604,3987,4105,4247,4837,4864,5190,5998,6387,6435,6560,6759,6761,6787] #Ta bort senare
$abc_array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
def reader(place)
    x = File.readlines("list.csv")
    return x[place].chomp
end
def rows()
    x = File.readlines("list.csv")
    return x.length
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
    a = which_letter_index(input[0])
    i1 = $alphabet_count[a]
    if a == 25
        i2 = rows()
    else
        i2 = $alphabet_count[a + 1]
    end
    x = File.readlines("list.csv")
    while i1 < i2
        if input == x[i1].downcase.chomp
            return true
        end
        i1 += 1
    end
    session[:out] = spelling(input)
    if session[:out].length != 0
        redirect('/spelling')
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
    a1 = which_letter_index(a)
    i1 = $alphabet_count[a]
    if a == 25
        i2 == rows()
    else
        i2 = $alphabet_count[a + 1]
    end
    hold = i2 - i1
    i = 0
    n = 0
    while i < session[:used_words].length
        if session[:used_words][i][0] == a1
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
    a = which_letter_index(session[:last_played][session[:last_played].length - 1])
    if ai_lose(a)
        i1 = $alphabet_count[a]
        if a == 25
            i2 == rows()
        else
            i2 = $alphabet_count[a + 1]
        end
        i = 0
        x = File.readlines("list.csv")
        while i < 1
            word = x[rand(i1..i2)].chomp
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
    a = which_letter_index(word[0])
    i1 = $alphabet_count[a]
    if a == 25
        i2 == rows()
    else
        i2 = $alphabet_count[a + 1]
    end
    output = []
    x = File.readlines("list.csv")
    while i1 < i2
        if x[i1].chomp.length == word.length or x[i1].chomp.length == word.length - 1 or x[i1].chomp.length == word.length + 1
            output.append(x[i1].chomp)
        end
        i1 += 1
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
    p word
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
    #p session[:last_played]
end
def send_to_db()

end
get("/play") do 
    slim(:input)
end
get("/start") do
    if session[:name] == nil
        redirect('/name')
    end
    session[:used_words] = []
    session[:words_to_csv] = []
    session[:last_played] = ""
    session[:still_play] = 0
    session[:spell] = ""
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
get('/') do
    slim(:home)
end
get('/lost') do
    send_to_db()
    slim(:lost)
end
get('/spelling') do
    session[:out] = spelling(session[:worrd])
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
            session[:spell_used].append(session[:newword]) #$spell_used
            ai_select_word()
        else
            #session[:still_play] = 1 #$still_play
            session[:used_words] = [] #$used_words
            redirect('/lost')
        end
        redirect('/play')
    end 
end
post("/playy") do
    #p session[:spell_used]
    #p params[:word]
    session[:worrd] = params[:word].downcase #Snyggare med stor bokstav?
    session[:valied] = valied_word(session[:worrd])
    if session[:valied]
        session[:spell_used].append(nil) #$spell_used
        ai_select_word()
    else
        #session[:still_play] = 1 #$still_play
        session[:used_words] = [] #$used_words #remove/send to data
        session[:spell_used] = [] #spell_used
        redirect('/lost')
    end
    redirect("/play")
end
#spelling error downcase on nil?