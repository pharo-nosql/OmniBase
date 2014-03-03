private/unclassified
created
                "Private - Put default values into file."

        "client description = 128 bytes"
        "distributed objects hostname=32 bytes"
        "transactions count = 4 bytes"
        stream putBytesFrom: (ByteArray new: 164); flush