private
add: anOmniBase
		"Private - Registers an opened database session."

	sessions isNil ifTrue: [sessions := OrderedCollection new].
	sessions add: anOmniBase.