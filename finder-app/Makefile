# Compiler and flags
CC = $(CROSS_COMPILE)gcc
CFLAGS = -Wall -Werror -g

# Target executable
TARGET = writer

# Source files
SRC = writer.c
OBJ = $(SRC:.c=.o)

# Default target: Build the writer application
all: $(TARGET)

# Compile writer application
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Compile source files into object files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Clean target: Remove binary and object files
clean:
	rm -f $(TARGET) $(OBJ)

# PHONY targets
.PHONY: all clean
