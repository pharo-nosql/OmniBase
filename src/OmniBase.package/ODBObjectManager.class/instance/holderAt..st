public
holderAt: objectID 
	"Answer persistent object holder at objectID."

	^(self containerAt: objectID containerID ifAbsent: [^nil]) at: objectID index