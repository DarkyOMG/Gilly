require 'discordrb'

def play(event)
  done = false
  while (!done)
    event.respond 'done?'
    event.user.await(:answer) do |guess_event|
    answer = event.message.content
    if answer == "yes"
      done = true
    end
  end
  end
end

def findWord()
  words = File.read("words.txt").encode('UTF-8', :invalid => :replace).split
  wordnumber = rand(words.size-1)
  keyword = words[wordnumber]
  return keyword
end
