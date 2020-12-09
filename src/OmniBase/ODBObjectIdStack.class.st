Class {
	#name : #ODBObjectIdStack,
	#superclass : #ODBFile,
	#instVars : [
		'cache',
		'top',
		'filePos',
		'valueSize',
		'bottom'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBObjectIdStack >> add: objectID [ 
	| oid index pos |
	top > self doubleCacheSize ifTrue: [self makeSpace].
	pos := top.
	top := top + 1.
	pos > self cacheSize ifTrue: [^(cache at: 2) at: pos - self cacheSize put: objectID].
	(cache at: 1) at: pos put: objectID
]

{ #category : #defining }
ODBObjectIdStack >> cacheSize [

	^5000
]

{ #category : #defining }
ODBObjectIdStack >> doubleCacheSize [

	^10000
]

{ #category : #initialization }
ODBObjectIdStack >> initialize [

	cache := Array
		with: (Array new: self cacheSize)
		with: (Array new: self cacheSize).
	top := 1.
	bottom := 1.
	filePos := self headerLength.
	valueSize := ODBObjectID sizeInBytes.
]

{ #category : #accessing }
ODBObjectIdStack >> isEmpty [

	^top == bottom and: [filePos == self headerLength]
]

{ #category : #public }
ODBObjectIdStack >> loadPage [
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	stream
		position: filePos - buf size;
		getBytesFor: buf.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			subCache at: i put: (ODBObjectID new fromBytes: buf at: pos).
			pos := pos + valueSize].
	filePos := filePos - buf size.
	top := count + 1.
	bottom := 1
]

{ #category : #public }
ODBObjectIdStack >> makeSpace [
	"Private - Make space on stack."

	| cache1 pos |
	bottom == 1 ifTrue: [^self storePage].
	cache1 := cache at: 1.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: cache1.
	bottom > self cacheSize 
		ifTrue: 
			[top := top - self cacheSize.
			bottom := bottom - self cacheSize.
			^self].
	pos := bottom - 1.
	bottom := 1.
	top := top - pos.
	1 to: top - 1 - self cacheSize do: [:i | cache1 at: i put: (cache1 at: i + pos)]
]

{ #category : #public }
ODBObjectIdStack >> removeLast [
	top == bottom ifTrue: [self loadPage].
	bottom > self cacheSize ifTrue: [^self removeLastCache2].
	^self removeLastCache1
]

{ #category : #private }
ODBObjectIdStack >> removeLastCache1 [

	| cache1 result |
	cache1 := cache at: 1.
	result := cache1 at: bottom.
	cache1 at: bottom put: nil.
	bottom := bottom + 1.
	^result
]

{ #category : #private }
ODBObjectIdStack >> removeLastCache2 [

	| cache2 result |
	cache2 := cache at: 2.
	result := cache2 at: bottom - self cacheSize.
	cache2 at: bottom - self cacheSize put: nil.
	bottom := bottom + 1.
	^result
]

{ #category : #public }
ODBObjectIdStack >> storePage [
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			(subCache at: i) putBytesTo: buf at: pos.
			subCache at: i put: nil.
			pos := pos + valueSize].
	stream
		position: filePos;
		putBytesFrom: buf.
	filePos := filePos + buf size.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: subCache.	"swap halves"
	top := count + 1.
	bottom := 1
]
