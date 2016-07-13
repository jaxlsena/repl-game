require "./cards_data"

#############    GAME METHODS    #############
def next_card(deck_of_cards)
  deck_of_cards.sample.keys.sample
end

def starting_hand(current_hand, deck_of_cards)
  2.times do
    cards = deck_of_cards.sample.keys.shuffle
    current_hand << cards.pop
  end
end

def hit(current_hand, deck_of_cards, current_round)
  current_hand << next_card(deck_of_cards)

  if busted?(current_hand, deck_of_cards)
    current_round[:done] = true
    puts "You busted!"
  end
  puts current_hand
end

def busted?(current_hand, deck_of_cards)
  total = 0
  current_hand.each do |card|
    deck_of_cards.each do |suit|
      if suit[card]
        total += suit[card]
      end
    end
  end
  if total > 21
    true
  else
    false
  end
end

def replay?
  puts "Would you like to play again? (yes/no)"
  print "> "
  answer = gets.chomp
  if answer == "yes"
    true
  elsif answer == "no"
    false
  else
    puts "Please enter: (Yes/No)"
    replay?
  end
end

def winner(current_hand, deck_of_cards, current_round)
  dealer = (4..21).to_a.sample
  total = 0
  current_hand.each do |card|
    deck_of_cards.each do |suit|
      if suit[card]
        total += suit[card]
      end
    end
  end
  if dealer > total
    puts "Dealer won! Dealer drew #{dealer}, you drew #{total}"
  else
    puts "You won! Dealer drew #{dealer}, you drew #{total}"
  end
  current_round[:done] = true
end

def round_over?(current_round)
  if current_round[:done]
    false
  else
    true
  end
end

def round(current_hand, deck_of_cards, current_round)
  puts "Dealing cards..."
  starting_hand(current_hand, deck_of_cards)
  puts "You were dealt..."
  puts current_hand

  while round_over?(current_round)
    puts "Would you like to hit or stay?"
    print "> "
    choice = gets.chomp
    case choice
    when "hit"
      puts "Dealing another card..."
      hit(current_hand, deck_of_cards, current_round)
    when "stay"
      puts "Good luck!"
      winner(current_hand, deck_of_cards, current_round)
    else
      puts "Please enter: hit or stay."
    end
  end
end
#############    END    #############

#############    BEGIN GAME    #############
def game
  begin
    deck_of_cards = [clubs, hearts, diamonds, spades]
    current_hand  = []
    current_round = { done: false }
    options       = { option_one: "Play", option_two: "Exit" }

    puts "♤ ♧ ♡ ♢  Welcome to BlackJack! What would you like to do? ♤ ♧ ♡ ♢"
    puts ">[#{options[:option_one]}]"
    puts ">[#{options[:option_two]}]"
    print "> "

    player = gets.chomp.downcase
    case player
    when "play"
      round(current_hand, deck_of_cards, current_round)
    when "exit"
      exit
    else
      puts "PLEASE ENTER: PLAY OR EXIT."
      game
    end
  end while replay?
end
#############    END    #############

game
