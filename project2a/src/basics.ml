(***********************************)
(* Part 1: Non-Recursive Functions *)
(***********************************)

let rev_tup tup = match tup with
  | (a, b, c) -> (c, b, a);;

let is_odd x = if x mod 2 = 1 then true else false;;

let area x y = match x, y with
  | (a, b), (p, q) -> (abs(a-p) * abs(b - q));;

let volume x y = match x, y with
  | (a, b, c), (p, q, r) -> (abs(a - p) * abs(b - q) * abs(c - r));;

(*******************************)
(* Part 2: Recursive Functions *)
(*******************************)

let rec fibonacci n = 
  if n = 0 then 0 else if n = 1 then 1 else fibonacci (n - 1) + fibonacci (n - 2);;

let rec pow x y = if y = 0 then 1 else x * pow x (y - 1);;

let rec log x y = if y = 1 then 0 else 1 + log x (y / x);;

(* Helper Function *)
let rec gcf_aux x y n = 
  if (x mod n) = (y mod n) then n else gcf_aux x y (n - 1);;

let gcf x y =
  if x > y then gcf_aux x y y else gcf_aux x y x;;
  
(* Helper Function *)
let rec is_prime_aux x n = 
  if n = 1 then true else
  if x mod n = 0 then false else is_prime_aux x (n - 1);;

let is_prime x = if x < 0 || x = 1 then false else is_prime_aux x (x - 1);;

(*****************)
(* Part 3: Lists *)
(*****************)

let rec get idx lst =
  match lst with
  | [] -> failwith "Out of bounds"
  | h::rest -> if idx = 0 then h else get (idx - 1) rest;;

let rec larger lst1 lst2 = 
  match lst1, lst2 with
  | [], [] -> []
  | _, [] -> lst1
  | [], _ -> lst2
  | h::t, hh::tt -> if t != [] && tt = [] then lst1 else 
                    if t = [] && tt != [] then lst2 else
                    larger t tt;;

let rec reverse_aux lst rev = 
  match lst with
  | [] -> rev
  | h::t -> reverse_aux t (h::rev);;

let reverse lst = reverse_aux lst [];;

let rec combine lst1 lst2 =
  match lst1, lst2 with
  | [], [] -> []
  | h::t, [] -> lst1
  | [], h::t -> lst2
  | h::t, _ -> h::(combine lst2 t);;

let rec merge lst1 lst2 = 
  match lst1, lst2 with
  | [], [] -> []
  | _, [] -> lst1
  | [], _ -> lst2
  | h::t, m::n -> 
    if h < m 
      then h::(merge t (m::n))
      else m::(merge (h::t) n);;

let rec rotate shift lst = 
  if shift = 0 then lst else
    match lst with
    | [] -> []
    | h::t -> rotate (shift - 1) (t @ [h]);;

let rec is_pal_aux lst rev = 
    match lst, rev with
    | [], [] -> true
    | _, [] -> true
    | [], _ -> true
    | h::t, m::n -> if h = m then is_pal_aux t n else false;;

let is_palindrome lst = is_pal_aux lst (reverse lst);;
