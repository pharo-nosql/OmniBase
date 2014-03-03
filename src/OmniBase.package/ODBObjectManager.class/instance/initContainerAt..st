private
initContainerAt: position 
	"Private - Initialize container stored in infoFile at position.
	Answer container."

	| id name path cont dirName stream newArray |
	stream := infoFile stream.
	stream position: position.
	id := stream getWord.
	name := stream getString.
	path := stream getString.
	path isEmpty ifTrue: [path := self dirName].
	dirName := stream getString.
	id > containers size 
		ifTrue: 
			[newArray := Array new: id.
			newArray 
				replaceFrom: 1
				to: containers size
				with: containers
				startingAt: 1.
			containers := newArray].
	cont := (ODBContainer new)
				name: name;
				id: id;
				objectManager: self;
				openOn: path , ODBFileStream pathSeparatorString , dirName.
	^containers at: id put: cont