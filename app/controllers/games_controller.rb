require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]

    word_serialized = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    word = JSON.parse(word_serialized)

    if word['found'] == false
      @message = "Sorry but <b>#{@word.upcase}</b> is not an English word..."
      @score = 0
    elsif !@word.upcase.chars.all? { |letter| @word.upcase.chars.count(letter) <= @letters.count(letter) }
      @message = "Sorry but <b>#{@word.upcase}</b> is not in the grid: #{@letters}"
      @score = 0
    else
      @message = "Well done! <b>#{@word.upcase}</b> is a valid English word!"
      @score = @word.length
    end
    session[:score] = 0 if session[:score].nil?
    session[:score] += @score
  end
end
