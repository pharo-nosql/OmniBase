public
containerAt: containerID
        "Answer container at containerID or default container if none."

    ^self containerAt: containerID ifAbsent: [^self defaultContainer]