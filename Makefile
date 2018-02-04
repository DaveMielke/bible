all: vars files books index search glimpse

vars files books index search glimpse:
	bin/bible-mk$@

clean:
	-rm -f -r bible-*

