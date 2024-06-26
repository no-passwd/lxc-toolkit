# lxc-toolkit
lxc系统检测工具,概念验证。用于获取lxc宿主信息。

## 使用方法
```bash
wget https://github.com/no-passwd/lxc-toolkit/archive/refs/heads/main.zip
unzip main.zip
cd lxc-toolkit-main
#bash lxc-toolkit.sh -h
bash lxc-toolkit.sh all
```

或者 

```bash
git clone https://github.com/no-passwd/lxc-toolkit.git
cd lxc-toolkit
#bash lxc-toolkit.sh -h
bash lxc-toolkit.sh all
```

### 命令参数

```bash
bash lxc-toolkit.sh free -> 查看宿主机free -m
bash lxc-toolkit.sh fdisk -> 查看宿主机fdisk
bash lxc-toolkit.sh swapon -> 查看宿主机swapon
bash lxc-toolkit.sh uptime -> 查看宿主机uptime
bash lxc-toolkit.sh load -> 查看宿主机load负载
bash lxc-toolkit.sh top -> 查看宿主机processes统计
bash lxc-toolkit.sh cpu -> 查看宿主机cpu核心
bash lxc-toolkit.sh all -> 同时运行上述所有的命令
```

其他组件（其他调用实现，最低权限也可调用）

```python
wget https://raw.githubusercontent.com/no-passwd/lxc-toolkit/main/free
chmod +x free
./free -m
#Like free -m
```

### 原理
直接使用系统调用，从内核获取信息。由于lxc与宿主机是同一个内核。可以获取到宿主机信息。

可以看test.c的例子。从系统调用中获取信息，而不是/proc文件系统。

## License
MIT License
