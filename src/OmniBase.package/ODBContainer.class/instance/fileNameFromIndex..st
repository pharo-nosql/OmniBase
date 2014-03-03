private
fileNameFromIndex: anInteger 
	"Private - Answer object file name from index."

	^path , ODBFileStream pathSeparatorString , anInteger printString , '.btr'