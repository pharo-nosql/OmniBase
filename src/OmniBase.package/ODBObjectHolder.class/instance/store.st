public
store
	"Store contents to indexFile."

	| indexFile index |
	
	[(indexFile := container indexFile)
		lock: (index := objectID index);
		at: index put: contents] 
			ensure: [indexFile unlock: index]