public/load/store
loadFromStream: aStream

    | bytes |
    bytes := ByteArray new: self class sizeInBytes.
    aStream getBytesFor: bytes.
    self fromBytes: bytes at: 1