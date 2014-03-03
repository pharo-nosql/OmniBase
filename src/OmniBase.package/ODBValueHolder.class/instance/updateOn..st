public
updateOn: aValueHolder 
	"Private - Make new version from aValueHolder."

	(removed := aValueHolder isRemoved) 
		ifFalse: 
			[object := aValueHolder object.
			objectSet := true]