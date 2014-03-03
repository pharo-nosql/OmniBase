public
addHolders: holders 
	"Add object holders to table and initialize their object ID indexes."

	| lastIndex freeHolders count count2 buffer holder |
	count := holders size.
	count2 := 0.
	buffer := ByteArray new: 8.
	self waitForAddingLock.
	
	[stream 
		atPosition: self headerLength + 4
		getBytesFor: buffer
		len: 8.
	lastIndex := buffer odbLongAt: 1.
	"       (freeHolders := buffer odLongAt: 5) == 0 ifFalse: [
            count2 := count min: freeHolders.
            count := count - count2.
            stream position: self headerLength + 8; putLong: freeHolders - count2; flush.
            buffer := ByteArray new: count2 * 4.
            bufPos := lastIndex * valueLength + start + (freeHolders - count2 * 4).
            stream position: bufPos; getBytesFor: buffer; truncate: bufPos.
            1 to: count2 do: [:i |
                holder := holders at: i.
                bufPos := buffer odLongAt: (i * 4 - 3).
                holder objectID index: bufPos."
	"               self at: bufPos put: holder contents"
	"           ].
            stream flush
        ].
        count == 0 ifTrue: [ ^self ]."
	stream atPosition: self headerLength + 4 putLong: lastIndex + count] 
			ensure: [self unlockAdding].
	buffer := ByteArray new: count * valueLength.
	count2 + 1 to: holders size
		do: 
			[:i | 
			holder := holders at: i.
			lastIndex := lastIndex + 1.
			holder objectID index: lastIndex
			"       buffer replaceFrom: bufPos to: bufPos + valueLength - 1 with: holder contents startingAt: 1.
        bufPos := bufPos + valueLength"].
	stream
		atPosition: lastIndex * valueLength + start putBytesFrom: buffer;
		flush