create/open/close
remove
        "Close and remove file coressponding to receiver. 
        Answer <true> if successfull."

    | answer |
    answer := stream remove.
    stream := nil.
    ^answer