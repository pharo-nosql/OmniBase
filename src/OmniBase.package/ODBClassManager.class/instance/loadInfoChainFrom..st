private/unclassified
loadInfoChainFrom: anInteger
        "Private - Load class info chain from pos. Answer end of list."

    | info pos lastPos stream |
    pos := anInteger.
    stream := infoFile stream.
    [pos == 0] whileFalse: [
        stream position: pos.
        lastPos := pos.
        pos := stream getLong.
        info := ODBSerializer classDescriptionFrom: stream.
        info classID: stream getLong.
        self addClassInfo: info].
    ^lastPos