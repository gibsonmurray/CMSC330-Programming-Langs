/**
    Returns the sum 1 + 2 + ... + n
    If n is less than 0, return -1
**/
pub fn gauss(n: i32) -> i32 {
    if n < 0 {
        -1
    }
    else {
        let mut x = 0;
        for i in 1..(n + 1) {
            x += i;
        }
        x
    }
}

/**
    Returns the number of elements in the list that 
    are in the range [s,e]
**/
pub fn in_range(ls: &[i32], s: i32, e: i32) -> i32 {
    let mut ans = 0;
    for &i in ls.iter() {
        if i >= s && i <= e {
            ans += 1;
        }
    }
    ans
}

/**
    Returns true if target is a subset of set, false otherwise

    Ex: [1,3,2] is a subset of [1,2,3,4,5]
**/
pub fn subset<T: PartialEq>(set: &[T], target: &[T]) -> bool {
    for i in target.iter() {
        let mut flag = false;
        for j in set.iter() {
            if &i == &j {
                flag = true;
            }
        }
        if !flag {
            return flag;
        }
    }
    return true;
}

/**
    Returns the mean of elements in ls. If the list is empty, return None
    It might be helpful to use the fold method of the Iterator trait
**/
pub fn mean(ls: &[f64]) -> Option<f64> {
    let avg = 
    if ls.is_empty() {
        None
    }
    else {
        let mut sum = 0.0;
        for &i in ls.iter() {
            sum += i;
        }
        Some (sum/(ls.len() as f64))
    };
    avg
}

/**
    Converts a binary number to decimal, where each bit is stored in order in the array
    
    Ex: to_decimal of [1,0,1,0] returns 10
**/
pub fn to_decimal(ls: &[i32]) -> i32 {
    let mut ans = 0;
    let mut power = (ls.len() as i32) - 1;
    let mut i = 0;
    while power >= 0 {
        if ls[i] == 1 {
            ans += 2_i32.pow(power as u32);
        }
        power -= 1;
        i += 1;
    }
    ans
}

/**
    Decomposes an integer into its prime factors and returns them in a vector
    You can assume factorize will never be passed anything less than 2

    Ex: factorize of 36 should return [2,2,3,3] since 36 = 2 * 2 * 3 * 3
**/
pub fn factorize(n: u32) -> Vec<u32> {
    let mut x = n;
    let mut vec = vec![];
    while x % 2 == 0 {
        vec.push(2);
        x /= 2;
    }
    for i in 3..(x as f64).sqrt() as u32 + 1 {
        while x % i == 0 {
            vec.push(i);
            x /= i;
        }
    }
    if x > 2 {
        vec.push(x);
    }
    vec
}

/** 
    Takes all of the elements of the given slice and creates a new vector.
    The new vector takes all the elements of the original and rotates them, 
    so the first becomes the last, the second becomes first, and so on.
    
    EX: rotate [1,2,3,4] returns [2,3,4,1]
**/
pub fn rotate(lst: &[i32]) -> Vec<i32> {
    let mut ans = vec![];
    for i in 0..lst.len() {
        ans.push(lst[(i + 1) % lst.len()]);
    }
    ans
}

/**
    Returns true if target is a subtring of s, false otherwise
    You should not use the contains function of the string library in your implementation
    
    Ex: "ace" is a substring of "rustacean"
**/
pub fn substr(s: &String, target: &str) -> bool {
    let s_len = s.len();
    let target_len = target.len();
    if target_len == 0 {
        return true;
    }
    if s_len < target_len {
        return false;
    }
    for i in 0..(s_len - target_len + 1) {
        if s[i..i+target_len].eq(target) {
            return true;
        }
    }
    false
}

/**
    Takes a string and returns the first longest substring of consecutive equal characters

    EX: longest_sequence of "ababbba" is Some("bbb")
    EX: longest_sequence of "aaabbb" is Some("aaa")
    EX: longest_sequence of "xyz" is Some("x")
    EX: longest_sequence of "" is None
**/
pub fn longest_sequence(s: &str) -> Option<&str> {
    if s == "" {
        return None;
    }
    let mut starts = vec![];
    let mut curr = &s[0..1];
    starts.push(0);
    for i in 1..s.len() {
        if &s[i..(i + 1)] != curr {
            starts.push(i);
            curr = &s[i..(i + 1)];
        }
    }
    let mut max_diff = 0;
    let mut x = 0;
    let mut y = 0;
    for i in 0..(starts.len() - 1) {
        let length = starts[i + 1] - starts[i];
        if length > max_diff {
            max_diff = length;
            x = starts[i];
            y = starts[i + 1];
        }
    }
    Some(&s[x..y])

}
