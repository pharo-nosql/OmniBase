public
register: aClass 
	"Answer an instance of ODBClassDescription for aClass.
	ODBClassDescription holds meta information about objects in the database."

	| info pos |
	mutex critical: 
			[(info := self find: aClass) isNil ifFalse: [^info].
			pos := infoFile at: aClass name ifAbsent: [^self registerNewClass: aClass].
			pos := self loadInfoChainFrom: pos.
			(info := self find: aClass) isNil ifFalse: [^info].
			^self registerNewClassVersion: aClass from: pos]