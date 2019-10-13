require 'discordrb'

bot = Discordrb::Bot.new token: 'NjMzMDAyODQ5NjM0MjIyMTM0.XaOT0g.m9XN0lG93M6peNpJnCScpPWpyEc'

bot.message(start_with: '§') do |event|
  event.respond 'Pong!'
end

bot.run
