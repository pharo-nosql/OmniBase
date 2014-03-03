private/initialization
initialize
        "Private - Initialize receiver."

    super initialize.
    keyLength := 20.
    valueLength := 4.
    rootPagePosition := self headerLength + 2