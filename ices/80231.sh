#!/bin/bash

rustc -Zchalk - <<'EOF'
use std::ops::Add;

pub trait Encoder {
    type Size: Add<Output = Self::Size>;

    fn foo(&self) -> Self::Size;
}

pub trait SubEncoder : Encoder {
    type ActualSize;

    fn bar(&self) -> Self::Size;
}

impl<T> Encoder for T where T: SubEncoder {
    type Size = <Self as SubEncoder>::ActualSize;

    fn foo(&self) -> Self::Size {
        self.bar() + self.bar()
    }
}

pub struct UnitEncoder;

impl SubEncoder for UnitEncoder {
    type ActualSize = ();

    fn bar(&self) {}
}


fn main() {
    fun(&UnitEncoder {});
}

pub fn fun<R: Encoder>(encoder: &R) {
    encoder.foo();
}
EOF
