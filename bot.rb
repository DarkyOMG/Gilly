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


bot.application_command(:help) do |event|
  event.respond content: 'You can try `/hangman` to play hangman with me, or `/rep` to see my source.', ephemeral: true
end

bot.ready do
  bot.listening=('/help')
end

bot.application_command(:rep) do |event|
  event.respond content: 'https://github.com/DarkyOMG/Gilly', ephemeral: true
end

bot.application_command(:try) do |event|
	done = false
	if (games.key?(event.user.id)) then
		guess = event.options['guess']
		event.respond content: "You tried `"+ guess+"`"
		if games[event.user.id].tried.include? guess then
			event.channel.send_message 'You alread tried that!'
		elsif guess.length > 1 then
			if (games[event.user.id].trysolve(guess)) then
				event.channel.send_message "That's right! Congratulations!"
				event.channel.send_message '`' +games[event.user.id].word + '` was the answer!'
				games.delete(event.user.id)
				done = true
			else
				games[event.user.id].loseLife()
				event.channel.send_message ''+ guess+' is not right.'
				event.channel.send_message ''+ games[event.user.id].lives.to_s + ' lives left!'
			end
		elsif (!(games[event.user.id].tryletter(guess))) then
			games[event.user.id].loseLife()
			event.channel.send_message ''+ guess+' is not present.'
			event.channel.send_message ''+ games[event.user.id].lives.to_s + ' lives left!'
		end
		unless done
			if (games[event.user.id].word.downcase == games[event.user.id].guessed.downcase) then
				event.channel.send_message "That's right! Congratulations!"
				event.channel.send_message '`' +games[event.user.id].word + '` was the answer!'
				games.delete(event.user.id)
			elsif (games[event.user.id].lives < 1) then
				event.channel.send_message "You lost! But the word was `"+games[event.user.id].word+"`"
				games.delete(event.user.id)
			else
				event.channel.send_message printpretty(games[event.user.id].guessed)
			end
		end
	else
		event.respond content: "You don't have a running game. Start one first with `/hangman start`!", ephemeral: true
	end
end

bot.application_command(:hangman).subcommand('stop') do |event|
	games.delete(event.user.id)
	event.respond content: 'Okey, your game has been deleted.'
end

bot.application_command(:hangman).subcommand('start') do |event|
	if (games.key?(event.user.id)) then
		event.respond content: 'You already have an open hangman-game. Say `/hangman stop` if you want to cancel your current game or `/try` to try letters or words'
	else
		games[event.user.id] = Game.new(findWord())
		puts games[event.user.id].word
		event.respond content: printpretty(games[event.user.id].guessed)
		event.channel.send_message "Alrighty! Give me your guesses like this `/try f` if you want to try the letter f. You can also try to solve with `/try eisenbahn`."
		event.channel.send_message "Or write `/hangman stop` if you want to cancel your current game."
	end
end


bot.application_command(:gotobed) do |event|
	event.respond content: 'Sleep tight :)'
	bot.stop
	true
end



bot.run
