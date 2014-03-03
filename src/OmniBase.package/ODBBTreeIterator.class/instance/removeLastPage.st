private/page stack
removeLastPage
        "Private - Remove last page in search path. 
        Answer current last page in search path."

    searchPath at: searchPathHeight put: nil.
    searchPathHeight := searchPathHeight - 1.
    ^searchPath at: searchPathHeight