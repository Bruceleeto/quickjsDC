#
# QuickJS Javascript Engine
# 
# Copyright (c) 2017-2021 Fabrice Bellard
# Copyright (c) 2017-2021 Charlie Gordon
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


CC=kos-cc
AR=kos-ar

# Compiler Flags
CFLAGS=-Os -Wall -MMD -MF .obj/$(@F).d -D_GNU_SOURCE -DCONFIG_VERSION=\"1.5\" -std=c99
ifdef CONFIG_BIGNUM
CFLAGS += -DCONFIG_BIGNUM
endif
LDFLAGS=-g $(KOS_LDFLAGS) -lm

OBJDIR=.obj

QJS_LIB_OBJS=$(OBJDIR)/quickjs.o $(OBJDIR)/libregexp.o $(OBJDIR)/libunicode.o $(OBJDIR)/cutils.o $(OBJDIR)/quickjs-libc.o
ifdef CONFIG_BIGNUM
QJS_LIB_OBJS+=$(OBJDIR)/libbf.o
endif

#  Static Library
libquickjs.a: $(QJS_LIB_OBJS)
	$(AR) rcs $@ $^

# Rule to Compile .c to .o
$(OBJDIR)/%.o: %.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# Create Object Directory
$(OBJDIR):
	mkdir -p $(OBJDIR)

# Include dependencies
-include $(wildcard $(OBJDIR)/*.d)

# Clean up
clean:
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*.d libquickjs.a
