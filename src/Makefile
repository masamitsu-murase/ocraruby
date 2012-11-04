
OCRA = ocra.bat
SRC = ocra_loader.rb
LIB = ocra_loader_libs.rb
EXE_LITE = ../bin/ocrarubylite.exe
EXE_NORMAL = ../bin/ocraruby.exe
EXE_FULL = ../bin/ocrarubyfull.exe


all: $(EXE_LITE) $(EXE_NORMAL) $(EXE_FULL)

clean:
	-del "$(EXE_LITE)" "$(EXE_NORMAL)" "$(EXE_FULL)"

$(EXE_LITE): $(SRC)
	$(OCRA) $(SRC) --output $(EXE_LITE) -- lite

$(EXE_NORMAL): $(SRC) $(LIB)
	$(OCRA) $(SRC) --output $(EXE_NORMAL) -- normal

$(EXE_FULL): $(SRC)
	$(OCRA) $(SRC) --add-all-core --output $(EXE_FULL) -- full

