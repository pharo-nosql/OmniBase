private
makeSpace
        "Private - Add space on end of stream (add new collection)."

    collections add: (current := ByteArray new: (readLimit := 1024)).
    position := 0.
    lastSize := 0