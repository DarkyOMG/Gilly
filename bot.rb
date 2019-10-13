require 'discordrb'

bot = Discordrb::Bot.new token: 'NjMzMDAyODQ5NjM0MjIyMTM0.XaOZpw.ld_6ZSU0-jpQvtdSLKmiNiaEsN8'

bot.message(with_text: '§') do |event|
  event.respond 'Try §help :)'
end
bot.message(with_text: '§help') do |event|
  event.respond 'Everyone needs a little help :)'
end

bot.message(with_text: '§rep') do |event|
  event.respond 'https://github.com/DarkyOMG/DiscBot'
end
bot.message(with_text: '§play') do |event|
  event.respond 'Wanna play? ;)'

  event.user.await(:guess) do |guess_event|
    # Their message is a string - cast it to an integer
    guess = guess_event.message.content
    if guess == "yes"
      guess_event.respond 'Not in the mood..'
    else
      guess_event.respond 'Figures.'
    end
  end
end



bot.run
