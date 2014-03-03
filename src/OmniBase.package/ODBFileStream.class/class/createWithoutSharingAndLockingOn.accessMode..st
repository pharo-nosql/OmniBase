create/open
createWithoutSharingAndLockingOn: pathName accessMode: accessMode
	| stream  |
	stream := FileStream fileNamed: pathName.
	accessMode = #accessModeReadOnly ifTrue: [stream readOnly].
	^self new openOn: pathName fileHandle: stream.