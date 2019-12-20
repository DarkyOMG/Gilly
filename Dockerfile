FROM ruby:2.6

WORKDIR /app
COPY . .

RUN bundle install

CMD ["ruby", "bot.rb"]
