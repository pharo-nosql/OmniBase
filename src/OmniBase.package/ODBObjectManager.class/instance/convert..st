private
convert: containerName 
	"Private - Answer a String which is a directory name 
	abbreviated from containerName. Lower case
	vowels are dropped from the right of containerName
	until it is less than or equal to 8 characters."

	| size dirName asciiInteger |
	dirName := containerName select: 
					[:char | 
					asciiInteger := char asInteger.
					((asciiInteger > 96 and: [asciiInteger < 123]) 
						or: [asciiInteger > 64 and: [asciiInteger < 91]]) 
							or: [asciiInteger > 47 and: [asciiInteger < 58]]].
	size := dirName size.
	dirName := (dirName reverse select: 
					[:char | 
					(char isVowel and: [char isLowercase]) ifTrue: [(size := size - 1) < 8] ifFalse: [true]]) 
				reverse.
	^dirName isEmpty 
		ifTrue: ['Contanr0']
		ifFalse: [dirName copyFrom: 1 to: (dirName size min: 8)]