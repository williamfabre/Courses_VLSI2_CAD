#Makfile for my latex
all : main.pdf

#jobmindmap.pdf : jobmindmap.svg
	#rsvg-convert -f pdf -o $@ $<

main.pdf : main.tex 
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make $<

clean:
	latexmk -C
