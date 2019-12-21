require 'discordrb'
require_relative 'hangman.rb'

token = ENV["BOT_TOKEN"] || (File.read("token.txt").split)[0]

bot = Discordrb::Bot.new token: token
games = {}
def printpretty(word)
  prettyword = ""
  for i in 0..word.size-1
    prettyword << word[i]+" "
  end
  return prettyword
end


def findWord()
  words = File.read("words.txt").encode('UTF-8', :invalid => :replace).split
  wordnumber = rand(words.size-1)
  keyword = words[wordnumber]
  return keyword
end


bot.message(with_text: '§help') do |event|
  event.respond 'You can try §hangman to play hangman with me, or §rep to see my source.'
end

bot.ready do
  bot.listening=('§help')
end

bot.message(with_text: '§rep') do |event|
  event.respond 'https://github.com/DarkyOMG/Gilly'
end
bot.message(with_text: '§hangman stop') do |event|
games.delete(event.user.id)
event.respond 'Okey, your game has been deleted.'
end


bot.message(start_with: '§hangman') do |event|
if (event.message.content == "§hangman stop") then
break
end
if (games.key?(event.user.id)) then
	regexp = /§hangman\s*(?<try>.*)/
    match =  regexp.match(event.message.content)
	if match == nil then
	 event.respond 'You have to guess! Try §hangman f or any other letter!'
	elsif games[event.user.id].tried.include? match[:try] then
	event.respond 'You alread tried that!'
	elsif match[:try].length > 1 then
	 if (games[event.user.id].trysolve(match[:try])) then
	 event.respond "That's right! Congratulations!"
	 event.respond '' +games[event.user.id].word + ' was the answer!'
	 games.delete(event.user.id)
	 break
	 else
	 games[event.user.id].loseLife()
	 event.respond ''+ match[:try]+' is not right.'
	 event.respond ''+ games[event.user.id].lives.to_s + ' lives left!'
	 end
	elsif (!(games[event.user.id].tryletter(match[:try]))) then
	 games[event.user.id].loseLife()
	 event.respond ''+ match[:try]+' is not present.'
	 event.respond ''+ games[event.user.id].lives.to_s + ' lives left!'
	end
	if (games[event.user.id].word.downcase == games[event.user.id].guessed.downcase) then
	event.respond "That's right! Congratulations!"
	event.respond '' +games[event.user.id].word + ' was the answer!'
	games.delete(event.user.id)
	elsif (games[event.user.id].lives < 1) then
	event.respond "You lost! But the word was "+games[event.user.id].word
	games.delete(event.user.id)
	else
	event.respond printpretty(games[event.user.id].guessed)
	end
else
 event.respond 'Alrighty! Give me your guesses like this §hangman f if you want to try the letter f.'
 event.respond 'Or write §hangman stop if you want to cancel your current game.'
 games[event.user.id] = Game.new(findWord())
 puts games[event.user.id].word
 event.respond printpretty(games[event.user.id].guessed)
 end
end


bot.message(with_text: '§gotobed') do |event|
  event.respond 'Sleep tight :)'
  bot.stop
  true
end



bot.run
