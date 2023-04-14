use std::env;
use std::process::exit;

#[derive(Debug)]
struct FiniteAutomaton {
    adjacency_list: Vec<(u16, u16, char)>,
    final_states: Vec<u16>,
}

fn build_finite_automaton() -> FiniteAutomaton {
    FiniteAutomaton {
        // current, target, char
        adjacency_list: vec![
            (0, 1, '0'),
            (1, 2, 'B'),
            (1, 2, 'b'),
            (2, 3, '0'),
            (2, 3, '1'),
            (3, 3, '0'),
            (3, 3, '1'),
        ],
        final_states: vec![3],
    }
}

fn run_automaton(finite_automaton: FiniteAutomaton, user_string: &str) {
    const FIRST_STATE: u16 = 0;
    let mut current_state: u16 = FIRST_STATE;
    let mut has_not_defined_step: bool = false;

    for character in user_string.chars() {
        println!("State: {} Character: {}", current_state, character);
        let matched_adjacency =
            finite_automaton
                .adjacency_list
                .iter()
                .find(|&&current_adjacency| -> bool {
                    current_adjacency.0 == current_state && current_adjacency.2 == character
                });

        if matched_adjacency == None {
            has_not_defined_step = true;
        } else {
            let next_state = matched_adjacency.unwrap().1;
            current_state = next_state;
        }
    }

    let result = if finite_automaton.final_states.contains(&current_state) && !has_not_defined_step
    {
        "Input accepted"
    } else {
        "Input not Accepted"
    };
    println!("State: {} Result: {}", current_state, result);
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Please add source");
        exit(1);
    }
    let user_string: &String = &args[1];
    run_automaton(build_finite_automaton(), user_string);
}