accessing
activateClientID: clientID
        "Mark clientID as active."

    self clientTableAt: clientID lockAndPut: 1