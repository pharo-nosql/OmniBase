private
globalLockClientID: clientID
                "Private - Write clientID of client that has put global lock."

        stream position: self headerLength; putByte: clientID