private
init

	classArray := Array new: 255.
	classArray
		at: 2 put: ODBNewObjectNewClass;
		at: 3 put: ODBNewObject;
		at: 4 put: ODBExistingObject;
		at: 5 put: ODBExternalReference;
		at: 6 put: ODBClassManagerForSerialization;
		at: 15 put: true;
		at: 16 put: false;
		at: 17 put: Message;
		at: 20 put: MessageSend;
		at: 19 put: Smalltalk;
		at: 22 put: Processor;
		at: 11 put: ODBLargePositiveInteger;
		at: 12 put: ODBLargeNegativeInteger;
		at: 13 put: Character;
		at: 29 put: ODBDoubleByteCharacter;
		at: 14 put: UndefinedObject;
		at: 10 put: nil;
		at: 18 put: Symbol;
		at: 26 put: Class;
		at: 31 put: Association;
		at: 32 put: Date;
		at: 33 put: Time;
		at: 34 put: String;
		at: 35 put: Array;
"		at: 36 put: UnicodeString;"
		at: 37 put: Dictionary;
		at: 38 put: IdentityDictionary;
		at: 39 put: Fraction;
		at: 40 put: Float;
		at: 41 put: (ODBCopyValue value: 0.0);
		at: 42 put: (ODBCopyValue value: 1.0);
		at: 43 put: ODBFloatAsInteger;
		at: 44 put: ODBFloatAs100Integer;
		at: 45 put: ODB8ByteFloat;
		"should be ScaledDecimal but Squeak has not support for ScaledDecimal class, e.g. 1.0s does not work"
		at: 46 put: Float;
		at: 50 put: 0;
		at: 51 put: 1;
		at: 52 put: 2;
		at: 53 put: 3;
		at: 54 put: 4;
		at: 55 put: 5;
		at: 56 put: 6;
		at: 57 put: 7;
		at: 58 put: 8;
		at: 59 put: 9;
		at: 60 put: 10;
		at: 61 put: 11;
		at: 62 put: 12;
		at: 63 put: 13;
		at: 64 put: 14;
		at: 65 put: 15;
		at: 66 put: 16;
		at: 67 put: -3;
		at: 68 put: -2;
		at: 69 put: -1;
		at: 70 put: ODBEmptyString;
		at: 71 put: ODB1CharacterString;
		at: 72 put: (ODBnCharacterString length: 2);
		at: 73 put: (ODBnCharacterString length: 3);
		at: 74 put: (ODBnCharacterString length: 4);
		at: 75 put: (ODBnCharacterString length: 5);
		at: 76 put: (ODBnCharacterString length: 6);
		at: 77 put: (ODBnCharacterString length: 7);
		at: 78 put: (ODBnCharacterString length: 8);
		at: 79 put: (ODBnCharacterString length: 9);
		at: 80 put: ByteArray;
		at: 81 put: OrderedCollection;
		at: 82 put: ODBIdentityDictionary;
		at: 83 put: ODBPersistentDictionary;
		at: 84 put: ODBTransaction;
		yourself.