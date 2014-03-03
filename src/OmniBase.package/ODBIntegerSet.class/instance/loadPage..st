public
loadPage: pageNumber 
	"Private - Check if page pageNumber is loaded. If not, 
	store current page to disk and load page pageNumber."

	| pagePos |
	pageNumber == currentPage ifTrue: [^self].
	changed 
		ifTrue: 
			[stream 
				atPosition: (currentPage bitShift: 12) + self headerLength
				putBytesFrom: bitField
				len: 4096].
	changed := false.
	(pagePos := (pageNumber bitShift: 12) + self headerLength) < stream size 
		ifTrue: 
			[stream 
				atPosition: pagePos
				getBytesFor: bitField
				len: 4096]
		ifFalse: 
			[1 to: bitField size do: [:i | bitField at: i put: 0].
			
			[stream 
				atPosition: stream size
				putBytesFrom: bitField
				len: 4096.
			pagePos > stream size] 
					whileTrue: []].
	currentPage := pageNumber