public
isChanged
	"Answer <true> if object has been changed."

	^changed notNil or: [dataBaseObject isNil]