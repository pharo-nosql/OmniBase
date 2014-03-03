private
swapObjectSpaces
	"Private - Swap default object spaces."

	| newObjectSpace |
	gcFile status = 3 ifFalse: [^self].
	newObjectSpace := gcFile newObjectSpace.
	objectManager defaultObjectSpace == newObjectSpace 
		ifFalse: 
			[containers do: [:each | each lockObjectSpace: 1 - newObjectSpace].
			objectManager defaultObjectSpace: newObjectSpace].
	"object spaces have been swaped"
	gcFile status: 4