accessing
existsContainerNamed: aString
        "Answer <true> if container named aString exists."

    objectManager containerNamed: aString ifAbsent: [^false].
    ^true