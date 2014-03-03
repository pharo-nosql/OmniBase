public
indexesAndValuesDo: aBlock 
	1 to: self getLastID do: [:index | aBlock value: index value: (self at: index)]