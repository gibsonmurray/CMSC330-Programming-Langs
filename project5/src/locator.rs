use core::panic;
use std::clone;
use std::cmp::Ordering;
use std::collections::HashMap;
use std::hash::Hash;

pub trait PriorityQueue<T: PartialOrd> {
    fn enqueue(&mut self, ele: T) -> ();
    fn dequeue(&mut self) -> Option<T>;
    fn peek(&self) -> Option<&T>;
    fn enqueue_minheapify(&mut self) -> ();
    fn dequeue_minheapify(&mut self) -> ();
    fn num_of_children (&self, idx: usize) -> usize;
}

/**
    An optional definition of a Node struct you may find useful
**/
#[derive(Debug)]
struct Node<T> {
    priority: i32,
    data: T,
}

/** 
    These traits are implemented for Nodes to make them comparable 
**/
impl<T> PartialOrd for Node<T> {
    fn partial_cmp(&self, other: &Node<T>) -> Option<Ordering> {
        self.priority.partial_cmp(&other.priority)
    }
}

impl<T> PartialEq for Node<T> {
    fn eq(&self, other: &Node<T>) -> bool {
        self.priority == other.priority
    }
}

/** 
    You must implement the above trait for the vector type 
**/
impl<T: PartialOrd> PriorityQueue<T> for Vec<T> {

    /** helper function for enqueue */
    fn enqueue_minheapify(&mut self) -> () {
        let mut i = 1;
        while i < self.len() {
            if self[i] < self[(i - 1) / 2] {
                self.swap(i, (i - 1) / 2);
                i = 1;
            }
            else {
                i += 1;
            }
        }
    }

    fn dequeue_minheapify(&mut self) -> () {
        let mut i = 0;
        let mut childs = self.num_of_children(i);
        while childs > 0 {
            if childs == 1 && self[i] > self[2 * i + 1] {
                self.swap(i, 2 * i + 1);
                i = 2 * i + 1;
            }
            else if self[i] > self[2 * i + 1] && self[i] > self[2 * i + 2]{
                if self[2 * i + 1] < self[2 * i + 2] {
                    self.swap(i, 2 * i + 1);
                    i = 2 * i + 1;
                }
                else {
                    self.swap(i, 2 * i + 2);
                    i = 2 * i + 2;   
                }
            }
            else {
                break;
            }
            childs = self.num_of_children(i);
        }
    }

    fn num_of_children (&self, idx: usize) -> usize {
        let mut ans = 0;
            if (2 * idx + 1) < self.len() {
                ans += 1;
                if (2 * idx + 2) < self.len() {
                    ans += 1;
                }
            }
        ans
    }

    /**
        This functions pushes a given element onto the queue and
        reorders the queue such that the min heap property holds.
        See the project specifications for more details on how this
        works.
    **/
    
    fn enqueue(&mut self, ele: T) -> () {
        self.push(ele);
        self.enqueue_minheapify();
    }

    /**
        This function removes the root element from the queue and
        reorders the queue such that it maintains the min heap
        property.  See the project specifications for more details.
        You should return the deleted element in the form of an option.
        Return None if the queue was initially empty, Some(T) otherwise.
    **/
    fn dequeue(&mut self) -> Option<T> {
        let n = self.len();
        self.swap(0, n - 1);
        let ans = self.pop();
        if self.len() > 0 {
            self.dequeue_minheapify();
        }
        return ans;
    }

    /**
        This function returns the element that would be removed
        if dequeue were called on the queue.  There should be no
        mutations to the queue.  Return the element in the form
        of an option.  Return None if the queue is empty, Some(T)
        otherwise.
    **/
    fn peek(&self) -> Option<&T> {
        if self.len() == 0 {
            None
        }
        else {
            Some(&self[0])
        }
    }
}


/**
    You must implement this function that computes the orthogonal
    distance between two coordinates.  Remember, orthogonal distance
    is not like Euclidean distance.  See the specifications for more
    details.
**/
pub fn distance(p1: (i32,i32), p2: (i32,i32)) -> i32 {
    let (a, b) = p1;
    let (c, d) = p2;
    let x = c - a;
    let y = d - b;
    x.abs() + y.abs()
}

/**
    You must implement this function that determines which enemy Stark
    should battle and their coordinates.  You are given two hashmaps for
    allies and enemies.  Each maps a name to their current coordinates.
    You can assume that the allies hashmap will always have a name
    called "Stark" included.  Return the name and coordinates of the enemy
    Stark will battle in the form of a 3-tuple.  See the specifications
    for more details on how to choose which enemy.
**/
pub fn target_locator<'a>(allies: &'a HashMap<&String, (i32,i32)>, enemies: &'a HashMap<&String, (i32,i32)>) -> (&'a str,i32,i32) {
    let mut stark_q = Vec::new();
    let stark_loc = match allies.get(&String::from("Stark")) {
        Some(x) => x.clone(),
        None => panic!("error: stark_loc was None, expected Some(coordinate)")
    };
    let mut stark_e_loc = (0, 0);
    for (e_key, e_value) in enemies.clone() {
        stark_q.enqueue(Node{ priority: distance(stark_loc, e_value), data: (e_key, e_value) });
        stark_e_loc = e_value;
    }
    for (a_key, a_value) in allies.clone() {
        let root = match stark_q.peek() {
            Some(x) => x.clone(),
            None => panic!("error: root was None, expected Some(Node)")
        };
        if (a_key.eq(&String::from("Stark"))) && (distance(a_value, stark_e_loc) < root.priority) {
            stark_q.dequeue();
            match stark_q.peek() {
                Some(x) => match x.data {
                    (_, pos) => stark_e_loc = pos
                },
                None => panic!("error: root was None, expected returning Node")
            }
        }
    }
    match stark_q.peek() {
        Some(x) => match x.data {
            (name, (x, y)) => (name, x, y)
        },
        None => panic!("error: rootwas None, expected returning Node")
    }
}


