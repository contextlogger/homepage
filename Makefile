SAKE := ../tools/bin/sake

default : web

-include local/custom.mk

.PHONY : web concepts binaries

concepts :
	mkdir -p contextlogger2
	ruby tools/make-concepts.rb > /tmp/concepts.txt2tags.txt
	../tools/bin/txt2tags --target xhtml --infile /tmp/concepts.txt2tags.txt --outfile contextlogger2/concepts.html --encoding utf-8 --verbose -C homepage/config.t2t

upload-php :
	mkdir -p contextlogger2
	cp -a ../upload-php/upload.php /tmp/
	-rm /tmp/upload.php.html
	cd /tmp && coderay -php -page < upload.php > upload.php.html
	cp -a /tmp/upload.php.html contextlogger2/

html :
	mkdir -p contextlogger2
	$(SAKE) web
	cp -a ../tools/web/hiit.css contextlogger2/
	cp -a ../watchdog/graph/states.png contextlogger2/
	cp -a homepage/*.cpp homepage/*.hpp homepage/*.png homepage/*.jpg homepage/*.diff contextlogger2/
	../tools/bin/txt2tags --target xhtml --infile ../CONTENTS.txt --outfile contextlogger2/contents.html --encoding utf-8 --verbose --toc -C homepage/config.t2t
	tidy -utf8 -eq index.html

web : concepts upload-php html

binaries :
	cd ../launcher && make release
	cd ../watchdog && make release
	cd ../megasis && make release

full : web binaries

apidoc :
	cd ../daemon && make apidoc

rm-apidoc :
	cd ../daemon && make rm-apidoc

all-api : apidoc concepts upload-api rm-apidoc

coderay-install :
	gem install coderay

gem-fix :
	gem sources -a http://production.s3.rubygems.org/
	gem sources -r http://gems.rubyforge.org/
