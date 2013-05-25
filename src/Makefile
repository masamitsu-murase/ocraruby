
#
# Prepare:
#  1. Copy AutoItX3.dll to ruby\bin.
#  2. Copy ruby.exe.manifest to ruby\bin.
#

OCRA = ocra.bat
SRC = ocra_loader.rb
LIB = ocra_loader_libs.rb
ICON = --icon ocraruby.ico
EXE_LITE = ../bin/ocrarubylite.exe
EXE_NORMAL = ../bin/ocraruby.exe
EXE_FULL = ../bin/ocrarubyfull.exe
DLL_FULL = --dll libeay32.dll --dll libgdbm-3.dll --dll libgdbm_compat-3.dll \
           --dll libiconv-2.dll --dll pdcurses.dll --dll ssleay32.dll \
           --dll tcl85.dll --dll tclpip85.dll --dll tk85.dll


all: $(EXE_LITE) $(EXE_NORMAL) $(EXE_FULL)

clean:
	-del "$(EXE_LITE)" "$(EXE_NORMAL)" "$(EXE_FULL)"

$(EXE_LITE): $(SRC)
	$(OCRA) $(SRC) $(ICON) --output $(EXE_LITE) -- lite

$(EXE_NORMAL): $(SRC) $(LIB)
	$(OCRA) $(SRC) --dll AutoItX3.dll --dll ruby.exe.manifest $(ICON) --output $(EXE_NORMAL) -- normal

$(EXE_FULL): $(SRC)
	$(OCRA) $(SRC) --dll AutoItX3.dll --dll ruby.exe.manifest $(DLL_FULL) --add-all-core $(ICON) --output $(EXE_FULL) -- full

