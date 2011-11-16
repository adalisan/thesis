# 
# Makefile 
# 
# 
# Global project Makefile 
# 
# 
# This makefile was based on http://209.85.135.104/search?q=cache:-fU4UEn36AgJ:kriemhild.uft.uni-bremen.de/viewcvs/Makefile.rnoweb+makefile+sweave+latex&hl=en&ct=clnk&cd=10&client=safari 
# (The original file found on Google is no longer available and I 
couldn't track a new version) 
# This is credited to Johannes Ranke, based on work by Nicholas 
Lewin-Koh and Rouben Rostmaian, and also from Deepayan Sarkar's email on the R-help mailing list. 
# 
# The master document (document preamble, \include's the other files) is thesis.tex 
MASTER = thesis.pdf

# the master document depends on all of the tex files 
RNWFILES = $(wildcard *.Rnw) 
TEXFILES = $(wildcard *.tex) 
DEPENDS = $(patsubst %.Rnw,%.tex,$(RNWFILES)) $(TEXFILES)

RERUN = "(There were undefined references|Rerun to get  citations|cross-references|the bars) (correct|right)|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)" RERUNBIB = "No file.*\.bbl|Citation.*undefined"

all: $(MASTER)

$(MASTER): $(DEPENDS) %.tex: %.Rnw

        R CMD SWEAVE '$<'

%.pdf: %.tex

	@pdflatex $<
	@egrep -c $(RERUNBIB) $*.log && (bibtex $*;pdflatex $<); true
	@egrep $(RERUN) $*.log && (pdflatex $<) ; true
	@egrep $(RERUN) $*.log && (pdflatex $<) ; true

clean:
	@rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
          *.inx *.ps *.dvi *.toc *.out *.lot *~ *.lof *.ttt *.fff \
          *.eps *.pdf
	@rm -f $(patsubst %.Rnw,%.tex,$(RNWFILES))