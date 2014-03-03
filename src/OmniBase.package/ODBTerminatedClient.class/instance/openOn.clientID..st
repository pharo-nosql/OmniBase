public/create/open/close
openOn: aClientManager clientID: clientID

    | fName |
    id := clientID.
    clientManager := aClientManager.
    fName := clientManager clientFileName: id.
    [ clientFile := ODBClientFile new openOn: fName ]
        on: Error do: [:er | ^nil ].
    clientManager addOpenedClient: self.
    self loadTransactions