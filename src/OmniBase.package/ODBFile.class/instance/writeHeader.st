private
writeHeader
                "Private - Write file header to file and send #created to self."

        stream putBytesFrom: self header.
        ^self created