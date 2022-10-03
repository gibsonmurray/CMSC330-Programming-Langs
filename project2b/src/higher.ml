open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let contains_elem lst e = 
  if (fold (fun a x -> if e = x then a + 1 else a) 0 lst) > 0
  then true else false;;

let is_present lst x = failwith "unimplemented"

let count_occ lst target = failwith "unimplemented"

let uniq lst = failwith "unimplemented"

let assoc_list lst = failwith "unimplemented"

let ap fns args = failwith "unimplemented"
