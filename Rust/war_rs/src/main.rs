#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.
    
    Test your code by running 'cargo test' from the war_rs directory.
*/

use std::result;
use std::cmp::Ordering;

// declaring mutable variables 
fn deal(deck: &[u8; 52]) -> [u8; 52] {
    let mut current_deck: Vec<u8> = deck.to_vec();
    let mut p1_deck: Vec<u8> = Vec::new();
    let mut p2_deck: Vec<u8> = Vec::new();
    let mut game_deck: Vec<u8> = Vec::new();
    let mut p1_first: u8;
    let mut p2_first: u8;
    let mut result: [u8; 52] = [4; 52];

// change all ones to 14 
    for card in current_deck.iter_mut() {
        match *card {
            1 => *card = 14,
            _ => {} 
        }
    }

// using even and odd matching to distribute the cards
    for (i, x) in current_deck.iter().enumerate() {
        match i % 2 {
            0 => p1_deck.push(*x),
            _ => p2_deck.push(*x),
        }
    }

// putting last card given as first (pile logic)
    p1_deck.reverse();
    p2_deck.reverse();


 
    loop {
        if p1_deck.is_empty() || p2_deck.is_empty() {
            break;
        }
// take out first card from each deck and remove it     
        let p1_first = p1_deck[0];
        let p2_first = p2_deck[0];
    
        p1_deck.remove(0);
        p2_deck.remove(0);
    
        game_deck.extend(&[p1_first, p2_first]);
        game_deck.sort_by(|a, b| b.cmp(a));

// check for who has larger cards and give them whole deck     
        match p1_first.cmp(&p2_first) {
            Ordering::Greater => {
                p1_deck.extend(game_deck);
                game_deck = Vec::new();
            }
            Ordering::Less => {
                p2_deck.extend(game_deck);
                game_deck = Vec::new();
            }
//otherwise go into war
            Ordering::Equal => {
                if p1_deck.is_empty() {
                    p2_deck.push(p2_first);
                    p2_deck.push(p1_first);
                } else if p2_deck.is_empty() {
                    p1_deck.push(p1_first);
                    p1_deck.push(p2_first);
                } else if !p1_deck.is_empty() && !p2_deck.is_empty() {
                    game_deck.extend([p1_deck.remove(0), p2_deck.remove(0)]);
                }
            }
        }
    }

//if both decks are empty return starting deck     
    if p1_deck.is_empty() && p2_deck.is_empty() {
        current_deck.sort_by(|a, b| b.cmp(a));
        for x in current_deck.iter_mut() {
        match x {
        14 => *x = 1,
        _ => {}
        }
    }
// putting all indexes of x into result 
        for (i, &x) in current_deck.iter().enumerate() {
            result[i] = x;
        }
    } 
//if its not a tie, check which deck is not empty and return that 
    else {
        let len = p1_deck.len();
        if len > 1 {
            for x in p1_deck.iter_mut() {
            match x {
            14 => *x = 1,
            _ => {}
        }
            }
            for (i, &x) in p1_deck.iter().enumerate() {
                result[i] = x;
            }
        } else {
            for x in p2_deck.iter_mut() {
            match x {
            14 => *x = 1,
            _ => {}
        }
            }
            for (i, &x) in p2_deck.iter().enumerate() {
                result[i] = x;
            }
        }
    }
    return result;
}

#[cfg(test)]
#[path = "tests.rs"]
mod tests;

