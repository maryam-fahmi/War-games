defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """
  def deal(shuf) do

  #Shuffle deck
    deck = Enum.map(shuf, fn card ->
      cond do
        card == 1 ->
          14 #change 1's to 14's for Ace
        true ->
          card
      end
    end)

  #Deal cards for both players
    [player1round, player2round] = hands(deck,[],[],0)
    [winner, result] = game(player1round, player2round, [])

  #Check if game is tied and returns either the original deck or the result deck
  cond do
    winner == :tie ->
      Enum.map(Enum.sort(deck,:desc), fn card ->
        cond do
          card == 14 -> 1
          true -> card
        end
      end)
    true ->
      Enum.map(result, fn card ->
        cond do
          card == 14 -> 1
          true -> card
        end
      end)
  end
end

  defp hands(deck, player1round, player2round, count) do # Function to deal the deck to both players and reverse the piles
  cond do
    deck == [] -> [Enum.reverse(player1round), Enum.reverse(player2round)]
    true ->
      [head | tail] = deck
      cond do
        rem(count, 2) == 0 -> hands(tail, player1round ++ [head], player2round, count + 1)
        true -> hands(tail, player1round, player2round ++ [head], count + 1)
      end
    end
  end

#1 - Tie
  defp game([], [], currentdeck), do: [:tie, currentdeck]

#Non-War Situations

#2 - one player runs out of cards
  defp game(player1round, [], []), do: [:winnerP1, player1round]
  defp game([], player2round, []), do: [:winnerP2, player2round]

#3 - one player runs out of cards when deck is not empty
  defp game([], player2round, currentdeck), do: [:winnerP2, player2round ++ currentdeck]
  defp game(player1round, [], currentdeck), do: [:winnerP1, player1round ++ currentdeck]

#4 - Player 1 has a higher card
defp game([player1head | player1tail], [player2head | player2tail], currentdeck) when player1head > player2head do
  cond do
    currentdeck == [] ->
      game(player1tail ++ [player1head,player2head], player2tail, [])
    true ->
      game(player1tail ++ Enum.sort([player1head,player2head | currentdeck], :desc), player2tail, [])
  end
end

#5 - Player 2 has a higher card
defp game([player1head | player1tail], [player2head | player2tail], currentdeck) when player2head > player1head do
  cond do
    currentdeck == [] ->
      game(player1tail, player2tail ++ [player2head,player1head], [])
    true ->
      game(player1tail, player2tail ++ Enum.sort([player2head,player1head | currentdeck], :desc), [])
  end
end

#6 - Player 2 has one card left and loses
defp game([player1head | player1tail], [player2head|[]], currentdeck) when player1head > player2head do
  cond do
    currentdeck == [] ->
      [:winnerP1, player1tail ++ [player1head, player2head]]
    true ->
      [:winnerP1, player1tail ++ Enum.sort([player1head, player2head | currentdeck], :desc)]
  end
end

#7 - Player 1 has one card left annd loses
defp game([player1head|[]], [player2head|player2tail], currentdeck) when player2head > player1head do
  cond do
    currentdeck == [] ->
      [:winnerP2, player2tail ++ [player2head, player1head]]
    true ->
      [:winnerP2, player2tail ++ Enum.sort([player2head, player1head | currentdeck], :desc)]
  end
end

#War Situations

#8 - Player 2 goes to war with 1 card, loses
defp game([player1head | player1tail], [player2head|[]], currentdeck) when player1head == player2head do
  cond do
    currentdeck == [] ->
      [:winnerP1, player1tail ++ [player1head, player2head]]
    true ->
      [:winnerP1, player1tail ++ Enum.sort([player1head, player2head | currentdeck], :desc)]
  end
end

#9 - Player 1 goes to war with 1 card, loses
defp game([player1head|[]], [player2head|player2tail], currentdeck) when player2head == player1head do
  cond do
    currentdeck == [] ->
      [:winnerP2, player2tail ++ [player2head, player1head]]
    true ->
      [:winnerP2, player2tail ++ Enum.sort([player2head, player1head | currentdeck], :desc)]
  end
end

#10 - War
defp game([player1head, facedown_p1 | player1tail], [player2head, facedown_p2 | player2tail], currentdeck)
      when player1head == player2head do
  cond do
    currentdeck == [] ->
      game(player1tail, player2tail, [facedown_p1, player1head, facedown_p2, player2head])
    true ->
      game(player1tail, player2tail, Enum.sort([facedown_p1, player1head, facedown_p2, player2head | currentdeck], :desc))
  end
end


#11 - Player 1 has less cards than needed to go into war
defp game([player1head, facedown_p1 |[]], [player2head, facedown_p2| player2tail], currentdeck) do
  cond do
    currentdeck == [] ->
      game([], Enum.sort(player2tail ++ [player1head, facedown_p1, player2head, facedown_p2], :desc), [])
    true ->
      game([], Enum.sort(currentdeck ++ [player1head, facedown_p1, player2head, facedown_p2, player2tail], :desc), [])
  end
end

#12 - Player 2 has less cards than needed to go into war
defp game([player1head, facedown_p1 |player1tail], [player2head, facedown_p2| []], currentdeck) do
  cond do
    currentdeck == [] ->
      game([], Enum.sort(player1tail ++ [player1head, facedown_p1, player2head, facedown_p2], :desc), [])
    true ->
      game([], Enum.sort(currentdeck ++ [player1head, facedown_p1, player2head, facedown_p2, player1tail], :desc), [])
  end
end

end
