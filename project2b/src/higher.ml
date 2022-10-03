open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let contains_elem lst e =
  fold (fun a x -> a || x = e) false lst;;

let is_present lst x =
  map (fun e -> if x = e then 1 else 0) lst;;

let count_occ lst target = 
  fold (fun a x -> if x = target then a + 1 else a) 0 lst;;

let uniq lst = 
  fold (fun a x -> if contains_elem a x then a else x :: a) [] lst;;

let assoc_list lst =
  fold (fun a x -> (x, (count_occ lst x)) :: a) [] (uniq lst);; 

let ap fns args = 
  fold (fun a x -> a @ (map x args)) [] fns;;
