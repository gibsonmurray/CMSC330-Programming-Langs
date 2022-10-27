open List
open Sets

(*********)
(* Types *)
(*********)

type ('q, 's) transition = 'q * 's option * 'q

type ('q, 's) nfa_t = {
  sigma: 's list;
  qs: 'q list;
  q0: 'q;
  fs: 'q list;
  delta: ('q, 's) transition list;
}

(***********)
(* Utility *)
(***********)

(* explode converts a string to a character list *)
let explode (s: string) : char list =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l)
  in
  exp (String.length s - 1) []

(****************)
(* Part 1: NFAs *)
(****************)

let rec move_help (d: ('q, 's) transition list) (qs: 'q list) (s: 's option) : 'q list =
  match d with
  | [] -> []
  | (state, trans, next)::rest -> if (elem state qs && s = trans) then next::(move_help rest qs s) else move_help rest qs s;;

let move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list = move_help nfa.delta qs s;;

let rec ec_help (d: ('q, 's) transition list) (q: 'q) : 'q list =
  match d with
  | [] -> [q]
  | (state, trans, next)::rest -> if (state = q && trans = None) then state::(ec_help d next) else ec_help rest q;;

let rec e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
  match qs with
  | [] -> []
  | h::t -> union (ec_help nfa.delta h) (e_closure nfa t);;

let rec accept_help nfa cs qs: bool = 
  match cs with
  | [] -> if (intersection qs nfa.fs) != [] then true else false
  | c::rest -> (let nexts = (move nfa qs (Some c)) in 
                if nexts != [] then (accept_help nfa rest nexts)
                else if (intersection qs nfa.fs) != [] then true else false);;

let accept (nfa: ('q, char) nfa_t) (s: string) : bool =
  if s = "" then if (intersection (e_closure nfa [nfa.q0]) nfa.fs) != [] then true else false
  else accept_help nfa (explode s) [nfa.q0];;

(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  failwith "unimplemented"

let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
  failwith "unimplemented"

let new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  failwith "unimplemented"

let rec nfa_to_dfa_step (nfa: ('q,'s) nfa_t) (dfa: ('q list, 's) nfa_t)
    (work: 'q list list) : ('q list, 's) nfa_t =
  failwith "unimplemented"

let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
  failwith "unimplemented"
