#!/bin/bash

# 检查是否提供了源文件目录作为参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 <source_directory>"
    exit 1
fi

# 获取源文件目录
SOURCE_DIR="$1"

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

# 定义制表符
TAB=$'\t'

# 生成 Makefile 内容
MAKEFILE_CONTENT=$(cat <<EOF
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -g
CXXFLAGS = -Wall -Wextra -g

# 目标文件
C_OBJS=$(echo "$C_OBJECTS" | tr '\n' ' ')
CXX_OBJS=$(echo "$CXX_OBJECTS" | tr '\n' ' ')
OBJS=\$(C_OBJS) \$(CXX_OBJS)

# 可执行文件
EXEC = $EXECUTABLE

# 默认目标
all: \$(EXEC)

# 链接规则，根据是否有 C++ 文件选择不同链接方式
ifeq (\$(CXX_OBJS),)
\$(EXEC): \$(C_OBJS)
${TAB}\$(CC) \$(CFLAGS) \$(C_OBJS) -o \$(EXEC)
else
\$(EXEC): \$(OBJS)
${TAB}\$(CXX) \$(CXXFLAGS) \$(OBJS) -o \$(EXEC)
endif

# C 源文件编译规则
%.o: %.c
${TAB}\$(CC) \$(CFLAGS) -c \$< -o \$@

# C++ 源文件编译规则
%.o: %.cpp
${TAB}\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

# 清理规则
clean:
${TAB}rm -f \$(OBJS) \$(EXEC)
EOF
)

# 输出 Makefile 内容到文件
echo "$MAKEFILE_CONTENT" > makefile

echo "Makefile generated successfully."
