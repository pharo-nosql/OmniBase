private
trnFileName: fileID 
	"Private - Answer transaction file name."

	^clientManager dirName , ODBFileStream pathSeparatorString , fileID printString , '.trn'