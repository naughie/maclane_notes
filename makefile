TEX = latexmk
TARDIR = ./docs/maclane
TARGET = $(TARDIR)/categories_for_the_working_mathematicians.pdf
MESSAGE = "Snapshot at `date -R`"
ORIGIN = origin
BRANCH = master
GIT = git
GITADD = add $(TARGET)
GITCOM = commit -m $(MESSAGE)
GITPUSH = push $(ORIGIN) $(BRANCH)

SCRIPTDIR = ./script
SCPIPT = $(SCRIPTDIR)/convert.rb
CONVERT = ruby $(SCRIPT)

all: conv git

conv:
	$(CONVERT)

git:
	$(GIT) $(GITADD) && \
	$(GIT) $(GITCOM) && \
	$(GIT) $(GITPUSH)
