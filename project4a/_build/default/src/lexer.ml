open TokenTypes

(* Part 1: Lexer - IMPLEMENT YOUR CODE BELOW *)

let tokenize input =

  (* regexp declarations *)

  let re_lparen = Str.regexp "(" in
  let re_rparen = Str.regexp ")" in
  let re_equal = Str.regexp "=" in
  let re_noteq = Str.regexp "<>" in
  let re_greater = Str.regexp ">" in
  let re_less = Str.regexp "<" in
  let re_greq = Str.regexp ">=" in
  let re_leeq = Str.regexp "<=" in
  let re_or = Str.regexp "||" in
  let re_and = Str.regexp "&&" in
  let re_not = Str.regexp "not" in
  let re_if = Str.regexp "if" in
  let re_then = Str.regexp "then" in
  let re_else = Str.regexp "else" in
  let re_add = Str.regexp "+" in
  let re_sub = Str.regexp "-" in
  let re_mult = Str.regexp "*" in
  let re_div = Str.regexp "/" in
  let re_concat = Str.regexp "\\^" in
  let re_let = Str.regexp "let" in
  let re_def = Str.regexp "def" in
  let re_in = Str.regexp "in" in
  let re_rec = Str.regexp "rec" in
  let re_fun = Str.regexp "fun" in
  let re_arrow = Str.regexp "->" in
  let re_dubsemi = Str.regexp ";;" in
  let re_int_pos = Str.regexp "[0-9]+" in
  let re_int_neg = Str.regexp "(-[0-9]+)" in
  let re_bool = Str.regexp "true\\|false" in
  let re_string = Str.regexp "\"\\([^\"]*\\)\"" in
  let re_id = Str.regexp "[a-zA-Z][a-zA-Z0-9]*" in
  let re_white = Str.regexp "[ \t\n]+" in
  let re_id_check = Str.regexp "[a-zA-Z0-9]+" in

  (* iterating through the input and creating a list of tokens *)

  let rec mklst pos s = 
    
    (* list complete *)
    if pos >= (String.length s) then 
      [] 
    else
        
      (* ints go first because of syntactic logic *)
      (* positive Tok_Int(int) *)
      if (Str.string_match re_int_pos s pos) then
        let matched = (Str.matched_string s) in
        Tok_Int(int_of_string matched)::(mklst (Str.match_end()) s)

      (* negative Tok_Int(int) *)
      else if (Str.string_match re_int_neg s pos) then
        let matched = (Str.matched_string s) in
        let sub = String.sub matched 1 ((String.length matched) - 2) in
        Tok_Int(int_of_string sub)::(mklst (Str.match_end()) s)

      (* symbols/operators *)

      (* "(" *)
      else if (Str.string_match re_lparen s pos) then 
        Tok_LParen::(mklst (Str.match_end()) s)
      (* ")" *)
      else if (Str.string_match re_rparen s pos) then
        Tok_RParen::(mklst (Str.match_end()) s)
      (* "->" *)
      else if (Str.string_match re_arrow s pos) then
        Tok_Arrow::(mklst (Str.match_end()) s)
      (* "<>" *)
      else if (Str.string_match re_noteq s pos) then
        Tok_NotEqual::(mklst (Str.match_end()) s)
      (* ">=" *)
      else if (Str.string_match re_greq s pos) then
        Tok_GreaterEqual::(mklst (Str.match_end()) s)
      (* ">=" *)
      else if (Str.string_match re_leeq s pos) then
        Tok_LessEqual::(mklst (Str.match_end()) s)
      (* ">" *)
      else if (Str.string_match re_greater s pos) then
        Tok_Greater::(mklst (Str.match_end()) s)
      (* "=" *)
      else if (Str.string_match re_equal s pos) then
        Tok_Equal::(mklst (Str.match_end()) s)
      (* "<" *)
      else if (Str.string_match re_less s pos) then
        Tok_Less::(mklst (Str.match_end()) s)
      (* "||" *)
      else if (Str.string_match re_or s pos) then
        Tok_Or::(mklst (Str.match_end()) s)
      (* "&&" *)
      else if (Str.string_match re_and s pos) then
        Tok_And::(mklst (Str.match_end()) s)
      (* "+" *)
      else if (Str.string_match re_add s pos) then
        Tok_Add::(mklst (Str.match_end()) s)
      (* "-" *)
      else if (Str.string_match re_sub s pos) then
        Tok_Sub::(mklst (Str.match_end()) s)
      (* "*" *)
      else if (Str.string_match re_mult s pos) then
        Tok_Mult::(mklst (Str.match_end()) s)
      (* "/" *)
      else if (Str.string_match re_div s pos) then
        Tok_Div::(mklst (Str.match_end()) s)
      (* "^" *)
      else if (Str.string_match re_concat s pos) then
        Tok_Concat::(mklst (Str.match_end()) s)
      (* ";;" *)
      else if (Str.string_match re_dubsemi s pos) then
        Tok_DoubleSemi::(mklst (Str.match_end()) s)

      (* keywords *)

      (* "not" *)
      else if (Str.string_match re_not s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Not::(mklst end_pos s)
      (* "if" *)
      else if (Str.string_match re_if s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_If::(mklst end_pos s)
      (* "then" *)
      else if (Str.string_match re_then s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Then::(mklst end_pos s)
      (* "else" *)
      else if (Str.string_match re_else s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Else::(mklst end_pos s)
      (* "let" *)
      else if (Str.string_match re_let s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Let::(mklst end_pos s)
      (* "def" *)
      else if (Str.string_match re_def s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Def::(mklst end_pos s)
      (* "in" *)
      else if (Str.string_match re_in s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_In::(mklst end_pos s)
      (* "rec" *)
      else if (Str.string_match re_rec s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Rec::(mklst end_pos s)
      (* "fun" *)
      else if (Str.string_match re_fun s pos) then
        let token = Str.matched_string s in
        let end_pos = (Str.match_end()) in
        if (Str.string_match re_id_check s end_pos) then
          let id = Str.matched_string s in 
          (Tok_ID(token^id))::(mklst (Str.match_end()) s)
        else
          Tok_Fun::(mklst end_pos s)

      (* tokens that capture the input *)

      (* Tok_Bool(bool) *)
      else if (Str.string_match re_bool s pos) then
        let matched = (Str.matched_string s) in
        Tok_Bool(bool_of_string matched)::(mklst (Str.match_end()) s)

      (* Tok_String(string) *)
      else if (Str.string_match re_string s pos) then
        let matched = (Str.matched_string s) in
        let sanitized = (Str.matched_group 1 s) in
        Tok_String(sanitized)::(mklst (pos + (String.length matched)) s)

      (* Tok_ID(id) *)
      else if (Str.string_match re_id s pos) then
        let matched = (Str.matched_string s) in
        Tok_ID(matched)::(mklst (pos + (String.length matched)) s)

      (* Whitespace (' ', \n, \t) *)
      else if (Str.string_match re_white s pos) then
        mklst (Str.match_end()) s
      
      (* Otherwise raise exception *)
      else
        raise (InvalidInputException "Lexing error")

  in mklst 0 input;;