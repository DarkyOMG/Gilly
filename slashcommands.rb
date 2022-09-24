# This is a standalone-script so it doesn't have to run every time the bot starts.
require 'discordrb'
token = ENV["BOT_TOKEN"] || (File.read("token.txt").split)[0]
server = ENV["SERVER_ID"] || (File.read("serverid.txt").split)[0]
bot = Discordrb::Bot.new token: token, intents: :all

bot.ready do
    bot.register_application_command('help', "Shows the help", server_id: server)

    bot.register_application_command('rep', "Link to Github-Repo", server_id: server)

    bot.register_application_command('hangman', "Play Hangman", server_id: server) do |cmd|
        cmd.subcommand('start', "Start a new game")
        cmd.subcommand('stop', "Stop your running game")
    end

    bot.register_application_command('try', "Guess a letter for you hangman game",server_id: server) do |cmd|
        cmd.string('guess', "Your guess", required: true)
    end
    bot.stop
end

bot.run

puts "All commands deployed to "+server.to_s