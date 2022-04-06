MoniBase
========
[![CI matrix](https://github.com//ApptiveGrid/MoniBase/actions/workflows/build.yml/badge.svg)](https://github.com//ApptiveGrid/MoniBase/actions/workflows/build.yml)

This is a fork of [OmniBase](https://github.com/pharo-nosql/OmniBase). The rationale for it is that for the purpose of ApptiveGrid we plan to change the way it's working. To preserve OmniBase as it is known to people we forked off to see where we go. For the time begin it stays as a fork before it might disconnect from the original.
The changes at the time are only a little twist on the code as it is on the name. The name came up through switching the first two letters while typing and so it is the perfect. 

MoniBase is a Smalltalk efficient object repository. Based on [BTrees](http://en.wikipedia.org/wiki/B-tree) and the filesystem, it has full [ACID](http://en.wikipedia.org/wiki/ACID) features.

For a log of changes have a look at [Changes](./changes.md)

For further documentation have a look at the [documentation folder](./documentation)
### Loading 

Use this snippet to load it into your [Pharo](http://www.pharo.org)* image:

```Smalltalk
Metacello new 
	repository: 'github://ApptiveGrid/MoniBase/src';
	baseline: 'MoniBase';
	load.
```

---

MIT - License
