\name{Sizing Functions}
\alias{minimal.weights.forest}
\alias{minimal.weights.poset}
\alias{sizing.BH}
\alias{sizing.wBH}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Cumulative sum-of-minimal-weights sizing function
}
\description{
  Calculates the sum-of-minimal-weights sizing function for the initial
  elements of a hierarchical tree. 
}
\usage{
minimal.weights.forest(weights,parents)
minimal.weights.poset(weights,poset)
sizing.BH(ord)
sizing.wBH(weights)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{weights}{
    A vector of weights.
  }
  \item{parents}{ A vector giving the index of the parent node for
    each node in the hierarchical tree or forest (NA for root
    nodes).
  }
  \item{poset}{An object of class poset, representing a partial order in
    the form of a list with two components:

    covers  --- list of lists of elements covered by each element.

    inc.order --- a total order on the elements consistent with the
    partial order.  
  }
  \item{ord}{
    A permutation
  }
}
\details{
  Three of these functions generate sizing functions based on their
  parameters, for use with the GLSUP function. the sizing.BH function
  can be used directly as a sizing function, as it does not depend on
  any parameters.

  sizing.BH uses the cardinality as the sizing function.

  sizing.wBH uses the sum of weights of selected elements as sizing
             function.

  minimal.weights.poset uses the sum of weights of all minimal elements
                        in the sub-partial order consisting of selected
                        elements.

  minimal.weights.forest is the same as minimal.weights.poset in the
                         special case where the partial order is a
                         hierarchical forest with root as top element in
                         each tree. In this case, the sizing function
                         can be made more computationally efficient.
}
\value{
  A sizing function that can be used with GLSUP. Sizing functions take a
  permutation as input and return the appropriate sizing function
  applied to the initial entries of the permutation.
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
parents<-c(NA,rep(seq_len(15),each=2)) # perfect binary tree
weights<-2^-c(5,rep(4,2),rep(3,4),rep(2,8),rep(1,16)) #weighted by
                                                      #no. of leaves
sizing<-minimal.weights.forest(weights,parents)

sizing(seq_len(31))
}
