require 'open-uri'

class GamesController < ApplicationController

  def new
    @grid = []
    10.times { |_l| @grid << ('A'..'Z').to_a.sample }
    @grid
  end

  def score
    @gridrev = params[:grid].split(' ')
    @word = params[:word]
    @score = 0
    @message = ''

    if check_word(@word, @gridrev) && check_word_online(@word)
      @score = (@word.size.to_f / @gridrev.size) * 10
      @message = 'Well done'
    elsif !check_word_online(@word)
      @score = 0
      @message = 'Not an english word'
    else
      @score = 0
      @message = 'Not in grid'
    end
  end

  def check_word(attempt, grid)
    attempt.upcase.chars.all? { |ch| grid.delete_at(grid.index(ch)) if grid.include?(ch) }
  end

  def check_word_online(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end
end
