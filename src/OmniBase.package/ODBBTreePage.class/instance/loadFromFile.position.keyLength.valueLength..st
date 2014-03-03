private
loadFromFile: anODBTreeIterator position: position keyLength: keyLen valueLength: valueLen 
	"Private - Load receiver from stream."

	iterator := anODBTreeIterator.
	keyLength := keyLen.
	valueLength := valueLen.
	itemLength := keyLen + valueLen + 2.	"key+value+lockID"
	pagePosition := position.
	contents := ByteArray new: self bytesPerPage.
	iterator stream atPosition: position getBytesFor: contents