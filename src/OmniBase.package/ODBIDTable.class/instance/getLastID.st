public
getLastID
	"Answer value of last ID in file."

	^lastID := stream atPositionGetLong: self headerLength