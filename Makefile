#
# A Makefile for GTK tests
#

######

PATSHOMEQ="$(PATSHOME)"
PATSHOMERELOCQ="$(PATSHOMERELOC)"

######

PATSCC=$(PATSHOMEQ)/bin/patscc
GTKFLAGS=`pkg-config gtk+-2.0 --cflags --libs`

######

ENIGMADEPS=Enigma.dats Enigma_letter.dats Enigma_map.dats \
	   Enigma_plugboard.dats Enigma_reflector.dats Enigma_rotor.dats

######

all:: \
TextProcessing
TextProcessing: \
TextProcessing.dats TextProcessing_toplevel.dats $(ENIGMADEPS) ; \
  $(PATSCC) -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -I$(PATSHOMERELOCQ)/contrib -o $@ $^ $(GTKFLAGS)
test: $(ENIGMADEPS) Enigma_test.dats ; \
  $(PATSCC) -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -I$(PATSHOMERELOCQ)/contrib -o $@ $^
cleanall:: ; $(RMF) TextProcessing test

PATS2XHTML=$(PATSHOME)/bin/pats2xhtml
%_sats.html: %.sats ; $(PATS2XHTML) -o $@ -s $<
%_dats.html: %.dats ; $(PATS2XHTML) -o $@ -d $<

######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.o
clean:: ; $(RMF) *_?ats.c

cleanall:: clean

###### end of [Makefile] ######

