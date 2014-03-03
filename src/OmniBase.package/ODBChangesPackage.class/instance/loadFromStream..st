public
loadFromStream: aStream 
	"Load receiver from aStream."

	"collect change class IDs"

	| memoryStream classID classes change |
	classes := IdentityDictionary new.
	self collectChangeClassIDsFrom: ODBChange to: classes.
	"load changes"
	changes := OrderedCollection new.
	memoryStream := ODBMemoryReadStream new readFrom: aStream.
	[(classID := memoryStream getByte) > 0] whileTrue: 
			[change := (classes at: classID
						ifAbsent: [OmniBase signalError: 'Transaction rollback: Unknown change classID']) new 
						loadFromStream: memoryStream.
			changes add: change]