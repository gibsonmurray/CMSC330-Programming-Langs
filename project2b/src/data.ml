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
  failwith "unimplemented"

let rec map_contains k t = 
  failwith "unimplemented"

let rec map_get k t =
  failwith "unimplemented"

(***************************)
(* Part 4: Variable Lookup *)
(***************************)

(* Modify the next line to your intended type *)
type lookup_table = unit

let empty_table : lookup_table = ()

let push_scope (table : lookup_table) : lookup_table = 
  failwith "unimplemented"

let pop_scope (table : lookup_table) : lookup_table =
  failwith "unimplemented"

let add_var name value (table : lookup_table) : lookup_table =
  failwith "unimplemented"

let rec lookup name (table : lookup_table) =
  failwith "unimplemented"
