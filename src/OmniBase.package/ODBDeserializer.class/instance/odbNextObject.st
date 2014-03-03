private
odbNextObject

	^(classArray at: stream getByte) odbDeserialize: self