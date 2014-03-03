public/unclassified
localClient
        "Answer local client."

    localClient == nil
        ifFalse: [ ^localClient ]
        ifTrue: [ ^localClient := self newClient ]