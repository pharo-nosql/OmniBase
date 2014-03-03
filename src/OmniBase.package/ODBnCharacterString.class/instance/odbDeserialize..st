accessing
odbDeserialize: deserializer

    | buf |
    deserializer stream getBytesFor: (buf := ByteArray new: n) len: n.
    ^deserializer register: buf asString