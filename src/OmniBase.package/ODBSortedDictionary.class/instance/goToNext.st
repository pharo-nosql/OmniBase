public
goToNext
	currentIndex := (currentIndex < 1 ifTrue: [0 - currentIndex] ifFalse: [currentIndex + 1]) 
				min: elementCount