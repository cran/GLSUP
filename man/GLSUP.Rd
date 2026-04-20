\name{GLSUP}
\alias{GLSUP}
\alias{print.GLSUP}
\alias{plot.GLSUP}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Generalised Linear Step-Up Procedure (GLSUP)
}
\description{
Performs variable selection, allowing the selection of sets of
surrogates using the GLSUP method for FDR control. This allows selection
of sets of variables from a hierarchical clustering of the predictors. 
}
\usage{
GLSUP(pvals,sizing,threshold)

\method{print}{GLSUP}(x,...)
\method{plot}{GLSUP}(x,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pvals}{
    The p-values of the hypothesis tests
  }
  \item{sizing}{
    The sizing function. Given a permutation of the hypotheses, this
    should calculate the sizing of every initial subset of the
    permutation.  
  }
  \item{threshold}{
    The GLSUP rejects as many hypotheses as possible such that the
    p-values are all less than the sizing function of the rejected
    hypothesis divided by this threshold. 
  }
  \item{x}{
    The GLSUP object to be printed or plotted.
  }
  \item{...}{
    Additional graphics or printing parameters. The graphics parameters
    are passed to other functions. For print.GLSUP, any additional
    parameters are ignored.
  }
}
\details{
  The GLSUP method is a generalisation of the Benjamini-Hochberg (BH) or
  Benjamini-Yekutieli (BY) procedures, where the cardinality of a set of
  rejected hypotheses is replaced by a more general sizing function
  which quantifies the total discovery from rejecting a set of
  hypotheses, potentially incorporating different importance for
  different hypotheses, and overlap between the content of the
  hypotheses. GLSUP selects the largest possible subset of hypotheses
  such that the sizing function for the set of rejected hypotheses
  exceeds the largest p-value of any rejected hypothesis multiplied by
  the threshold.   
}
\value{
  An object of class "GLSUP" which contains the following components 
  "pv"               The p-values sorted in ascending order
  "sizing"           The sizing function applied to the smallest p-values
  "rejected"         A logical vector indicating whether each hypothesis
                     is rejected
  "pv.cut.off"       The p-value cut-off below which hypotheses are rejected
  "cut.off.slope"    The threshold parameter given to the function
}
\references{
Setwise Hierarchical Variable Selection and the Generalized Linear
Step-Up Procedure for False Discovery Rate Control 

Sarah Organ, Toby Kenney, Hong Gu

http://arxiv.org/abs/2603.02160
}
\author{
Toby Kenney
}
\examples{
set.seed(1)
pv<-rbeta(31,1,5)
parents<-c(NA,rep(seq_len(15),each=2)) # perfect binary tree
weights<-2^-c(5,rep(4,2),rep(3,4),rep(2,8),rep(1,16))

sizing<-minimal.weights.forest(weights,parents)

ans<-GLSUP(pv,sizing,sum(weights)*20) # threshold under PRDS 

print(ans)
plot(ans)
}
