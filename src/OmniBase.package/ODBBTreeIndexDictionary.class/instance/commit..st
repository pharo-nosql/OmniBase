private
commit: serializer 
	"Commit changes."

	dataBaseObject isNil ifTrue: [self commitNew] ifFalse: [self commitChanged]