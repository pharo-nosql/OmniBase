public
lockID: anInteger 
	self uShortAtOffset: (indexOnPage + 1) * itemLength - 1 put: anInteger