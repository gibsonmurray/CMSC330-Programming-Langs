extern crate stark_suit_repair;

use std::cmp::Ordering;
use std::collections::HashMap;

use stark_suit_repair::basics::{gauss, in_range, subset, mean, to_decimal, factorize, rotate, substr, longest_sequence};
use stark_suit_repair::locator::{PriorityQueue, distance, target_locator};
use stark_suit_repair::communicator::{Command, to_command};

/*
 * Create a new function for each test that you want to run.  Please be sure to add
 * the #[test] attribute to each of your student tests to ensure they are all run, and
 * prefix them all with 'student_' (see example below).
 * Then, run `cargo test student` to run all of the student tests.
 */


 struct Node<T> {
    priority: i32,
    data: T,
}

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

#[test]
fn student_queue() {
    let mut q = Vec::new();

    q.enqueue(5);
    q.enqueue(1);
    q.enqueue(3);
    q.enqueue(4);
    q.enqueue(2);


    assert_eq!(1, q[0]);
    assert_eq!(2, q[1]);
    assert_eq!(3, q[2]);
    assert_eq!(5, q[3]);
    assert_eq!(4, q[4]);


    assert_eq!(Some(&1), q.peek());
    assert_eq!(Some(1), q.dequeue());

    assert_eq!(2, q[0]);
    assert_eq!(4, q[1]);
    assert_eq!(3, q[2]);
    assert_eq!(5, q[3]);

    q.enqueue(0);

    assert_eq!(0, q[0]);
    assert_eq!(2, q[1]);
    assert_eq!(3, q[2]);
    assert_eq!(5, q[3]);
    assert_eq!(4, q[4]);

    q.dequeue();

    assert_eq!(2, q[0]);
    assert_eq!(4, q[1]);
    assert_eq!(3, q[2]);
    assert_eq!(5, q[3]);

    q.enqueue(6);
    q.enqueue(3);
    q.enqueue(5);
    q.enqueue(8);
    q.enqueue(9);
    q.enqueue(1);

    q.dequeue();
    q.dequeue();





}

#[test]
fn student_queue2() {
    let mut q = Vec::new();

    let a = Node{ priority: 1, data: "A"};
    let b = Node{ priority: 1, data: "B"};
    let c = Node{ priority: 0, data: "C"};


    q.enqueue(a);
    q.enqueue(b);
    q.enqueue(c);


    assert_eq!("C", q[0].data);
    assert_eq!("B", q[1].data);
    assert_eq!("A", q[2].data);

}

#[test]
fn student_test_locator() {
    let mut allies = HashMap::new();
    let stark = "Stark".to_string();
    let hulk = "Hulk".to_string();
    let cap = "Cap".to_string();
    allies.insert(&stark, (3 as i32,7 as i32));
    allies.insert(&hulk, (4 as i32,4 as i32));
    allies.insert(&cap, (6 as i32,4 as i32));

    let mut enemies = HashMap::new();
    let thanos = "Thanos".to_string();
    let ebony = "Ebony Maw".to_string();
    let joe = "Joe".to_string();
    enemies.insert(&thanos, (5 as i32,2 as i32));
    enemies.insert(&ebony, (1 as i32,5 as i32));
    enemies.insert(&joe, (7 as i32,2 as i32));


    assert_eq!(("Ebony Maw", 1, 5), target_locator(&allies, &enemies));
}