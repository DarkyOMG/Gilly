class Game 
 attr_reader :lives, :word, :guessed, :tried



 def initialize(word)
 @word = word
 @guessed = '-'*word.length 
 @lives = 8
 @tried = []
 end

 def tryletter(try)
  @tried << try
  ispresent = false
  for i in 0..word.size-1
    if try.downcase == word[i].downcase then
      guessed[i] = try.downcase
      ispresent = true
    end
  end
  return ispresent
end

def trysolve(try)
 @tried << try
  if try.downcase == word.downcase then
    return true
  else
    return false
  end
end

def loseLife()
 @lives -=1
end
end
