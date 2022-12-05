use std::cmp::Ordering;
use std::collections::HashMap;

pub trait PriorityQueue<T: PartialOrd> {
    fn enqueue(&mut self, ele: T) -> ();
    fn dequeue(&mut self) -> Option<T>;
    fn peek(&self) -> Option<&T>;
    fn minheapify(&mut self) -> ();
}

/**
    An optional definition of a Node struct you may find useful
**/
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

    /** helper function to turn binary tree into a minheap */
    fn minheapify(&mut self) -> () {
        for i in 1..self.len() {
            if self[i] < self[(i - 1) / 2] {
                let mut j = i;
                while self[j] < self[(j - 1) / 2] {
                    self.swap(j, (j - 1) / 2);
                }
                j = (j - 1) / 2;
            }
        }
    }


    /**
        This functions pushes a given element onto the queue and
        reorders the queue such that the min heap property holds.
        See the project specifications for more details on how this
        works.
    **/
    
    fn enqueue(&mut self, ele: T) -> () {
        self.push(ele);
        self.minheapify();
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
            self.minheapify();
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
    unimplemented!()
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
    unimplemented!()
}


