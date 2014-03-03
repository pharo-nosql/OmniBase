accessing
isBeingRemoved: clientID
        "Answer <true> if clientID is being removed."

    ^(self clientTableAt: clientID) == 2