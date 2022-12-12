use core::panic;
use std::{clone, vec};
use std::cmp::Ordering;
use std::collections::{HashMap, HashSet};
use std::hash::Hash;

pub trait PriorityQueue<T: PartialOrd> {
    fn enqueue(&mut self, ele: T) -> ();
    fn dequeue(&mut self) -> Option<T>;
    fn peek(&self) -> Option<&T>;
    fn sift_up(&mut self, idx: usize) -> ();
    fn sift_down(&mut self, idx: usize);
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

    /**
        This functions pushes a given element onto the queue and
        reorders the queue such that the min heap property holds.
        See the project specifications for more details on how this
        works.
    **/
    fn enqueue(&mut self, ele: T) -> () {
        self.push(ele);
        let idx = self.len() - 1;
        self.sift_up(idx);
    }

    // This method will move a value up the heap until it is in the correct position
    fn sift_up(&mut self, idx: usize) {
        if idx == 0 {
            return;
        }
        let p_idx = (idx - 1) / 2;
        if self[idx] < self[p_idx] {
            self.swap(idx, p_idx);
            self.sift_up(p_idx);
        }
    }

    /**
        This function removes the root element from the queue and
        reorders the queue such that it maintains the min heap
        property.  See the project specifications for more details.
        You should return the deleted element in the form of an option.
        Return None if the queue was initially empty, Some(T) otherwise.
    **/
    fn dequeue(&mut self) -> Option<T> {
        if self.is_empty() {
            return None;
        }
        let size = self.len();
        self.swap(0, size - 1);
        let ans = self.pop();
        self.sift_down(0);
        return ans;
    }

    // This method moves an element down until it is in its proper position
    fn sift_down(&mut self, idx: usize) {
        let left_child = 2 * idx + 1;
        let right_child = 2 * idx + 2;
        if left_child >= self.len() {
            return;
        }
        let mut min_child = left_child;
        if right_child < self.len() && self[right_child] < self[left_child] {
            min_child = right_child;
        }
        if self[idx] > self[min_child] {
            self.swap(idx, min_child);
            self.sift_down(min_child);
        }
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
    let mut heap = vec![];
    for (a_name, a_loc) in allies {
        for (e_name, e_loc) in enemies {
            let dist = distance(a_loc.clone(), e_loc.clone());
            heap.enqueue(Node{ priority: dist, data: (a_name, e_name) });
        }
    }
    let mut allies_seen = HashSet::new();
    let mut enemies_seen = HashSet::new();
    let mut allies_and_enemies = HashMap::new();
    while heap.len() > 0 {
        let names = heap.dequeue().unwrap().data;
        let ally = *names.0;
        let enemy = *names.1;
        if !allies_seen.contains(ally) && !enemies_seen.contains(enemy) {
            allies_seen.insert(ally);
            enemies_seen.insert(enemy);
            allies_and_enemies.insert(ally, enemy);
        }
    }
    match allies_and_enemies.get(&String::from("Stark")) {
        Some(enemy) => { let (x, y) = enemies.get(enemy).unwrap(); (*enemy, *x, *y) }
        None => panic!("error: Stark does not have a matched enemy")
    }
}
