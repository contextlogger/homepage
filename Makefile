SAKE := ../tools/bin/sake

default : html

-include local/custom.mk

binaries :
	cd ../launcher && make release
	cd ../watchdog && make release
	cd ../megasis && make release

.PHONY : web copying concepts

copying :
	cp ../watchdog/graph/states.png web/

concepts :
	ruby tools/make-concepts.rb > web/concepts.txt2tags.txt

upload-php :
	cp -a ../upload-php/upload.php /tmp/
	-rm /tmp/upload.php.html
	cd /tmp && coderay -php -page < upload.php > upload.php.html
	cp -a /tmp/upload.php.html web/

coderay-install :
	gem install coderay

gem-fix :
	gem sources -a http://production.s3.rubygems.org/
	gem sources -r http://gems.rubyforge.org/

html :
	$(SAKE) web
	tools/txt2tags --target xhtml --infile ../CONTENTS.txt --outfile web/contents.html --encoding utf-8 --verbose --toc -C web/config.t2t
	tidy -utf8 -eq web/index.html

web : copying concepts upload-php html

full : web binaries

apidoc :
	cd ../daemon && make apidoc

rm-apidoc :
	cd ../daemon && make rm-apidoc

all-api : apidoc concepts upload-api rm-apidoc
