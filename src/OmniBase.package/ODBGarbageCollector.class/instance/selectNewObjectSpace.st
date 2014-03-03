private
selectNewObjectSpace
	"Private - Select new object space."

	gcFile status = 2 ifFalse: [^self].
	gcFile newObjectSpace: 1 - objectManager defaultObjectSpace.
	gcFile status: 3