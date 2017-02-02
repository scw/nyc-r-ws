short = nyc-r-ws
deck = nyc-r-workshop
event = nyc-r-ws-2017
theme = esri-uc-2016
upload_loc = 4326.us:esri/$(short)
public_loc = https://4326.us/esri/$(short)
slide_dir = $(shell pwd)

all:
	pandoc -t revealjs -s slides.md -V controls=false -V progress=true -V history=true -V center=true -V transition=slide -V theme=$(theme) --css ./src/$(event).css --template=./src/$(event).revealjs --highlight-style=zenburn --slide-level 2 -S -o index.html

check:
	linkchecker --check-extern index.html

pdf:
	pandoc -o $(deck)-presentation-handout.pdf -V fontsize=12pt -V mainfont=Helvetica --latex-engine=xelatex slides.md

fullpdf:
# decktape can't scrape HTTPS URIs with a relative path, swich directories.
# Also scrape very slowly -- want backgrounds rendered.
	cd ~/dev-summit/decktape && bin/phantomjs decktape.js --pause=3000 --url=$(public_loc) --filename=$(slide_dir)/$(deck)-presentation-full.pdf

clean:
	rm index.html $(deck)-presentation-handout.pdf $(deck)-presentation-full.pdf

upload:
	rsync --partial --progress -r . 4326.us:esri/$(short) && open $(public_loc)
