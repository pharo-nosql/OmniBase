public/accessing
contents
        "Answer ByteArray representing receiver."

    | bytes |
    bytes := ByteArray new: 4.
    bytes odbLongAt: 1 put: index; at: 4 put: containerID.
    ^bytes