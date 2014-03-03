*omnibase
odbIsLessOrEqualTo: aByteArray

    | i size |
    i := 1. size := self size.
    [(self at: i) = (aByteArray at: i) and: [i < size]] whileTrue: [i := i + 1].
    ^(self at: i) <= (aByteArray at: i)