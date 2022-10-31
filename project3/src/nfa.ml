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

let rec move_help (delta: ('q, 's) transition list) (q: 'q) (s: 's option) : 'q list =
  match delta with
  | [] -> []
  | (state, trans, next)::rest -> if (state = q && trans = s) then [next] else move_help rest q s;;

let rec move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list = 
  match qs with
  | [] -> []
  | q::rest -> union (move_help nfa.delta q s) (move nfa rest s);;

let rec ec_help (delta: ('q, 's) transition list) (q: 'q) : 'q list =
  match delta with
  | [] -> [q]
  | (state, trans, next)::rest -> if (state = q && trans = None) then state::(ec_help delta next) else ec_help rest q;;

let rec e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
  match qs with
  | [] -> []
  | q::rest -> union (ec_help nfa.delta q) (e_closure nfa rest);;

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
  fold_left (fun a x -> (e_closure nfa (move nfa qs x))::a) [] (map (fun x -> Some x) nfa.sigma);;

let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
  fold_left (fun a x -> (qs, x, (e_closure nfa (move nfa qs x)))::a) [] (map (fun x -> Some x) nfa.sigma);;

let new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  fold_left (fun a x -> if elem x nfa.fs then [qs] else a) [] qs;;

let rec nfa_to_dfa_step (nfa: ('q,'s) nfa_t) (dfa: ('q list, 's) nfa_t) (* TODO: change the prototype *)
    (partial: 'q list list) (full: 'q list list): ('q list, 's) nfa_t =
  match (diff full partial) with
  | [] -> dfa
  | q::rest -> (let full = (union full (new_states nfa q)) in
                (nfa_to_dfa_step nfa { sigma = dfa.sigma;
                                        qs = full;
                                        q0 = dfa.q0;
                                        fs = [];
                                        delta = (union (new_trans nfa q) dfa.delta)
                                      } (q::partial) full))

let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
  (let dfa = (nfa_to_dfa_step nfa {sigma = nfa.sigma; qs = []; q0 = [nfa.q0]; fs = []; delta = []} [] [e_closure nfa [nfa.q0]]) in
    (match dfa with 
    { sigma = sigmuh;
      qs = qss;
      q0 = initial;
      fs = finals;
      delta = trans
    } -> {sigma = sigmuh; qs = qss; q0 = initial; fs = (intersection (new_finals nfa initial) [nfa.fs]); delta = trans}));; 
                        (* TODO: may not need intersection ^ above *)
