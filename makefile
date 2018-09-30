TARDIR = ./docs/maclane
CHAPTERS = 2 3 3_2
TARGET = $(wildcard $(TARDIR)/*.pdf)
MESSAGE = "Snapshot at `date -R`"
ORIGIN = origin
BRANCH = master
GIT = git
GITADD = add
GITCOM = commit -m $(MESSAGE)
GITPUSH = push $(ORIGIN) $(BRANCH)

SCRIPTDIR = ./script
SCRIPT = $(SCRIPTDIR)/convert.rb
CONVERT = ruby $(SCRIPT)

NOTEDIR = ./tex
NOTEPDF = $(NOTEDIR)/.target/note.pdf

all: conv git

conv:
	$(CONVERT)

git:
	$(GIT) $(GITADD) $(TARGET) && \
	$(GIT) $(GITCOM) && \
	$(GIT) $(GITPUSH)


define convOneFile
cp$(1):
	cp $(NOTEPDF) $(TARDIR)/$(1).pdf

conv$(1):
	$(CONVERT) $(1)

git$(1):
	$(GIT) $(GITADD) $(TARDIR)/$(1).pdf && \
	$(GIT) $(GITCOM) && \
	$(GIT) $(GITPUSH)
endef

$(foreach chap,$(CHAPTERS),$(eval $(call convOneFile,$(chap))))

2: conv2 git2

3: cp3 conv3 git3

3_2: conv3_2 git3_2
