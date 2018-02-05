export BIBLE_VERSION = kjv
BTF_DIRECTORY = btf

web: vars files books index search glimpse

vars files books index search glimpse txt brf:
	bin/bible-mk$@

btf-directory:
	mkdir -p $(BTF_DIRECTORY)

btf: btf-directory
	cd $(BTF_DIRECTORY) && ../bin/bible-mk$@

pdb plain html rtf thml monoon sword: btf-directory btf
	cd $(BTF_DIRECTORY) && ../bin/bible-cvbtf -q -$@ $(BIBLE_VERSION)

clean:
	-rm -f -r bible-*
	-rm -f -r $(BTF_DIRECTORY)

