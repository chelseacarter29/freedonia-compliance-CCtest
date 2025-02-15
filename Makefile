# This makefile provides some shortcuts to generating update documents
# based on any changes in the input files. Typical usage to make a
# PDF complete from all sources:
#    `make clean pdf`
# or likewise for serving the content:
#    `make clean serve`
#
# FIXME: Add rules so generated files are compared instead of their directories

CM = compliance-masonry
GB = gitbook

# GNU Make trick from
#   http://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
EXECUTABLES = $(CM) $(GB)
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH")))

default: pdf

clean:
	rm -rf exports/ opencontrols/

pdf: exports
	cd exports && gitbook pdf ./ ../assets/example.pdf

serve: exports
	cd exports && gitbook serve

exports: opencontrols
	${CM} docs gitbook fedramp-moderate

opencontrols: opencontrol.yaml */component.yaml markdowns/*/*md markdowns/*md
	-${CM} get

coverage:
	${CM} diff fedramp-moderate
