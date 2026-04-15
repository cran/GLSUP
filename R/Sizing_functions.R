sizing.BH<-function(ord){
### For BH, the sizing function is just the number of rejected
### hypotheses. It does not depend on the order of the hypotheses.
    return(seq_along(ord))
}

sizing.wBH<-function(weights){
    wght<-weights
    sizing<-function(ord){
### Returns the sum of weights of rejected hypotheses.
        return(cumsum(wght[ord]))
    }
}

minimal.weights.forest<-function(weights,parents){
### Creates a sizing function for minimal element weights for a
### forest. The sizing of a set consists of the sum of weights for
### minimal elements.

### weights --- the vector of node weights
### parents --- a vector of indices of the parent of each node, (NA for
###             the root node)

    wght<-weights
    par<-parents
    sizing<-function(ord){
        ## Calculate inverse permutation
        ord.inv<-ord
        ord.inv[ord]<-seq_along(ord) 
        
        ord.weight<-wght[ord]
        ord.par<-ord.inv[par[ord]]
        up.par<-ord.par
        adj.weight<-ord.weight

        ## remove any parents ranked after their descendents.
        for(i in seq_along(up.par)){
            while(!is.na(up.par[i])&&up.par[i]>i){
                adj.weight[up.par[i]]<-0
                up.par[i]<-up.par[up.par[i]]
            }
        }
        ## Now form a vector aw of the weights which are not minimal. 
        ## These are subtracted from all weights. 
        used<-rep(FALSE,length(weights))
        aw<-rep(0,length(adj.weight))
        for(i in seq_along(weights)){
            if(!is.na(up.par[i])&&!used[up.par[i]]){
                aw[i]<-adj.weight[up.par[i]]
                used[up.par[i]]<-TRUE
            }        
        }
        aw[is.na(aw)]<-0
        cum.weight.red<-cumsum(aw)
        return(cumsum(adj.weight)-cum.weight.red)
        
    }
    return(sizing)
}



minimal.weights.poset<-function(weights,poset){
### Creates a sizing function for minimal element weights for a
### forest. The sizing of a set consists of the sum of weights for
### minimal elements.

### weights --- the vector of node weights
### poset   --- an object of class "poset", which is a 2-component list:
###              covers  --- list of lists of elements covered by each element.
###              inc.order --- a total order on the elements consistent with
###                            the partial order. 

    wght<-weights
    pst<-poset
    sizing<-function(ord){
        ## Calculate inverse permutation
        ord.inv<-ord
        ord.inv[ord]<-seq_along(ord) 
        
        ## Identify when each element becomes non-minimal
        nm<-rep(Inf,length(ord))
        for(i in pst$inc.order){
            nm[i]<-withCallingHandlers({min(c(nm[pst$covers[[i]]],ord.inv[pst$covers[[i]]]))},
                                       warning=function(w){
                                           if(grepl("no non-missing arguments",conditionMessage(w))){
                                               invokeRestart("muffleWarning")}})
        }

        in.up<-pmin(nm,ord.inv) # the first time an element below i
                                        # enters the list.
        add<-rep(0,length(ord))
        sub<-rep(0,length(ord))
        for(i in seq_along(ord)){
            add[in.up[i]]<-add[in.up[i]]+wght[i]
            sub[nm[i]]<-sub[nm[i]]+wght[i]
        }

        return(cumsum(add)-cumsum(sub))
    }
    return(sizing)
}
