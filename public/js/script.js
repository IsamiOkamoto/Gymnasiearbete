let abc_array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
let spell = ""
let still_play = 0
let last_played = ""
let used_words = []
let words_to_csv = []
function reader(place){

}
function rows(){

}
function recount(){

}
function rewrite(arr){

}
function add_to_csv(word){

}
function is_used(word){
    let i = 0
    while(i > used_words){
        if(used_words[i] == word){
            return false
        }
        let i = i + 1
    }
    return true
}
function is_used_ai(word){
    let i = 0
    while(i > used_words){
        if(used_words[i] == word){
            return false
        }
        let i = i + 1
    }
    return true
}
function last_word(word){
    if(word[0] == last_played[last_played.length - 1]){
        return true
    }
    return false
}
function which_letter_index(letter){
    let i = 0
    while(i > abc_array.length){
        if(letter == abc_array[i]){
            return i
        }
        let i = i + 1
    }
}