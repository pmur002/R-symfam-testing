source("code/common.R")
cairo_pdf(filename = "plot%03draw.pdf")
TestChars()
example(plotmath)
dev.off()

source("code/common.R")
cairo_pdf(filename = "plot%03dhelv.pdf", symbolfamily="Helvetica")
TestChars()
example(plotmath)
dev.off()


source("code/common.R")
cairo_pdf(filename = "plot%03dapsym.pdf", symbolfamily="Apple Symbols")
TestChars()
example(plotmath)
dev.off()



source("code/common.R")
cairo_pdf(filename = "plot%03dhelvNoPUA.pdf",  symbolfamily=cairoSymbolFont("Helvetica", usePUA=FALSE))
TestChars()
example(plotmath)
dev.off()

source("code/common.R")
cairo_pdf(filename = "plot%03dapsymNoPUA.pdf",  symbolfamily=cairoSymbolFont("Apple Symbols", usePUA=FALSE))
TestChars()
example(plotmath)
dev.off()
