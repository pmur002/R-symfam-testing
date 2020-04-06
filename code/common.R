library(grid)

TestChars <- function(...) {
    info = l10n_info()
    r <- c(32:126, 160:254)
    par(pty = "s")
    plot(c(-1,10), c(20,260),
         type = "n", xlab = "", ylab = "", xaxs = "i", yaxs = "i")
    grid(11, 24, lty = 1)
    mtext(paste("MBCS:", info$MBCS, "  UTF8:", info$`UTF-8`,
                "  Latin:", info$`Latin-1`))
    for (i in r)
        try(points(i%%10, 10*i%/%10, pch = i, font = 5,...))
}

readPDFfonts <- function(pdf) {
    info <- system(paste("pdffonts", pdf), intern=TRUE)
    if (length(info) < 3) {
        "glyphmissing"
    } else {
        dashes <- strsplit(info[2], " ")[[1]]
        widths <- nchar(dashes) + c(rep(1, length(dashes) - 1), 0)
        fonts <- read.fwf(textConnection(info[-(1:2)]), widths)
        names(fonts) <- read.fwf(textConnection(info[1]), widths,
                                 stringsAsFactors=FALSE)
        gsub(".+[+]| +", "", fonts$name)
    }
}

glyphFont <- function(glyph, symbolfont) {
    cairo_pdf("/tmp/temp.pdf", symbolfamily=symbolfont)
    grid::grid.points(.5, .5, default="npc", pch=glyph,
                      gp=grid::gpar(fontface=5))
    dev.off()
    readPDFfonts("/tmp/temp.pdf")
}

## Adobe Symbol Encoding from src/library/grDevices/inst/enc/AdobeSym.enc
asm <- c(
"space","exclam","universal","numbersign","existential","percent","ampersand","suchthat",
"parenleft","parenright","asteriskmath","plus","comma","minus","period","slash",
"zero","one","two","three","four","five","six","seven",
"eight","nine","colon","semicolon","less","equal","greater","question",
##  0100
"congruent","Alpha","Beta","Chi","Delta","Epsilon","Phi","Gamma",
"Eta","Iota","theta1","Kappa","Lambda","Mu","Nu","Omicron",
"Pi","Theta","Rho","Sigma","Tau","Upsilon","sigma1","Omega",
"Xi","Psi","Zeta","bracketleft","therefore","bracketright","perpendicular","underscore",
##  0140
"radicalex","alpha","beta","chi","delta","epsilon","phi","gamma",
"eta","iota","phi1","kappa","lambda","mu","nu","omicron",
"pi","theta","rho","sigma","tau","upsilon","omega1","omega",
"xi","psi","zeta","braceleft","bar","braceright","similar",".notdef",
##  0200
".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",
".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",
".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",
".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",".notdef",
##  0240
"Euro","Upsilon1","minute","lessequal","fraction","infinity","florin","club",
"diamond","heart","spade","arrowboth","arrowleft","arrowup","arrowright","arrowdown",
"degree","plusminus","second","greaterequal","multiply","proportional","partialdiff","bullet",
"divide","notequal","equivalence","approxequal","ellipsis","arrowvertex","arrowhorizex","carriagereturn",
##  0300
"aleph","Ifraktur","Rfraktur","weierstrass","circlemultiply","circleplus","emptyset","intersection",
"union","propersuperset","reflexsuperset","notsubset","propersubset","reflexsubset","element","notelement",
"angle","gradient","registerserif","copyrightserif","trademarkserif","product","radical","dotmath",
"logicalnot","logicaland","logicalor","arrowdblboth","arrowdblleft","arrowdblup","arrowdblright","arrowdbldown",
##  0340
"lozenge","angleleft","registersans","copyrightsans","trademarksans","summation","parenlefttp","parenleftex",
"parenleftbt","bracketlefttp","bracketleftex","bracketleftbt","bracelefttp","braceleftmid","braceleftbt","braceex",
".notdef","angleright","integral","integraltp","integralex","integralbt","parenrighttp","parenrightex",
"parenrightbt","bracketrighttp","bracketrightex","bracketrightbt","bracerighttp","bracerightmid","bracerightbt",".notdef")

notdef <- asm == ".notdef"
glyph <- 31 + seq_along(asm)

symbolFonts <- function(font="Symbol", symbolfont,
                        filename=font, fontname=font,
                        excludeNotDef=TRUE, writeResult=TRUE,
                        outputFile="temp.fonts") {
    fonts <- "notdef"
    fonts[!notdef] <- sapply(glyph[!notdef], glyphFont, symbolfont)
    result <- cbind(asm, fonts)
    if (excludeNotDef) {
        result <- result[!notdef, ]
    }
    if (writeResult) {
        safename <- gsub(" ", "-", filename)
        write.table(result, outputFile,
                    quote=FALSE, row.names=FALSE, col.names=FALSE)
    }
    symbolReport(result, fontname)
}

symbolReport <- function(fonts, fontname) {
    print(table(fonts[,2]))
    substitutions <- fonts[fonts[,2] != fontname, ]
    print(head(substitutions))
    if (nrow(substitutions) > 6) {
        cat(paste0("... and ", nrow(substitutions) - 6, " more ...\n"))
    }
    invisible(substitutions)
}
