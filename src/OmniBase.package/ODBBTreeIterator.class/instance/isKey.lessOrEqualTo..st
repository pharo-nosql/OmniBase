public/unclassified
isKey: key1 lessOrEqualTo: key2
        "Answer <true> if key1 is less or equal to key2."

    | i |
    i := 1.
    [(key1 at: i) == (key2 at: i) and: [i < keyLength]] whileTrue: [i := i + 1].
    ^(key1 at: i) <= (key2 at: i)