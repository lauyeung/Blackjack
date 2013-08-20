#!/usr/bin/env ruby
# encoding: UTF-8
class Blackjack
  
  attr_writer :hand

  def initialize
    @deck = Array.new
    @SUITS = ['♠', '♣', '♥', '♦']
    @VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    build_deck
    @turn_state = 'Player'
    @player_score = 0
    @dealer_score = 0
    deal_amount('h*2')
  end


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
        hand = @deck.pop
        puts "#{@turn_state} was dealt #{hand}"
        interpret_hand(hand)
      end
      display_score(@turn_state, @player_score)
      interpret_score(@turn_state, @player_score)
  end

  private

  def interpret_score(turn_state, player_score)
    if(turn_state == 'Player' && player_score > 21)
      puts 'Bust! You lose...'
    else
      hit_check(turn_state, player_score)
    end
  end

  def build_deck
    @SUITS.each do |suit|
      @VALUES.each do |value|
        @deck.push(value + suit)
      end
    end
    @deck.shuffle!
  end

  def hit_check(turn_state, turn_score)
    if(turn_state == 'Player')
      print "Hit or stand (s/h): "
      input = gets.chomp.downcase
      if(input == 'h')
        deal_amount(input)
      elsif(input == 's')
        change_player
      end
    elsif(turn_state == 'Dealer')
      if(turn_score > 17)
        puts 'Dealer stands.'
        game_outcome(@player_score, @dealer_score)
      elsif(dealer_score < 17)
        deal_amount('h')
      end
    end
  end

  def game_outcome(player_score, dealer_score)
    if(player_score > dealer_score)
      puts 'You win!'
    else
      puts 'You lose. Dealer wins!'
    end
  end

  def change_player
    deal_state = 'h*2'
    @turn_state = 'Dealer'
    deal_amount(deal_state)
  end
  
  def interpret_hand (hand)

    hand_val = hand.chop
    case hand_val
    when 'J'
      score = 10
    when 'K'
      score = 10
    when 'Q'
      score = 10
    when 'A'
      ace_switch = true
      score = 11
    else
      score = hand_val
    end
    calc_score(score, ace_switch)
  end

  def calc_score(score, ace_switch)
    if(@turn_state == 'Player')
      @player_score += score.to_i
      if(ace_switch && @player_score > 21)
        @player_score -= 10
      end
    elsif(@turn_state == 'Dealer')
      @dealer_score += score.to_i
      if(ace_switch && @dealer_score > 21)
        @dealer_score -= 10
      end
    end  

  end

  def display_score(turn_state, player_score)
    if(turn_state == 'Player')
      puts "#{@turn_state} score: #{@player_score}"
    else
      puts "#{@turn_state} score: #{@dealer_score}"
    end
  end
end

game = Blackjack.new