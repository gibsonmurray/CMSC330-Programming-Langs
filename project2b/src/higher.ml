open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let contains_elem lst e = fold (fun a x -> a || x = e) false lst;;

let is_present lst x = map (fun e -> if x = e then 1 else 0) lst;;

let count_occ lst target = failwith "unimplemented"

let uniq lst = failwith "unimplemented"

let assoc_list lst = failwith "unimplemented"

let ap fns args = failwith "unimplemented"
