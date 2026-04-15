GLSUP<-function(pvals,sizing,threshold){
### GLSUP
    
### pvals is the vector of p-values
### sizing is the sizing function (technically a closure) it should
###           take a permutation as input and compute a vector of sizing
###           functions for initial subsets of this permutation.
###      Functions for producing common sizing functions are included in
###      this package. 
    
### This function rejects as many hypotheses as possible such that the
### total sizing function of all rejected hypotheses exceeds threshold
### times p-value.

    ord<-order(pvals)
    sizes<-sizing(ord)
    ord.inv<-rep(0,length(pvals))
    ord.inv[ord]<-seq_along(ord) #inverse permutation

    suppressWarnings({select<-max(which(sizes/pvals[ord]>threshold))})
    selected<-ord.inv<=select

    pvc<-pvals[ord[select]]
    if(is.na(pvc)){
        pvc<-0 # If no hypotheses rejected, cut-off is 0.
    }
    
    ans<-list("pv"=pvals[ord],
              "sizing"=sizes,
              "rejected"=selected,
              "pv.cut.off"=pvc,
              "cut.off.slope"=threshold)
    class(ans)<-"GLSUP"
    return(ans)
}

###Print method for displaying output of GLSUP

print.GLSUP<-function(x,...){
    cat("Rejected hypothesis numbers\n")
    print(which(x$rejected))
    nrej<-sum(x$rejected)
    cat(paste("\n\nRejected a total of ",nrej," hypotheses with sizing function ",x$sizing[nrej],".\n\n",sep=""))
}

### S3 method to plot GLSUP results.

plot.GLSUP<-function(x,...){
    args<-list(...)

    argn<-names(args)
    colour<-"red"
    if("col" %in% argn){
        colour<-col
        args$col<-NULL
    }
    xl<-c(0,x$pv.cut.off*4)
    if(x$pv.cut.off==0){
        xl<-c(0,x$pv[1]*10)
    }        
    if(!("xlim" %in% argn)){
        args$xlim<-xl
    }

    if(!("xlab" %in% argn)){
        args$xlab<-"p-value"
    }
    
    if(!("ylab" %in% argn)){
        args$ylab<-"sizing_function"
    }
    
    nrej<-sum(x$rejected)
    args$x<-x$pv
    args$y<-x$sizing
    
    do.call(graphics::plot.default,args)
    args$col<-colour
    
    args$x<-x$pv[seq_len(nrej)]
    args$y<-x$sizing[seq_len(nrej)]

    do.call(graphics::points.default,args)
    graphics::abline(0,x$cut.off.slope)
}


