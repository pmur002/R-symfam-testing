# R-symfam-testing
Testing instructions and code for R-symfam branch

## Getting the branch

`svn checkout https://svn.r-project.org/R/branches/R-symfam/ R`

## Building the branch

The branch has been built on Ubuntu 18.04 (desktop) and Fedora 31 (Docker
container).

**It would be useful to know whether the branch builds on macOS and
on Windows.**

## Do the new defaults work ?

The branch introduces a new `symbolfamily` argument on Cairo-based graphics
devices (e.g., `x11(type="cairo")` and `png(type="cairo")` and
`cairo_pdf()`) and there is a new `cairoSymbolFont()` function, which
has a `usePUA` argument, but all of these new additions are supposed to
be ignorable, with sensible (or at least workable) default settings.

**It would be useful to know whether the following code runs AND
produces sensible-looking output on macOS and on Windows.**

```
source("code/common.R")
cairo_pdf()
TestChars()
example(plotmath)
dev.off()
```

If you are happy to try installing my 'gdiff' package from github, something
based on the following code (adjust paths to R binaries)
should provide a quick test of whether the
new default produces the same output as the old default.

```
devtools::install_github("pmur002/gdiff")
f <- function() {
    source("code/common.R")
    TestChars()
    example(plotmath)
}
library(gdiff)
Rdevel <- localSession(Rscript="/path/to/r-devel/BUILD/bin/R")
Rsymfam <-
    localSession(Rscript="/path/to/r-devel-symbolfamily/BUILD/bin/R")
gdiff(f,
      session=list(control=Rdevel, test=Rsymfam),
      device=cairo_pdf_device())
```

## Testing the new `symbolfamily` argument

The new `symbolfamily` argument is designed to allow the user to select
an alternative font (family) to be used for "font face 5" (e.g., plotmath).
This is just for Cairo graphics devices and can only be done once per device,
when the device is created.

**It would be useful to know if the following code runs and
produces output that is different from the default (above)
on macOS and on Windows.**

```
source("code/common.R")
cairo_pdf(symbolfamily="NameOfAFont")
TestChars()
example(plotmath)
dev.off()
```

You will need to choose a font that is installed on your system,
but it does not matter whether the font contains all of the Adobe
Symbol Encoding symbols
(i.e., the output looks yuk, with missing glyphs).
Just looking for evidence that we are able to select a different font
at this stage.  Some possibilities are "Helvetica" or 
"Apple Symbols" on macOS (?) and "Arial" on Windows (?).

## Testing the new `cairoSymbolFont()` function

The new `cairoSymbolFont()` function is designed to allow the user
to specify that the symbol font does NOT use Private Use Area (PUA) code points.
By default, R uses PUA code points with the symbol font.

This might be harder to demonstrate, but if you got some missing symbols
in the previous test, you will hopefully see them filled in on this test.

**It would be useful to know if the following code runs and
produces output that is an improvement on the previous test
on macOS and on Windows.**

```
source("code/common.R")
cairo_pdf(symbolfamily=cairoSymbolFont("NameOfAFont", usePUA=FALSE))
TestChars()
example(plotmath)
dev.off()
```

Again, you will need to choose a font that is installed on your system
and ideally it will be a font with a wide Unicode coverage.  If you use 
the same font for this test as the previous test, you will hopefully 
see some (positive) differences.  If you use a new font here, you should
see differences between just using `symbolfamily="fontname"` and using
`symbolfamily=cairoSymbolFont("fontname", usePUA=FALSE)`.

Thanks for any help you can give!

Paul
-- 
Dr Paul Murrell\
Department of Statistics\
The University of Auckland\
paul@stat.auckland.ac.nz\
http://www.stat.auckland.ac.nz/~paul/
