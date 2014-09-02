MONTH=`date +"%B"`
YEAR=`date +"%Y"`
VERSION=01
DRAFT=draft-ietf-dnsop-dnssec-roadblock-avoidance-$(VERSION).txt

all: draft-ietf-dnsop-dnssec-roadblock-avoidance-$(VERSION).txt check

$(DRAFT): roadblock-avoidance-tmp.xml
	xml2rfc $< $@
	mv roadblock-avoidance-tmp.txt $@

find-long-lines: roadblock-avoidance-tmp.xml
	perl -p -i.bak -e 's/strict="yes"/strict="no"/' roadblock-avoidance-tmp.xml
	DISPLAY= ./xml2rfc.tcl roadblock-avoidance-tmp.xml roadblock-avoidance-tmp.txt
	perl column.just.pl roadblock-avoidance-tmp.txt

roadblock-avoidance-tmp.xml: roadblock-avoidance.xml
	sed -e "s/MONTH/$(MONTH)/;s/YEAR/$(YEAR)/;s/FILLVERSION/$(VERSION)/" $< > $@

clean:
	rm roadblock-avoidance-tmp.xml $(DRAFT)

force: clean
	$(MAKE)

check:
	idnits $(DRAFT)
