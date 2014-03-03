public
put: aValue 
	mutex critical: [self basicPut: aValue]