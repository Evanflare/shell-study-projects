#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址
passwordFilePath=${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
readonly passwordFilePath

echo "please input key words: "
read keyword
# 获取字符串变量的长度，就是${#变量名}
while [ ${#keyword} -gt 0 ]; do
    echo '----------search results begin----------'
    # 搜索,额外显示关键词后的3行
    grep -A 3 $keyword $passwordFilePath
    echo '==========search results end============='
    echo "please input keywords: "
    read keyword
done