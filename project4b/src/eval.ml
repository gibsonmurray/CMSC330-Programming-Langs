open MicroCamlTypes
open Utils

exception TypeError of string
exception DeclareError of string
exception DivByZeroError 

(* Provided functions - DO NOT MODIFY *)

(* Adds mapping [x:v] to environment [env] *)
let extend env x v = (x, ref v)::env

(* Returns [v] if [x:v] is a mapping in [env]; uses the
   most recent if multiple mappings for [x] are present *)
let rec lookup env x =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value)::t -> if x = var then !value else lookup t x

(* Creates a placeholder mapping for [x] in [env]; needed
   for handling recursive definitions *)
let extend_tmp env x = (x, ref (Int 0))::env

(* Updates the (most recent) mapping in [env] for [x] to [v] *)
let rec update env x v =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value)::t -> if x = var then (value := v) else update t x v

(* checks to see if v is an int then either returns the int value or fails *)
let is_int v = 
  match v with
  | Int(x) -> x
  | _ -> (raise (TypeError "Expected type int"))
;;

(* checks to see if v is a string then either, returns the string value or fails *)
let is_str v = 
  match v with
  | String(x) -> x
  | _ -> (raise (TypeError "Expected type string"))
;;

(* checks to see if v is a boolean then either, returns the boolean value or fails *)
let is_bool v = 
  match v with
  | Bool(x) -> x
  | _ -> (raise (TypeError "Expected type bool"))
;;

(* checks to see if v1 and v2 are the same type, returns true if so, false otherwise *)
let is_same v1 v2 = 
  match v1 with
  | Int(x) -> (match v2 with
              | Int(y) -> true
              | _ -> false)
  | String(x) ->  (match v2 with
                  | String(y) -> true
                  | _ -> false)
  | Bool(x) ->  (match v2 with
                | Bool(y) -> true
                | _ -> false)
  | _ -> (raise (TypeError "Cannot compare types"))
;;

let rec contains env x = 
  match env with
  | [] -> false
  | (id, v)::t -> if id = x then true else (contains t x)
;;
        
(* Part 1: Evaluating expressions *)

(* Evaluates MicroCaml expression [e] in environment [env],
   returning a value, or throwing an exception on error *)
let rec eval_expr env e = 
  match e with

  | Value(x) -> x

  | ID(x) -> (lookup env x)

  | Not(x) -> (let v = (eval_expr env x) in
              match v with
              | Bool(b) -> (Bool(not b))
              | _ -> (raise (TypeError "Expected type bool")))

  | Binop(o, x1, x2) -> (let v1 = (eval_expr env x1) in
                        let v2 = (eval_expr env x2) in
                        match o with
                        | Add -> Int((is_int v1) + (is_int v2))
                        | Sub -> Int((is_int v1) - (is_int v2))
                        | Mult -> Int((is_int v1) * (is_int v2))
                        | Div ->  (let z = (is_int v2) in
                                  if z = 0 then 
                                  raise (DivByZeroError) 
                                  else
                                  Int((is_int v1) / z))
                        | Greater -> (Bool((is_int v1) > (is_int v2)))
                        | Less -> (Bool((is_int v1) < (is_int v2)))
                        | GreaterEqual -> (Bool((is_int v1) >= (is_int v2)))
                        | LessEqual -> (Bool((is_int v1) <= (is_int v2)))
                        | Concat -> (String((is_str v1)^(is_str v2)))
                        | Equal ->  (if (is_same v1 v2) then 
                                    (Bool (v1 = v2))
                                    else 
                                    (raise (TypeError "Cannot compare types")))
                        | NotEqual ->   (if (is_same v1 v2) then 
                                        (Bool (v1 != v2))
                                        else 
                                        (raise (TypeError "Cannot compare types")))
                        | Or -> (Bool((is_bool v1) || (is_bool v2)))
                        | And -> (Bool((is_bool v1) && (is_bool v2))))

  | If(x1, x2, x3) -> (let guard = (is_bool (eval_expr env x1)) in
                      let t_branch = (eval_expr env x2) in
                      let f_branch = (eval_expr env x3) in
                      if guard then t_branch else f_branch)

  | Let(id, r, x1, x2) -> (let v = (if r then
                                    (let rec_env = (extend_tmp env id) in
                                    (eval_expr rec_env x1))
                                  else
                                    (eval_expr env x1))
                          in
                          let new_env = (extend env id v) in
                          (eval_expr new_env x2))

  | Fun(param, x1) -> (Closure(env, param, x1))

  | FunctionCall(x1, x2) -> let c = (eval_expr env x1) in
                            match c with
                            | Closure(a, param, e) -> let v = (eval_expr env x2) in
                                                      let new_env = (extend a param v) in
                                                      (eval_expr new_env e)
                            | _ -> (raise (TypeError "Not a function"))
;;

(* Part 2: Evaluating mutop directive *)

(* Evaluates MicroCaml mutop directive [m] in environment [env],
   returning a possibly updated environment paired with
   a value option; throws an exception on error *)
let eval_mutop env m = failwith "unimplemented"