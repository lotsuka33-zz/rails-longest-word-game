require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @array = ('A'..'Z').to_a
    @letters = []
    counter = 0
    until counter == 7
      @letters << @array.sample(1)
      counter += 1
    end
    @letters
  end

  def score
    # raise
    @word = params[:word]
    @letters = params[:letters].split
    @valid_letters = check_letters(@word, @letters)
    @valid_word = check_dictionary(@word)
  end

  def check_letters(word, letters)
    letter_hash = count_letters(word)
    letter_hash.each do |key, _value|
      return false if letter_hash[key] > letters.flatten.count(key.upcase)
    end
  end

  def count_letters(word)
    letter_hash = {}
    word.scan(/\w/).each do |letter|
      if letter_hash.key?(letter)
        letter_hash[letter] += 1
      else
        letter_hash[letter] = 1
      end
    end
    letter_hash
  end

  def check_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    words_validation = JSON.load(word_serialized)
    words_validation['found']
  end
end
