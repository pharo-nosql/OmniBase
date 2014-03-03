private
remove: anOmniBase 
	"Private - Deregisters an opened database session."

	sessions isNil ifTrue: [^self].
	sessions remove: anOmniBase ifAbsent: []