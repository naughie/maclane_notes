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

git:
	$(GIT) $(GITADD) && \
	$(GIT) $(GITCOM) && \
	$(GIT) $(GITPUSH)
