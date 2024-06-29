#!/bin/bash
# 检查是否以root用户运行脚本
check_root(){
    if [ "$(id -u)" != "0" ]; then
        echo "此脚本需要以root用户权限运行。"
        echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
        exec bash
    fi
}

check_curl(){
    # 检查curl是否安装，如果没有则安装
    if ! command -v curl > /dev/null; then
        echo "curl 未安装，正在安装..."
        sudo apt update && sudo apt install curl git -y
    fi
}

install_pm2(){
    check_curl
    if command -v node > /dev/null 2>&1; then
        echo "Node.js 已安装"
    else
        echo "Node.js 未安装，正在安装..."
        curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    if command -v npm > /dev/null 2>&1; then
        echo "npm 已安装"
    else
        echo "npm 未安装，正在安装..."
        sudo apt-get install -y npm
    fi
    
    if command -v pm2 > /dev/null 2>&1; then
        echo "PM2 已安装"
    else
        echo "PM2 未安装，正在安装..."
        npm install pm2@latest -g
    fi
}

# 检测节点是否存在，如果存在则重新获取，进行更新
refresh_bash(){
    file_path=~/t_node.sh
    # 检测文件是否存在
    if [ -f "$file_path" ]; then
        # 如果文件存在，删除它
        rm "$file_path"
        echo "文件 $file_path 已删除"
    fi
    wget -O t_node.sh https://raw.githubusercontent.com/xkis666/test_bash/main/start.sh
    echo "文件 $file_path 更新成功"
}

# 运行节点
run_node(){
    refresh_bash
    chmod +x t_node.sh && ./t_node.sh
}

# 设置节点并运行
set_node_and_run(){
    refresh_bash
    
    chmod +x t_node.sh
    pm2 start ~/t_node.sh --name "t_node"
    pm2 save
    pm2 startup
}


active_menu(){
    while true; do
        clear
        echo "============== 自用脚本，擅用致不良后果，概不负责！ =============="
        echo "退出脚本，请按键盘ctrl c退出即可"
        echo "请选择要执行的操作:"
        echo "1. 安装pm2"
        echo "2. 运行节点"
        echo "3. 节点运行并设置开机启动"
        
        read -p "请输入选项（1-3）: " OPTION
        
        case $OPTION in
            1) install_pm2 ;;
            1) run_node ;;
            1) set_node_and_run ;;
            *) echo "无效选项。" ;;
        esac
        echo "按任意键返回主菜单..."
        read -n 1
    done
}

check_root
active_menu