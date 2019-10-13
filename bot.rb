require 'discordrb'

bot = Discordrb::Bot.new token: 'NjMzMDAyODQ5NjM0MjIyMTM0.XaOW3w.BXhUqZubqkmXDEIRRUeg2dBjbPA'

bot.message(start_with: '§') do |event|
  event.respond 'Pong!'
end

bot.run
