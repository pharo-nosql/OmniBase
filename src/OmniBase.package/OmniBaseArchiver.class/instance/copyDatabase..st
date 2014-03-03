public
copyDatabase: silentBool 
	silentBool = true 
		ifTrue: [self copyDatabase]
		ifFalse: 
			['OmniBase on-line backup'
				displayProgressAt: Sensor cursorPoint
				from: 0 to: 100
				during:
					[:bar |
						progressDialog := bar.
						progressValue := bar.
						self copyDatabase]]