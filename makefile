TARDIR = ./docs/maclane
CHAPTERS = 2 3
TARGET = $(wildcard $(TARDIR)/*.pdf)
MESSAGE = "Snapshot at `date -R`"
ORIGIN = origin
BRANCH = master
GIT = git
GITADD = add $(TARGET)
GITCOM = commit -m $(MESSAGE)
GITPUSH = push $(ORIGIN) $(BRANCH)

SCRIPTDIR = ./script
SCRIPT = $(SCRIPTDIR)/convert.rb
CONVERT = ruby $(SCRIPT) $(CHAPTERS)

all: conv git

conv:
	$(CONVERT)

git:
	$(GIT) $(GITADD) && \
	$(GIT) $(GITCOM) && \
	$(GIT) $(GITPUSH)
