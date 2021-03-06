% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/VarID_functions.R
\name{pruneKnn}
\alias{pruneKnn}
\title{Function inferring a pruned knn matrix}
\usage{
pruneKnn(
  expData,
  distM = NULL,
  large = TRUE,
  regNB = TRUE,
  batch = NULL,
  regVar = NULL,
  ngenes = NULL,
  span = 0.75,
  pcaComp = 100,
  algorithm = "kd_tree",
  metric = "pearson",
  genes = NULL,
  knn = 10,
  alpha = 10,
  no_cores = NULL,
  FSelect = FALSE,
  seed = 12345
)
}
\arguments{
\item{expData}{Matrix of gene expression values with genes as rows and cells as columns. These values have to correspond to unique molecular identifier counts.}

\item{distM}{Optional distance matrix used for determining k nearest neighbours. Default is \code{NULL} and the distance matrix is computed using a metric given by the parameter \code{metric}.}

\item{large}{logical. If \code{TRUE} then no distance matrix is required and nearest neighbours are inferred by the \pkg{FNN} package based on a reduced
feature matrix computed by a principle component analysis. Only the first \code{pcaComp} principle components are considered. Prior to principal component
analysis a negative binomial regression is performed to eliminate the dependence on the total number of transcripts per cell. The pearson residuals of
this regression serve as input for the principal component analysis after smoothing the parameter dependence on the mean by a \code{loess} regression.
Deafult is \code{TRUE}.
Recommended mode for very large datasets, where a distance matrix consumes too much memory. A distance matrix is no longer required, and if \code{distM}
is initialized it will be ignored if \code{large} equals \code{TRUE}.}

\item{regNB}{logical. If \code{TRUE} then gene a negative binomial regression is performed to prior to the principle component analysis if \code{large = TRUE}. See \code{large}. Default is \code{TRUE}.}

\item{batch}{vector of batch variables. Component names need to correspond to valid cell IDs, i.e. column names of \code{expData}. If \code{regNB} is \code{TRUE}, than the batch variable will be regressed out simultaneously with the log10 UMI count per cell.An interaction term is included for the log10 UMI count with the batch variable. Default value is \code{NULL}.}

\item{regVar}{data.frame with additional variables to be regressed out simultaneously with the log10 UMI count and the batch variable (if \code{batch} is \code{TRUE}). Column names indicate variable names (name \code{beta} is reserved for the coefficient of the log10 UMI count), and rownames need to correspond to valid cell IDs, i.e. column names of \code{expData}. Interaction terms are included for each variable in \code{regVar} with the batch variable (if \code{batch} is \code{TRUE}). Default value is \code{NULL}.}

\item{ngenes}{Positive integer number. Randomly sampled number of genes (from rownames of \code{expData}) used for predicting regression coefficients (if \code{regNB=TRUE}). Smoothed coefficients are derived for all genes. Default is \code{NULL} and all genes are used.}

\item{span}{Positive real number. Parameter for loess-regression (see \code{large}) controlling the degree of smoothing. Default is 0.75.}

\item{pcaComp}{Positive integer number. Number of princple components to be included if \code{large} is \code{TRUE}. Default is 100.}

\item{algorithm}{Algorithm for fast k nearest neighbour inference, using the \code{get.knn} function from the \pkg{FNN} package.
See \code{help(get.knn)}. Deafult is "kd_tree".}

\item{metric}{Distances are computed from the  expression matrix \code{x} after optionally including only genes given as argument \code{genes} or after optional feature selection (see \code{FSelect}).
Possible values for \code{metric} are \code{"pearson", "spearman", "logpearson",  "euclidean"}.  Default is \code{"pearson"}. In case of the correlation based methods,
the distance is computed as 1 – correlation.}

\item{genes}{Vector of gene names corresponding to a subset of rownames of \code{x}. Only these genes are used for the computation of a distance matrix and for the computation of joint probabilities of nearest neighbours. Default is \code{NULL} and all genes are used.}

\item{knn}{Positive integer number. Number of nearest neighbours considered for each cell. Default is 10.}

\item{alpha}{Positive real number. Relative weight of a cell versus its k nearest neigbour applied for the derivation of joint probabilities. A cell receives a weight of \code{alpha} while the weight of its k nearest neighbours is determined by quadratic programming. The sum across all weights is normalized to one, and the wieghted mean expression is used for computing the joint probability of a cell and each of its k nearest neighbours. These probabilities are used for the derivation of of link probabilities. Default is 10. Larger values give more weight to the gene expression observed in a cell versus its neighbourhood.}

\item{no_cores}{Positive integer number. Number of cores for multithreading. If set to \code{NULL} then the number of available cores minus two is used. Default is 1.}

\item{FSelect}{Logical parameter. If \code{TRUE}, then feature selection is performed prior to distance matrix calculation and VarID analysis. Default is \code{FALSE}.}

\item{seed}{Integer number. Random number to initialize stochastic routines. Default is 12345.}
}
\value{
List object of six components:
\item{distM}{Distance matrix.}
\item{dimRed}{PCA transformation of \code{expData} including the first \code{pcaComp} principle components, computed on including \code{genes} or
variable genes only if \code{Fselect} equals \code{TRUE}. Is is set to \code{NULL} if \code{large} equals \code{FALSE}.}
\item{pvM}{Matrix of link probabilities between a cell and each of its k nearest neighbours. Column \code{i} shows the k nearest neighbour link probabilities for cell \code{i} in matrix \code{x}. }
\item{NN}{Matrix of column indices of k nearest neighbours for each cell according to input matrix \code{x}. First entry corresponds to index of the cell itself. Column \code{i} shows the k nearest neighbour indices for cell \code{i} in matrix \code{x}.}
\item{B}{List object with background model of gene expression as obtained by \code{fitBackVar} function.}
\item{regData}{If \code{regNB=TRUE} this argument contains a list of four components: component \code{pearsonRes} contains a matrix of the Pearson Residual computed from the negative binomial regression, component \code{nbRegr} contains a matrix with the regression coefficients, component \code{nbRegrSmooth} contains a matrix with the smoothed regression coefficients, and \code{log10_umi} is a vector with the total log10 UMI count for each cell. The regression coefficients comprise the dispersion parameter theta, the intercept, the regression coefficient beta for the log10 UMI count, and the regression coefficients of the batches (if \code{batch} is not \code{NULL}).}
}
\description{
This function determines k nearest neighbours for each cell in gene expression space, and tests if the links are supported by a negative binomial joint distribution of gene expression. A probability is assigned to each link which is given by the minimum joint probability across all genes.
}
\examples{
res <- pruneKnn(intestinalDataSmall,metric="pearson",knn=10,alpha=1,no_cores=1,FSelect=FALSE)
}
