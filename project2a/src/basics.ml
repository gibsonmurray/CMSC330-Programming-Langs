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

let rec fibonacci n = failwith "unimplemented"

let rec pow x y = failwith "unimplemented"

let rec log x y = failwith "unimplemented"

let rec gcf x y = failwith "unimplemented"

let rec is_prime x = failwith "unimplemented"

(*****************)
(* Part 3: Lists *)
(*****************)

let rec get idx lst = failwith "unimplemented"

let larger lst1 lst2 = failwith "unimplemented"

let reverse lst = failwith "unimplemented"

let rec combine lst1 lst2 = failwith "unimplemented"

let rec merge lst1 lst2 = failwith "unimplemented"

let rec rotate shift lst = failwith "unimplemented"

let rec is_palindrome lst = failwith "unimplemented"