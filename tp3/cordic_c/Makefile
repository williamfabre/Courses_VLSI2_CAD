CFLAGS=-Wall -O3 -std=c99 #-DDEBUG
LDFLAGS=-lm

#cercle: cercle.c

plot: cercle
	./cercle
	gnuplot \
            -e 'plot [-128:127] [-128:127] "cordic.dat" with lines;'\
            -e 'replot "cossin.dat" with lines;' \
            -e 'pause -1' 

clean:
	rm *.dat *~ cercle
