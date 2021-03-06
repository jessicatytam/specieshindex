% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/specieshindex.R
\name{FetchSpT_lens}
\alias{FetchSpT_lens}
\title{Fetch data from Lens - title only}
\usage{
FetchSpT_lens(genus, species, synonyms, additionalkeywords, size = 50000)
}
\arguments{
\item{genus}{Genus classification from the binomial name.}

\item{species}{Species classification from the binomial name.}

\item{synonyms}{Alternate species names.}

\item{additionalkeywords}{Optional search terms.}

\item{size}{Maximum number of documents that can be downloaded depending on the users token. Default is set to 50,000 for subscribers, the alternative is 1,000 for non-subscribers.}
}
\value{
A dataframe of the species' citation records with the given \code{genus} and \code{species}.
}
\description{
This function fetches citation information from Lens using genus and species name found in the title of the publications.
Duplicates are to be removed by the user after fetching the data.
}
\examples{
\dontrun{
FetchSpT_lens("Bettongia", "penicillata")

#lower case letter in genus is also accepted and will return identical results

FetchSpT_lens("bettongia", "penicillata")
}
\dontrun{
FetchSpT_lens("Bettongia", "penicillata", "conserv*")

#lower case letter in genus is also accepted and will return identical results

FetchSpT_lens("bettongia", "penicillata", "conserv*")
}
}
