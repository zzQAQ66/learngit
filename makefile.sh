#!/bin/bash

# 检查是否提供了源文件目录作为参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 <source_directory>"
    exit 1
fi

# 获取源文件目录
SOURCE_DIR=$1

# 检查目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR does not exist."
    exit 1
fi

# 查找源文件
C_SOURCES=$(find "$SOURCE_DIR" -name "*.c")
CXX_SOURCES=$(find "$SOURCE_DIR" -name "*.cpp")

# 生成目标文件列表
C_OBJECTS=$(echo "$C_SOURCES" | sed 's/\.c/\.o/g')
CXX_OBJECTS=$(echo "$CXX_SOURCES" | sed 's/\.cpp/\.o/g')

# 生成可执行文件名称
EXECUTABLE="a"

# 生成 Makefile 内容
MAKEFILE_CONTENT="CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g
CXXFLAGS = -Wall -Wextra -g

# 目标文件
OBJS=$(echo "$C_OBJECTS $CXX_OBJECTS" | tr '\n' ' ')

# 可执行文件
EXEC = $EXECUTABLE

# 默认目标
all: \$(EXEC)

# 链接规则
\$(EXEC): \$(OBJS)
	\$(CXX) \$(CXXFLAGS) \$(OBJS) -o \$(EXEC)

# C 源文件编译规则
%.o: %.c
	\$(CC) \$(CFLAGS) -c \$< -o \$@

# C++ 源文件编译规则
%.o: %.cpp
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

# 清理规则
clean:
	rm -f \$(OBJS) \$(EXEC)"

# 输出 Makefile 内容到文件
echo "$MAKEFILE_CONTENT" > makefile

echo "Makefile generated successfully."
