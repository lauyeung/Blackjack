#!/usr/bin/env ruby
# encoding: UTF-8
class Blackjack
  
  attr_writer :card
  SUITS = ['♠', '♣', '♥', '♦']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K','A']

  def initialize
    @deck = Array.new
    build_deck
    @turn_state = 'Player'
    @player_score = 0
    @dealer_score = 0
    @ace_switch = 0
    deal_amount('h*2')
  end

  private

  def deal_amount(deal_state)
    if(deal_state == 'h*2')
      num = 2
    elsif(deal_state == 'h')
      num = 1
    end
    deal(num)
  end

  def deal(num)
      num.times do
        card = @deck.pop
        puts "#{@turn_state} was dealt #{card}"
        interpret_card(card)
      end
      display_score(@turn_state, @player_score)
      interpret_score(@turn_state, @player_score)
  end

  def build_deck
    SUITS.each do |suit|
      VALUES.each do |value|
        @deck.push(value + suit)
      end
    end
    @deck.shuffle!
  end

    def interpret_card(card)
    card_val = card.chop
    case card_val
    when 'J'
      score = 10
    when 'Q'
      score = 10
    when 'K'
      score = 10
    when 'A'
      @ace_switch += 1
      puts @ace_switch
      if(@ace_switch == 1 && (@player_score <= 10 || @dealer_score <= 10))
        score = 11
      elsif(@ace_switch >= 2 && (@player_score >= 10 || @dealer_score >= 10))
        score = 1
      end
    else
      score = card_val
    end
    calc_score(score)
  end

  def calc_score(score)
    if(@turn_state == 'Player')
      @player_score += score.to_i
    elsif(@turn_state == 'Dealer')
      @dealer_score += score.to_i
    end  
  end

  def interpret_score(turn_state, player_score)
    if(turn_state == 'Player' && player_score > 21)
      puts 'Bust! You lose...'
    else
      hit_check
    end
  end


  def hit_check
    if(@turn_state == 'Player')
      print "Hit or stand (s/h): "
      input = gets.chomp.downcase
      if(input == 'h')
        deal_amount(input)
      elsif(input == 's')
        change_player
      end
    elsif(@turn_state == 'Dealer')
      if(@dealer_score >= 17)
        puts 'Dealer stands.'
        game_outcome
      elsif(@dealer_score < 17)
        deal_amount('h')
      end
    end
  end

  def game_outcome
    if(@player_score > @dealer_score)
      puts 'You win!'
    elsif(@player_score == @dealer_score)
      puts "It's a draw!"
    else
      puts 'You lose. Dealer wins!'
    end
  end


  def display_score(turn_state, player_score)
    if(turn_state == 'Player')
      puts "#{turn_state} score: #{@player_score}"
    else
      puts "#{turn_state} score: #{@dealer_score}"
    end
  end

  def change_player
    deal_state = 'h*2'
    @turn_state = 'Dealer'
    deal_amount(deal_state)
  end
end

game = Blackjack.new