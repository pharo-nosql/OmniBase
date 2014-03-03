private/unclassified
removePending: clientID
                "Private - Client is about to be removed."

        (localClient notNil and: [localClient clientID == clientID]) ifTrue: [localClient := nil].
        clients at: clientID put: nil.
        idTable removingClientID: clientID