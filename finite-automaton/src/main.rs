use serde::{Deserialize, Serialize};
use std::env;
use std::fs;

#[derive(Serialize, Deserialize, Debug)]
struct FiniteAutomaton {
    adjacency_list: Vec<(u16, u16, char)>,
    final_states: Vec<u16>,
}

fn run_automaton(finite_automaton: FiniteAutomaton, user_string: &str) {
    const FIRST_STATE: u16 = 0;
    let mut current_state: u16 = FIRST_STATE;
    let mut has_not_defined_step: bool = false;

    for character in user_string.chars() {
        println!("{} {}", current_state, character);
        let matched_adjacency =
            finite_automaton
                .adjacency_list
                .iter()
                .find(|&&current_adjacency| -> bool {
                    current_adjacency.0 == current_state && current_adjacency.2 == character
                });

        if matched_adjacency == None {
            has_not_defined_step = true;
            break;
        } else {
            current_state = matched_adjacency.unwrap().1;
        }
    }

    println!(
        "{} {}",
        current_state,
        if finite_automaton.final_states.contains(&current_state) && !has_not_defined_step {
            "Input accepted"
        } else {
            "Input rejected"
        }
    );
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let user_string: &String = &args[2];
    let fa_file: &String = &args[1];
    let automaton_file_content =
        fs::read_to_string(&fa_file).expect("Should have been able to read the file");
    let finite_automaton = serde_json::from_str(&automaton_file_content).unwrap();
    let serialized = serde_json::to_string(&finite_automaton).unwrap();
    println!("FA = {}", serialized);
    run_automaton(finite_automaton, user_string);
}
