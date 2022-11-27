require 'slim'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'csv'
enable :sessions

$alphabet_count = [0,381,810,1606,1982,2247,2540,2771,3036,3242,3303,3364,3604,3987,4105,4247,4837,4864,5190,5998,6387,6435,6560,6759,6761,6787] #Ta bort senare
$used_words = []
$words_to_csv = []
$last_played = ""
$still_play = 0
$spell = ""
$spell_used = []
$abc_array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
def spelling(word) #100% högre prio, tre bokstäver
    sessions[:output] = []
    sessions[:words] = word
    sessions[:words] = sessions[:words].downcase
    p sessions[:words]
    sessions[:ii] = similar_length(sessions[:words])
    p sessions[:ii]
    sessions[:arr] = find_word_main(sessions[:words], sessions[:ii])
    p sessions[:arr]
    sessions[:output] = similar_letters(sessions[:words], sessions[:arr])
    p sessions[:output]
    sessions[:output] = similar_letters_v2(sessions[:words], sessions[:output])
    return sessions[:output]
end
p spelling("yelow")
get("/") do
    spelling("yelow")
end