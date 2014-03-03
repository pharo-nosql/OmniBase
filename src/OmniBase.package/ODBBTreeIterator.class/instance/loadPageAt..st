private/page stack
loadPageAt: pagePosition
        "Private - Load B-Tree page, store it in searchPath. 
        Answer loaded page."

    | page |
    page := self pageClass loadFromFile: self
                        position: pagePosition
                        keyLength: keyLength
                        valueLength: valueLength.
    searchPathHeight := searchPathHeight + 1.
    ^searchPath at: searchPathHeight put: page