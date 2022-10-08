open Funs

(*************************************)
(* Part 2: Three-Way Search Tree *)
(*************************************)

type int_tree =
  | IntLeaf
  | IntNode of int * int option * int_tree * int_tree * int_tree 

let empty_int_tree = IntLeaf

let rec int_insert x t =
  match t with
  (* Case 1: Empty Tree *)
  | IntLeaf -> IntNode(x, None, IntLeaf, IntLeaf, IntLeaf)
  (* Case 2: only left int is filled *)
  | IntNode(lv, None, left, middle, right) ->
    if x < lv then IntNode(x, Some lv, left, middle, right) else
      if x > lv then IntNode(lv, Some x, left, middle, right) else
        IntNode(lv, None, left, middle, right)
  (* Case 3: both ints are filled *)
  | IntNode(lv, Some rv, left, middle, right) ->
    if x < lv then IntNode(lv, Some rv, int_insert x left, middle, right) else
      if x > rv then IntNode(lv, Some rv, left, middle, int_insert x right) else
        if x > lv && x < rv then IntNode(lv, Some rv, left, int_insert x middle, right) else
          IntNode(lv, Some rv, left, middle, right);;

let rec int_mem x t =
  match t with
  | IntLeaf -> false
  | IntNode(lv, None, left, middle, right) -> if x = lv then true else false
  | IntNode(lv, Some rv, left, middle, right) -> 
    if x = lv || x = rv then true else 
      if x < lv then int_mem x left else
        if x > rv then int_mem x right else
          int_mem x middle;;

let rec int_size t =
  match t with
  | IntLeaf -> 0
  | IntNode(lv, None, left, middle, right) -> 1
  | IntNode(lv, Some rv, left, middle, right) -> 2 + int_size left + int_size middle + int_size right;;

let rec int_max t =
  match t with
  | IntLeaf -> 0
  | IntNode(lv, None, left, middle, right) -> lv
  | IntNode(lv, Some rv, left, middle, right) -> 
    if right = IntLeaf then rv else int_max right;;

(*******************************)
(* Part 3: Three-Way Search Tree-Based Map *)
(*******************************)

type 'a tree_map =
  | MapLeaf
  | MapNode of (int * 'a) * (int * 'a) option * 'a tree_map * 'a tree_map * 'a tree_map

let empty_tree_map = MapLeaf

let rec map_put k v t = 
  match t with
  (* Case 1: Empty Map *)
  | MapLeaf -> MapNode((k, v), None, MapLeaf, MapLeaf, MapLeaf)
  (* Case 2: only left node is filled *)
  | MapNode((kl, vl), None, left, middle, right) ->
    if k < kl then MapNode((k, v), Some (kl, vl), left, middle, right) else
      if k > kl then MapNode((kl, vl), Some (k, v), left, middle, right) else
        raise(Invalid_argument("map_put"))
  (* Case 3: both nodes are filled *)
  | MapNode((kl, vl), Some (kr, vr), left, middle, right) ->
    if k < kl then MapNode((kl, vl), Some (kr, vr), map_put k v left, middle, right) else
      if k > kr then MapNode((kl, vr), Some (kr, vr), left, middle, map_put k v right) else
        if k > kl && k < kr then MapNode((kl, vl), Some (kr, vr), left, map_put k v middle, right) else
          raise(Invalid_argument("map_put"));;

let rec map_contains k t = 
  match t with
  | MapLeaf -> false
  | MapNode((kl, vl), None, left, middle, right) -> if k == kl then true else false
  | MapNode((kl, vl), Some (kr, vr), left, middle, right) ->
    if k == kl || k == kr then true else
      if k < kl then map_contains k left else
        if k > kr then map_contains k right else
          map_contains k middle;;

let rec map_get k t =
  match t with
  | MapLeaf -> raise(Invalid_argument("map_get"))
  | MapNode((kl, vl), None, left, middle, right) -> if k == kl then vl else raise(Invalid_argument("map_get"))
  | MapNode((kl, vl), Some (kr, vr), left, middle, right) ->
    if k == kl then vl else
      if k == kr then vr else
        if k < kl then map_get k left else
          if k > kr then map_get k right else
            map_get k middle;;

(***************************)
(* Part 4: Variable Lookup *)
(***************************)

(* Modify the next line to your intended type *)
type variable = { k:string; v:int; }

type lookup_table = 
| Empty
| Scope of variable list * lookup_table

let empty_table : lookup_table = Empty

let rec push_scope (table : lookup_table) : lookup_table = 
  match table with
  | Empty -> Scope([], Empty)
  | Scope(vars, inner) -> Scope(vars, push_scope inner);;

let rec pop_scope (table : lookup_table) : lookup_table =
  match table with
  | Empty -> failwith "No scopes remain!"
  | Scope(vars, inner) -> if inner = empty_table then empty_table else pop_scope inner;;

let rec add_help name value vars = 
  match vars with
  | [] -> {k=name; v=value}
  | h::t -> if h.k = name
            then failwith "Duplicate variable binding in scope!" 
            else add_help name value t;;

let add_var name value (table : lookup_table) : lookup_table =
  match table with
  | Empty -> failwith "There are no scopes to add a variable to!"
  | Scope(vars, inner) -> Scope((add_help name value vars)::vars, inner);;

let rec lookup_help name vars = 
  match vars with
  | [] -> failwith "Variable not found!"
  | h::t -> if h.k = name then h.v else lookup_help name t;;

let lookup name (table : lookup_table) =
  match table with
  | Empty -> failwith "Variable not found!"
  | Scope(vars, inner) -> lookup_help name vars;;
