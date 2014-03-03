accessing
odbDeserialize: deserializer

    | str |
    (str := String new: 1) at: 1 put: deserializer stream getChar.
    ^deserializer register: str