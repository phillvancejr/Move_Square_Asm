default: move_square
libs=deps/libraylib.a -framework Cocoa -framework OpenGL -framework IOKit

move_square: move_square.s
	nasm -f macho64 $< && \
	clang -o $@ $(libs) $@.o

.SILENT: clean
clean:
	rm *.o
