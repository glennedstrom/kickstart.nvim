use std::io::{self, BufRead, BufWriter, Write};

/*
* URL:     $(URL)
* Date:    $(DATE)
* Contest: $(CONTEST):
* Problem: $(PROBLEM)
* Limits:  $(TIMELIM)ms, $(MEMLIM)MB
*/

fn solve(scan: &mut Scanner<impl BufRead>, out: &mut impl Write) {
    // TODO:
}

fn main() {
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut scan = Scanner::new(stdin.lock());
    let mut out = BufWriter::new(stdout.lock());

    let t: usize = scan.next();
    for _ in 0..t {
        solve(&mut scan, &mut out);
    }
}

struct Scanner<R> {
    reader: R,
    buf: Vec<String>,
}

impl<R: BufRead> Scanner<R> {
    fn new(reader: R) -> Self {
        Scanner { reader, buf: Vec::new() }
    }

    fn next<T: std::str::FromStr>(&mut self) -> T {
        loop {
            if let Some(token) = self.buf.pop() {
                return token.parse().ok().unwrap();
            }
            let mut line = String::new();
            self.reader.read_line(&mut line).unwrap();
            self.buf = line.split_whitespace().rev().map(String::from).collect();
        }
    }
}
