open MicroCamlTypes
open Utils
open TokenTypes

(* Provided functions - DO NOT MODIFY *)

(* Matches the next token in the list, throwing an error if it doesn't match the given token *)
let match_token (toks: token list) (tok: token) =
  match toks with
  | [] -> raise (InvalidInputException(string_of_token tok))
  | h::t when h = tok -> t
  | h::_ -> raise (InvalidInputException(
      Printf.sprintf "Expected %s from input %s, got %s"
        (string_of_token tok)
        (string_of_list string_of_token toks)
        (string_of_token h)))

(* Matches a sequence of tokens given as the second list in the order in which they appear, throwing an error if they don't match *)
let match_many (toks: token list) (to_match: token list) =
  List.fold_left match_token toks to_match

(* Return the next token in the token list as an option *)
let lookahead (toks: token list) = 
  match toks with
  | [] -> None
  | h::t -> Some h

(* Return the token at the nth index in the token list as an option*)
let rec lookahead_many (toks: token list) (n: int) = 
  match toks, n with
  | h::_, 0 -> Some h
  | _::t, n when n > 0 -> lookahead_many t (n-1)
  | _ -> None

(* Part 2: Parsing expressions *)

let rec parse_expr toks : (token list * expr) =
  match toks with
  | Tok_Let::t -> parse_let t
  | Tok_If::t -> parse_if t
  | Tok_Fun::t -> parse_fun t
  | _  -> parse_or toks

and parse_let toks = 
  let (ts1, is_rec) = (parse_rec toks) in
  let (ts2, v1) = (parse_primary ts1) in
  let ts_post_eq = (match_token ts2 Tok_Equal) in
  let (ts3, e1) = (parse_expr ts_post_eq) in
  let ts_post_in = (match_token ts3 Tok_In) in
  let (ts4, e2) = (parse_expr ts_post_in) in
  let value = (match v1 with
              | ID(x) -> x
              | _ -> raise (InvalidInputException("Parsing Error: invalid token, should be ID")))
  in
  (ts4, Let(value, is_rec, e1, e2))

and parse_rec toks = 
  match toks with
  | Tok_Rec::t -> (t, true)
  | _ -> (toks, false)

and parse_if toks =
  let (ts1, e1) = (parse_expr toks) in
  let ts_post_e1 = (match_token ts1 Tok_Then) in
  let (ts2, e2) = (parse_expr ts_post_e1) in
  let ts_post_e2 = (match_token ts2 Tok_Else) in
  let (ts3, e3) = (parse_expr ts_post_e2) in
  (ts3, If(e1, e2, e3))

and parse_fun toks = 
  let (ts1, v1) = 
    (match toks with
    | Tok_ID(id)::t -> (t, id)
    | _ -> raise (InvalidInputException("Parsing Error: missing 'tok_id' token")))
  in
  let ts2 = (match_token ts1 Tok_Arrow) in
  let (ts3, e1) = (parse_expr ts2) in
  (ts3, Fun(v1, e1))

and parse_or toks = 
  let (ts1, e1) = (parse_and toks) in
  match ts1 with
  | Tok_Or::t -> let (ts2, e2) = (parse_or t) in (ts2, Binop(Or, e1, e2))
  | _ -> (ts1, e1)

and parse_and toks = 
  let (ts1, e1) = (parse_eq toks) in
  match ts1 with
  | Tok_And::t -> let (ts2, e2) = (parse_and t) in (ts2, Binop(And, e1, e2))
  | _ -> (ts1, e1)

and parse_eq toks = 
  let (ts1, e1) = (parse_rel toks) in
  match ts1 with
  | Tok_Equal::t -> let (ts2, e2) = (parse_eq t) in (ts2, Binop(Equal, e1, e2))
  | Tok_NotEqual::t -> let (ts2, e2) = (parse_eq t) in (ts2, Binop(NotEqual, e1, e2))
  | _ -> (ts1, e1)

and parse_rel toks = 
  let (ts1, e1) = (parse_add toks) in
  match ts1 with
  | Tok_Less::t -> let (ts2, e2) = (parse_rel t) in (ts2, Binop(Less, e1, e2))
  | Tok_Greater::t -> let (ts2, e2) = (parse_rel t) in (ts2, Binop(Greater, e1, e2))
  | Tok_LessEqual::t -> let (ts2, e2) = (parse_rel t) in (ts2, Binop(LessEqual, e1, e2))
  | Tok_GreaterEqual::t -> let (ts2, e2) = (parse_rel t) in (ts2, Binop(GreaterEqual, e1, e2))
  | _ -> (ts1, e1)

and parse_add toks = 
  let (ts1, e1) = (parse_mult toks) in
  match ts1 with
  | Tok_Add::t -> let (ts2, e2) = (parse_add t) in (ts2, Binop(Add, e1, e2))
  | Tok_Sub::t -> let (ts2, e2) = (parse_add t) in (ts2, Binop(Sub, e1, e2))
  | _ -> (ts1, e1)

and parse_mult toks = 
  let (ts1, e1) = (parse_concat toks) in
  match ts1 with
  | Tok_Mult::t -> let (ts2, e2) = (parse_mult t) in (ts2, Binop(Mult, e1, e2))
  | Tok_Div::t -> let (ts2, e2) = (parse_mult t) in (ts2, Binop(Div, e1, e2))
  | _ -> (ts1, e1)

and parse_concat toks = 
  let (ts1, e1) = (parse_unary toks) in
  match ts1 with
  | Tok_Concat::t -> let (ts2, e2) = (parse_concat t) in (ts2, Binop(Concat, e1, e2))
  | _ -> (ts1, e1)

and parse_unary toks = 
  match toks with
  | Tok_Not::t -> let (ts1, e1) = (parse_unary t) in (ts1, Not(e1))
  | _ -> (parse_fcall toks)

and parse_fcall toks = 
  let (ts1, e1) = (parse_primary toks) in
  let is_call = 
    match (lookahead ts1) with
    | (Some Tok_Int(v)) -> true
    | (Some (Tok_Bool(v))) -> true
    | (Some (Tok_String(v))) -> true
    | (Some Tok_ID(v)) -> true
    | (Some Tok_LParen) -> true
    | _ -> false
  in
  if (not is_call) then 
    (ts1, e1) 
  else
    (let (ts2, e2) = (parse_primary ts1) in
    (ts2, FunctionCall(e1, e2)))

and parse_primary toks = 
  match toks with
  | Tok_Int(v)::t -> (t, Value(Int(v)))
  | Tok_Bool(v)::t -> (t, Value(Bool(v)))
  | Tok_String(v)::t -> (t, Value(String(v)))
  | Tok_ID(v)::t -> (t, ID(v))
  | Tok_LParen::t ->  let (ts1, e1) = (parse_expr t) in
                      (match ts1 with
                      | Tok_RParen::t -> (t, e1)
                      | _ -> raise (InvalidInputException("Parse Error: no right parenthesis")))
  | _ -> raise (InvalidInputException("Parse Error: invalid input"))
;;

(* Part 3: Parsing mutop *)

let rec parse_mutop toks = 
  match toks with
  | Tok_Def::t -> (parse_def t)
  | Tok_DoubleSemi::t -> (t, NoOp)
  | _ -> (parse_mexpr toks)

and parse_def toks = 
  let (ts1, v1) =
  (match toks with
  | Tok_ID(v)::t -> (t, ID(v))
  | _ -> raise (InvalidInputException("Mutop Error: invalid id")))
  in
  let ts2 = (match_token ts1 Tok_Equal) in
  let (ts3, e1) = (parse_expr ts2) in
  let ts4 = (match_token ts3 Tok_DoubleSemi) in
  let value = (match v1 with
              | ID(x) -> x
              | _ -> raise (InvalidInputException("Mutop Error: invalid token, should be ID")))
  in
  (ts4, Def(value, e1))

and parse_mexpr toks = 
  let (ts1, e1) = (parse_expr toks) in
  let ts2 = (match_token ts1 Tok_DoubleSemi) in
  (ts2, Expr(e1))
;;