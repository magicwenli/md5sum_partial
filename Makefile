
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS = -lm

TARGET = md5sum_partial
SRC = md5sum.c
OBJ = $(SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(TARGET) $(LDFLAGS)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $(SRC)

clean:
	rm -f $(OBJ) $(TARGET)

tests:
	chmod +x ./test/test_md5sum.sh
	./test/test_md5sum.sh