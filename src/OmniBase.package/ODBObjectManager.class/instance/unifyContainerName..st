private
unifyContainerName: aString 
	"Private - unifies aString that represents a container name."

	aString trimBlanks.
	^aString size > 20 ifTrue: [aString copyFrom: 1 to: 20] ifFalse: [aString]