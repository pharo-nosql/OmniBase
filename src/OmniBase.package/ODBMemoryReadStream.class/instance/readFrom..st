initializing
readFrom: aStream
        "Read receivers contents from aStream."

    | size |
    size := aStream getLong.
    aStream position + size > aStream size ifTrue: [^self error: 'Read beyond stream size !'].
    current := ByteArray new: size.
    aStream getBytesFor: current len: size.
    position := 0