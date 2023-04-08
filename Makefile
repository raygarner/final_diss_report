TITLE=rg_report

all: $(TITLE).ms
	refer -e -S -sA -p ~/docs/roff/bib $(TITLE).ms | \
		groff -ms -e -t -p -Tps > $(TITLE).ps
	ps2pdf $(TITLE).ps temp.pdf
	pdftk temp.pdf cat 1-2 r3 3-r4 r2-r1 output $(TITLE).pdf

wc: $(TITLE).ms
	refer -p ~/docs/roff/bib $(TITLE).ms | groff -e -t -p -ms -a | \
		sed -e '/^</d' | wc -w

clean:
	rm -f *.ps temp.pdf
