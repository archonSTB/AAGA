TARGET= aaga

SIZE= 1000

SRCDIR= ./src
OBJDIR= ./obj
LIBDIR= ./lib
BINDIR= ./bin
DOTDIR= ./dot

CC = gcc
CFLAGS = -Wall -Wextra -Wimplicit -std=c11 -g

LINKER = gcc -o
LFLAGS = -Wall -lm -lgmp


SOURCES := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
OBJECTS := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

DOTFILE= tree

rm = rm -f

all: remove $(OBJECTS) $(TARGET)

$(TARGET): $(BINDIR)/$(TARGET)

$(BINDIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@$(LINKER) $@ $(OBJECTS) $(LFLAGS) 2>> log 
	@if [ -s ./log ]; then echo -e "\e[33mErrors or warnings present!\e[0m"; fi;
	@echo -e Compiling Complete! >> log
	@echo -e "\e[32mLinking complete!\e[0m"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	@$(CC) $(CFLAGS) -c $< -o $@ 2>>log
	@echo -e "\e[34mCompiled "$<" successfully!\e[0m"

run: $(BINDIR)/$(TARGET)
	@echo -e "\e[33mGenerating PDF from DOT\e[0m"
	@./$(BINDIR)/$(TARGET) $(SIZE) $(DOTDIR)/$(DOTFILE).dot
	@dot -Tpdf $(DOTDIR)/$(DOTFILE).dot -o $(DOTDIR)/$(DOTFILE).pdf;
	@echo -e "\e[32mPDF generation done!\e[0m"

.PHONEY: clean remove clear_log ps_dot

clear_log:
	@echo ""
	@rm -f log

clean:  clear_log
	@$(rm) $(OBJECTS)
	@echo -e "\e[33mLog and object files cleanup complete!\e[0m"

remove: clean
	@$(rm) $(BINDIR)/$(TARGET)
	@$(rm) $(DOTDIR)/*
	@echo -e "\e[31mExecutable and Generated files removed!\e[0m"
	@echo ""

pdf:
	@echo -e "\e[33mGenerating PDF from DOT\e[0m"
	@if [ ! -f $(DOTDIR)/$(DOTFILE).dot ];\
	then echo -e "\e[31mDOT file does not exist\e[0m";\
	else dot -Tpdf $(DOTDIR)/$(DOTFILE).dot -o $(DOTDIR)/$(DOTFILE).pdf;\
	fi;
	@echo -e "\e[32mPDF generation done!\e[0m"
