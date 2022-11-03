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
  | (state, trans, next)::rest -> if (state = q && trans = s) then next::(move_help rest q s)  else move_help rest q s;;

let rec move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list = 
  match qs with
  | [] -> []
  | q::rest -> union (move_help nfa.delta q s) (move nfa rest s);;

  let rec ec_help nfa qs a =
    match qs with
    | [] -> a
    | q::rest ->  let qs = (move nfa qs None) in
                  ec_help nfa (diff qs a) (insert_all qs a);;

  let e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
    let states = (move nfa qs None) in
    union qs (ec_help nfa states states);;

let rec in_fs nfa qs = 
  match qs with
  | [] -> false
  | q::rest -> if (elem q nfa.fs) then true else (in_fs nfa rest);;

let rec accept_help nfa cs qs: bool = 
  match cs with
  | [] -> in_fs nfa qs
  | c::rest ->  accept_help nfa rest (e_closure nfa (move nfa qs (Some c)));;

let accept (nfa: ('q, char) nfa_t) (s: string) : bool =
  accept_help nfa (explode s) (e_closure nfa [nfa.q0]);;

(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list = 
  fold_left (fun a x -> (e_closure nfa (move nfa qs x))::a) [] (map (fun x -> Some x) nfa.sigma);;

let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
  fold_left (fun a x -> (qs, x, (e_closure nfa (move nfa qs x)))::a) [] (map (fun x -> Some x) nfa.sigma);;

let new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  if (in_fs nfa qs) then [qs] else [];;

let rec nfa_to_dfa_step nfa dfa marked_qs =
  match marked_qs with
  | [] -> (let final_qs = (fold_left (fun a x -> a @ (new_finals nfa x)) [] dfa.qs) in
            {sigma = dfa.sigma; qs = dfa.qs; q0 = dfa.q0; fs = final_qs; delta = dfa.delta})
  | q::rest -> (let new_qs = (new_states nfa q) in
                let new_marked_qs = if (subset new_qs dfa.qs) then rest else (union new_qs rest) in
                nfa_to_dfa_step nfa
                { sigma = dfa.sigma; 
                  qs = (union dfa.qs new_marked_qs); 
                  q0 = dfa.q0; 
                  fs = dfa.fs; 
                  delta = (union dfa.delta (new_trans nfa q))} new_marked_qs);;

let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
  let r0 = (e_closure nfa [nfa.q0]) in
  nfa_to_dfa_step nfa 
  {sigma = nfa.sigma; qs = [r0]; q0 = r0; fs = (new_finals nfa r0); delta = []}
  [r0];;

