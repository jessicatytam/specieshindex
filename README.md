
<img src="README_files/figure-gfm/stickerfile.png" alt="hexsticker" height="250px" align="right" />

# specieshindex

[![CRAN
status](https://www.r-pkg.org/badges/version/specieshindex)](https://CRAN.R-project.org/package=specieshindex)
![R-CMD-check](https://github.com/jessicatytam/specieshindex/workflows/CI/badge.svg)
[![](https://codecov.io/gh/jessicatytam/specieshindex/branch/master/graph/badge.svg)](https://codecov.io/gh/jessicatytam/specieshindex)
[![Github All
Releases](https://img.shields.io/github/downloads/jessicatytam/specieshindex/total.svg)]()

`specieshindex` is a package that aims to gauge scientific influence of
different species mainly using the *h*-index.

## Installation

To get this package to work, make sure you have the following packages
installed.

``` r
#Installation from GitHub
install.packages("rscopus")
install.packages("wosr")
install.packages("lens2r")
install.packages("taxize")
install.packages("XML")
install.packages("jsonlite")
install.packages("httr")
install.packages("dplyr")
install.packages("data.table")
devtools::install_github("jessicatytam/specieshindex", force = TRUE, build_vignettes = FALSE)

#Load the library
library(specieshindex)
```

You can find the vignette
[here](https://github.com/jessicatytam/specieshindex/blob/master/vignettes/vignette.pdf)
for more detailed instructions and the full list of functions
[here](https://github.com/jessicatytam/specieshindex/blob/master/specieshindex_0.1.1.pdf).

## Before you start

### :dart: Additional keywords

The Count and Fetch functions allow the addition of keywords using
Boolean operators to restrict the domain of the search. Although you can
simply use keywords such as “conservation”, you will find that using
“conserv\*” will yield more results. The “\*” (or wildcard) used here
searches for any words with the prefix “conserv”, e.g. conservation,
conserve, conservatory, etc. Find out more about search language
[here](https://guides.library.illinois.edu/c.php?g=980380&p=7089537) and
[here](http://schema.elsevier.com/dtds/document/bkapi/search/SCOPUSSearchTips.htm).

### :boar: Synonyms

Some species have had their classification changed in the past,
resulting in multiple binomial names and synonyms. Synonyms can be added
to the search strings to get the maximum hits. If you have more than 1
synonym, you can parse a list (the list should be named “synonyms”) into
the argument.

### :mega: Connecting to Scopus

**Make sure you are connected to the internet via institutional access
or acquire a VPN from your institution if you are working from home.**
Alternatively, if you are a subscriber of Scopus already, you can ignore
this step.

#### :key: Getting an API key

To connect and download citation information from Scopus legally, you
will **absolutely need** an API key. Here are the steps to obtain the
key.

1.  Go to <https://dev.elsevier.com/> and click on the button `I want an
    API key`.
2.  Create an account and log in.
3.  Go to the `My API Key` tab on top of the page and click `Create API
    Key`.
4.  Read the legal documents and check the boxes.

### :mega: Connecting to Web of Science

You will need to set up your session ID before gaining access to the Web
of Science database. Run the following line of code to do so.

``` r
sid <- auth(username = NULL, password = NULL)
```

You won’t have to set your ID again until your next session. You are
required to be at your institution for this to work since the API is
accessed via the IP address.

### :mega: Connecting to Lens

An individual token is required to extract data from Lens. You will not
be able to use the Count and Fetch functions if your institution is not
a subscriber of Lens.

1.  Create an account with Lens.
2.  Go to <https://www.lens.org/lens/user/subscriptions#scholar> and
    select your desired Scholarly API.
3.  Request access.

## Examples

Here is a quick demonstration of how the package works.

### :pencil2: Count and Fetch Syntax

Multiple databases have been incorporated into `specieshindex`,
including Scopus, Web of Science, and Lens. To differentiate between
them, the suffix of the Count and Fetch functions have been labeled with
the database’s name, with the exception of Scopus.

``` r
#Scopus requests
API <- "your_api_key_from_scopus"
CountSpT(genus = "Bettongia", species = "penicillata", APIkey = API)
FetchSpT(genus = "Bettongia", species = "penicillata", APIkey = API)

#Web of science requests
#No tokens or api keys needed if session ID has been set as shown previously
CountSpT_wos(genus = "Bettongia", species = "penicillata")
FetchSpT_wos(genus = "Bettongia", species = "penicillata")

#Lens requests
token <- "your_lens_token"
CountSpT_lens(genus = "Bettongia", species = "penicillata", token = token)
FetchSpT_lens(genus = "Bettongia", species = "penicillata", token = token)
```

### :abacus: Counting citation records

If you are only interested in knowing how many publications there are on
Scopus, you can run the Count functions. Use `CountSpT()` for title only
or `CountSpTAK()` for title+abstract+keywords.

``` r
#API key
API <- "your_api_key_from_scopus"

#Count citation data
CountSpT("Bettongia", "penicillata", APIkey = API)
CountSpTAK("Bettongia", "penicillata", APIkey = API)

#Example including additional keywords
CountSpTAK("Phascolarctos", "cinereus", additionalkeywords = "(consrv* OR protect* OR reintrod* OR restor*)", APIkey = API)
#search string: TITLE-ABS-KEY("Phascolarctos cinereus" AND (consrv* OR protect* OR reintrod* OR restor*))

#Example including synonyms
CountSpT("Osphranter", "rufus", synonyms = "Macropus rufus", additionalkeywords = "conserv*", APIkey = API)
#search string: TITLE(("Osphranter rufus" OR "Macropus rufus") AND conserv*)
```

### :fishing\_pole\_and\_fish: Extracting citaiton records

In order to calculate the indices, you will need to download the
citation records. The parameters of the Count and Fetch functions are
exactly the same. Let’s say you want to compare the species h-index of a
few marsupials. First, you would need to download the citation
information using either `FetchSpT()` for title only or `FetchSpTAK()`
for title+abstract+keywords. Remember to use binomial names.

``` r
#Extract citation data
Woylie <- FetchSpTAK("Bettongia", "penicillata", APIkey = API)
Quokka <- FetchSpTAK("Setonix", "brachyurus", APIkey = API)
Platypus <- FetchSpTAK("Ornithorhynchus", "anatinus", APIkey = API)
Koala <- FetchSpTAK("Phascolarctos", "cinereus", APIkey = API)
```

### :bar\_chart: Index calculation and plotting

Now that you have the data, you can use the `Allindices()` function to
create a dataframe that shows their indices.

``` r
# Calculate indices
W <- Allindices(Woylie, genus = "Bettongia", species = "penicillata")
Q <- Allindices(Quokka, genus = "Setonix", species = "brachyurus")
P <- Allindices(Platypus, genus = "Ornithorhynchus", species = "anatinus")
K <- Allindices(Koala, genus = "Phascolarctos", species = "cinereus")

CombineSp <- dplyr::bind_rows(W, Q, P, K) #combining the citation records
CombineSp
```

    ##              genus_species     species           genus publications citations
    ## 1    Bettongia_penicillata penicillata       Bettongia          113      1903
    ## 2       Setonix_brachyurus  brachyurus         Setonix          242      3427
    ## 3 Ornithorhynchus_anatinus    anatinus Ornithorhynchus          321      6365
    ## 4   Phascolarctos_cinereus    cinereus   Phascolarctos          773     14291
    ##   journals years_publishing  h     m i10 h5 Article Review
    ## 1       55               44 26 0.591  54  6     110      3
    ## 2      107               67 29 0.433 121  3     237      5
    ## 3      153               68 41 0.603 177  6     308     13
    ## 4      227              140 53 0.379 427 12     744     29

Once you are happy with your dataset, you can make some nice plots.
Using `ggplot2`, we can compare the *h*-index and the total citations.

``` r
#h-index
library(ggplot2)
ggplot(CombineSp, aes(x = species,
                      y = h)) +
  geom_point(size = 4,
             colour = "#6fc6f8") +
  labs(y = "h-index") +
  scale_x_discrete(labels = c("Platypus", "Quokka", "Koala", "Woylie")) +
  ylim(25, 55) +
  theme(axis.title = element_text(size = 12,
                                  colour = "white"),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 10,
                                 colour = "white"),
        axis.line.x = element_line(colour = "grey80"),
        plot.background = element_rect(fill = "black"),
        panel.background = element_rect(fill = "black"),
        panel.grid.major.y = element_line(colour = "grey50"),
        panel.grid.minor.y = element_line(colour = "grey50",
                                          linetype = "longdash"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = "none")
```

<img src="README_files/figure-gfm/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />

**Figure 1.** The *h*-index of the Woylie, Quokka, Platypus, and Koala.

<br/>

``` r
#Total citations
ggplot(CombineSp, aes(x = species,
                      y = m)) +
  geom_point(size = 4,
             colour = "#f976bb") +
  labs(y = "m-index") +
  scale_x_discrete(labels = c("Platypus", "Quokka", "Koala", "Woylie")) + 
  theme(axis.title = element_text(size = 12,
                                  colour = "white"),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 10,
                                 colour = "white"),
        axis.line.x = element_line(colour = "grey80"),
        plot.background = element_rect(fill = "black"),
        panel.background = element_rect(fill = "black"),
        panel.grid.major.y = element_line(colour = "grey50"),
        panel.grid.minor.y = element_line(colour = "grey50",
                                          linetype = "longdash"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = "none")
```

<img src="README_files/figure-gfm/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

**Figure 2.** The *m*-index of the Woylie, Quokka, Platypus, and Koala.

<br/>

## :paw\_prints: Roadmap

  - Web of Science
      - [x] Count functions working
      - [ ] Fetch functions working
      - [x] All indices working
  - BASE
      - [ ] Count functions working
      - [ ] Fetch functions working
      - [ ] All indices working
  - Lens
      - [x] Count functions working
      - [x] Fetch functions working
      - [x] All indices working

## :rocket: Acknowledgements

`specieshindex` is enabled by Scopus, Web of Science, and [The
Lens](https://www.lens.org/).

<iframe src="https://lens.org/lens/embed/attribution" scrolling="no" height="30px" width="100%">

</iframe>
