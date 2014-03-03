public
keysAndValuesDo: aBlock 
	1 to: elementCount do: [:i | aBlock value: (keys at: i) value: (values at: i)]