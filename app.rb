require 'slim'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'csv'

$alphabet_count = [0,381,810,1606,1982,2247,2540,2771,3036,3242,3303,3364,3604,3987,4105,4247,4837,4864,5190,5998,6387,6435,6560,6759,6761,6787] #Ta bort senare
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
        if x[i1].length.chomp == word.length or x[i1].length.chomp == word.length - 1 or x[i1].length.chomp == word.length + 1
            output.append(x[i1].chomp)
        end
        i1 += 1
    end
    return output
end
def find_word_2(word, arr)
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
                elsif j == word.length - 1:
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
        if correct[i]/word.length >= 0.75:
            output.append(arr[i])
        end
        i += 1
    end
    return output
end
def find_word_v1(word, arr):
    i = 0
    correct = []
    while i < len(arr):
        correct.append(0)
        j = 0
        while j < len(arr[i]):
            if len(arr[i]) == len(word):
                if j == 0:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]:
                        correct[i] += 1
                elif j == len(arr[i]) - 1:
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]:
                        correct[i] += 1
                else:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]:
                        correct[i] += 1
            elif len(arr[i]) + 1 == len(word):
                if j == 0:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]:
                        correct[i] += 1
                elif j == len(arr[i]) - 1:
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]:
                        correct[i] += 1
                else:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]:
                        correct[i] += 1
            elif len(arr[i]) - 1 == len(word):
                if j == 0:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]:
                        correct[i] += 1
                elif j == len(arr[i]) - 1:
                    if arr[i][j] == word[j - 1]: #questionable
                        correct[i] += 1
                else:
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]:
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
        if correct[i]/word.length >= 0.75:
            output.append(arr[i])
        end
        i += 1
    end
    return output
end