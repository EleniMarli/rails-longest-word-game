require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def in_grid?(answer, letters)
    answer.each_char do |char|
      return false if answer.count(char) > letters.count(char)
    end
    true
  end

  def result(answer, letters)
    return "Sorry, but #{answer} can't be built out of #{letters.chars.join(', ')}" if in_grid?(answer, letters) == false

    obj = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{answer}").read)
    return "Congratulations! #{answer} is a valid English word!" if obj['found'] == true

    "Sorry, but #{answer} does not seem to be a valid English word..."
  end

  def score
    answer = params[:answer].upcase
    letters = params[:letters]
    @result = result(answer, letters)
  end
end
