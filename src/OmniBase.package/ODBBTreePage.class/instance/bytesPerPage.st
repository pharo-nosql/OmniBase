private
bytesPerPage
	"Private - Answer number of bytes needed to load a page."

	"(keyLen + valueLen + next + lockID) * pageSize + next0 + count"

	^(itemLength + 4) * self pageSize + 5