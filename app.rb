require 'slim'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'csv'

$alphabet_count = [0,381,810,1606,1982,2247,2540,2771,3036,3242,3303,3364,3604,3987,4105,4247,4837,4864,5190,5998,6387,6435,6560,6759,6761,6787]
$used_words = []
$words_to_csv = []
$last_played = ""
$still_play = 0
$spell = ""
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
    while i <$used_words.length
        if $used_words[i] == word
            return false
        end
        i += 1
    end
    return true
end
def last_word(input)
    if input[0] == $last_played[$last_played.length - 1]
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
        i2 == rows()
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
    return false
end
def valied_word(input)
    if last_word(input) && is_used(input) && word_exists(input)
        $used_words.append(input)
        $last_played = input
        return true
    else
        $still_play = 1
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
    while i < $used_words.length
        if $used_words[i][0] == a1
            n += 1
        end
        if n == hold
            $still_play = 2
            return false
        end
        i += 1
    end
    return true
end
def ai_select_word()
    a = which_letter_index($last_played[$last_played.length - 1])
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
