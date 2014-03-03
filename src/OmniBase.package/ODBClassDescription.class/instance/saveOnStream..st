public
saveOnStream: aStream 
	aStream
		putString: name;
		putBoolean: bytes;
		putBoolean: variable;
		putPositiveInteger: instSize.
	instVarNames do: [:n | aStream putString: n]