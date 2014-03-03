private
clientTableAt: index put: value
                "Private - Put value at client table index."

        stream position: self headerLength + index; putByte: value