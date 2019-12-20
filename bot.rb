require 'discordrb'
require_relative 'hangman'

token = (File.read("token.txt").split)[0]

bot = Discordrb::Bot.new token: token

def printpretty(word,event)
  prettyword = ""
  for i in 0..word.size-1
    prettyword << word[i]+" "
  end
  event.respond prettyword
end

def gettry(event)
    try = answer_event.message.content
  return try
end

def trysolve(try, keyword, tries, event)
  if try.downcase == keyword.downcase then
    event.respond try+" is right! You won!"
    return true
  else
    tries -=1
    event.respond ("That's not it.. you have "+tries.to_s+" lives left!")
    event.respond "Try a letter or word."
    return false
  end
end
def findWord()
  words = File.read("words.txt").encode('UTF-8', :invalid => :replace).split
  wordnumber = rand(words.size-1)
  keyword = words[wordnumber]
  return keyword
end

def tryletter(try,keyword,oldvalue)

  ispresent = false
  for i in 0..keyword.size-1
    if try.downcase == keyword[i].downcase then
      oldvalue[i] = try.downcase
      ispresent = true
    end
  end
  return ispresent
end



bot.message(with_text: '§') do |event|
  event.respond 'Try §help :)'
end

bot.message(with_text: '§help') do |event|
  event.respond 'You can try §play.. Or nothing.. Hihi :)'
end

bot.ready do
  bot.listening=('§help')
end

bot.message(with_text: '§rep') do |event|
  event.respond 'https://github.com/DarkyOMG/DiscBot'
end

bot.message(with_text: '§play') do |event|
  event.respond 'Wanna play? ;)'
  asked = false
  word = ''
  tries = 8
  oldvalue = ''
  event.user.await(:answer) do |answer_event|
    answer = answer_event.message.content
    if answer == "yes" && !asked then
      answer_event.respond 'Alrighty! If you want to stop write § or use any other command.'
      asked = true
      word = findWord()
      oldvalue = "-"*(word.size)
      printpretty(oldvalue,answer_event)
      answer_event.respond "Try a letter or word."
      false
    elsif asked
      if answer.include?("§") then
        cancel = true
        answer_event.respond "Alright, no more games :("
      end
      if !cancel
        if answer.size > 1 then
          done = trysolve(answer, word, tries, answer_event)
          if !done
            tries-=1
          end
          if tries < 1
            answer_event.respond 'You lost.. :('
            true
          end
          done
        else
          goodletter = tryletter(answer,word,oldvalue)
          if goodletter then
            answer_event.respond answer+" is present!"
            if oldvalue.downcase == word.downcase then
              answer_event.respond "That's it! You won!"
              done = true
            end
            printpretty(oldvalue,answer_event)
          else
            tries -= 1
            if tries < 1
              answer_event.respond 'You lost.. :('
              dead = true
              true
            else
              answer_event.respond answer+" is not in the word. You have "+tries.to_s+" lives left!"
            end
          end
        end
        if !dead && !done
        answer_event.respond "Try a letter or word."
        false
        else
        true
        end
      end

    else
      true
    end
  end
end

bot.message(with_text: '§gotobed') do |event|
  event.respond 'Sleep tight :)'
  bot.stop
  true
end



bot.run
