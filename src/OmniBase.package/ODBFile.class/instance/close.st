create/open/close
close
        "Close stream associated with receiver."

    stream isNil ifFalse: [
        stream close.
        stream := nil]