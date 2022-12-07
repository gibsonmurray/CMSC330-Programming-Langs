use std::fmt::format;

#[derive(Debug)]
#[derive(PartialEq)]
pub enum Command
{
    Power(bool,i32),    // [Increase/Decrease] power by [number].
    Missiles(bool,i32), // [Increase/Decrease] missiles by [number].
    Shield(bool),       // Turn [On/Off] the shield.
    Try,                // Try calling pepper.
    Invalid             // [anything else]
}


/**
    Adds functionality to Command enums
    Commands can be converted to strings with the as_str method
    
    Command     |     String format
    ---------------------------------------------------------
    Power       |  /Power (increased|decreased) by [0-9]+%/
    Missiles    |  /Missiles (increased|decreased) by [0-9]+/
    Shield      |  /Shield turned (on|off)/
    Try         |  /Call attempt failed/
    Invalid     |  /Not a command/
**/
impl Command {
    pub fn as_str (&self) -> String {
        match self {
            Self::Power(b, i) =>
                format!("Power {} by {}%", (if *b {"increased"} else {"decreased"}), i),
            Self::Missiles(b, i ) =>
                format!("Missiles {} by {}", (if *b {"increased"} else {"decreased"}), i),
            Self::Shield(b) =>
                format!("Shield turned {}", (if *b {"on"} else {"off"})),
            Self::Try =>
                format!("Call attempt failed"),
            Self::Invalid =>
                format!("Not a command")
        }
    }
}

/**
    Complete this method that converts a string to a command 
    We list the format of the input strings below

    Command     |     String format
    ---------------------------------------------
    Power       |  /power (inc|dec) [0-9]+/
    Missiles    |  /(fire|add) [0-9]+ missiles/
    Shield      |  /shield (on|off)/
    Try         |  /try calling Miss Potts/
    Invalid     |  Anything else
**/
pub fn to_command(s: &str) -> Command {
    let vec: Vec<&str> = s.split_whitespace().collect();
    match vec.len() {
        3 => match vec[0] {
                "power" => match vec[1] {
                    "inc" => match vec[2].parse::<i32>() {
                        Ok(val) => Command::Power(true, val),
                        Err(_e) => Command::Invalid
                    }
                    "dec" => match vec[2].parse::<i32>() {
                        Ok(val) => Command::Power(false, val),
                        Err(_e) => Command::Invalid
                    },
                    _ => Command::Invalid
                }
                _ => match vec[2] {
                    "missiles" => match vec[0] {
                        "add" => match vec[1].parse::<i32>() {
                            Ok(val) => Command::Missiles(true, val),
                            Err(_e) => Command::Invalid
                        },
                        "fire" => match vec[1].parse::<i32>() {
                            Ok(val) => Command::Missiles(false, val),
                            Err(_e) => Command::Invalid
                        },
                        _ => Command::Invalid
                    },
                    _ => Command::Invalid
                }
            }
        2 => match vec[0] {
            "shield" => match vec[1] {
                "on" => Command::Shield(true),
                "off" => Command::Shield(false),
                _ => Command::Invalid
            },
            _ => Command::Invalid
        }
        4 => match vec[0] {
            "try" => match vec[1] {
                "calling" => match vec[2] {
                    "Miss" => match vec[3] {
                        "Potts" => Command::Try,
                        _ => Command::Invalid
                    },
                    _ => Command::Invalid
                },
                _ => Command::Invalid
            },
            _ => Command::Invalid
        }
        _ => Command::Invalid
    }
}
