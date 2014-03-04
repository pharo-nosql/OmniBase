public
size
	"the unix Squeak VM gives the wrong answer for #size"
	| file |
	fileHandle flush.
	file := fileHandle readOnlyCopy.
	^ [file size] ensure: [file close]
	

