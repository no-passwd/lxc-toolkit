#!/usr/bin/env bash
#licensed by MIT
#https://github.com/no-passwd/lxc-toolkit
os="none"
vm="none"

if [ -n "$BASH_VERSION" ]; then
    echo "lxc-toolkit.sh v1.1"
else
	echo -e "\033[31m请使用bash运行脚本,不是sh\033[0m"
    echo "bash lxc-toolkit.sh"
	exit
fi

if [ $# -lt 1 ]; then
	echo -e "\033[31m错误：请输入参数\033[0m"
    echo "常见参数: "
	echo "lxc-toolkit.sh free -> 查看宿主机free -m"
	echo "lxc-toolkit.sh fdisk -> 查看宿主机fdisk"
	echo "lxc-toolkit.sh swapon -> 查看宿主机swapon"
	echo "lxc-toolkit.sh uptime -> 查看宿主机uptime"
	echo "lxc-toolkit.sh load -> 查看宿主机load负载"
	echo "lxc-toolkit.sh top -> 查看宿主机processes统计"
	echo "lxc-toolkit.sh cpu -> 查看宿主机cpu核心"
	echo "lxc-toolkit.sh all -> 同时运行上述所有的命令"
    exit 1
fi

ty=$1

if [ "$ty" == "h" ] ; then
    echo "常见参数: "
	echo "lxc-toolkit.sh free -> 查看宿主机free -m"
	echo "lxc-toolkit.sh fdisk -> 查看宿主机fdisk"
	echo "lxc-toolkit.sh swapon -> 查看宿主机swapon"
	echo "lxc-toolkit.sh uptime -> 查看宿主机uptime"
	echo "lxc-toolkit.sh load -> 查看宿主机load负载"
	echo "lxc-toolkit.sh top -> 查看宿主机processes统计"
	echo "lxc-toolkit.sh cpu -> 查看宿主机cpu核心"
	echo "lxc-toolkit.sh all -> 同时运行上述所有的命令"
    exit 1
fi
if [ "$ty" == "help" ] ; then
    echo "常见参数: "
	echo "lxc-toolkit.sh free -> 查看宿主机free -m"
	echo "lxc-toolkit.sh fdisk -> 查看宿主机fdisk"
	echo "lxc-toolkit.sh swapon -> 查看宿主机swapon"
	echo "lxc-toolkit.sh uptime -> 查看宿主机uptime"
	echo "lxc-toolkit.sh load -> 查看宿主机load负载"
	echo "lxc-toolkit.sh top -> 查看宿主机processes统计"
	echo "lxc-toolkit.sh cpu -> 查看宿主机cpu核心"
	echo "lxc-toolkit.sh all -> 同时运行上述所有的命令"
    exit 1
fi
if [ "$ty" == "-h" ] ; then
    echo "常见参数: "
	echo "lxc-toolkit.sh free -> 查看宿主机free -m"
	echo "lxc-toolkit.sh fdisk -> 查看宿主机fdisk"
	echo "lxc-toolkit.sh swapon -> 查看宿主机swapon"
	echo "lxc-toolkit.sh uptime -> 查看宿主机uptime"
	echo "lxc-toolkit.sh load -> 查看宿主机load负载"
	echo "lxc-toolkit.sh top -> 查看宿主机processes统计"
	echo "lxc-toolkit.sh cpu -> 查看宿主机cpu核心"
	echo "lxc-toolkit.sh all -> 同时运行上述所有的命令"
    exit 1
fi
if [ "$ty" == "--h" ] ; then
    echo "常见参数: "
	echo "lxc-toolkit.sh free -> 查看宿主机free -m"
	echo "lxc-toolkit.sh fdisk -> 查看宿主机fdisk"
	echo "lxc-toolkit.sh swapon -> 查看宿主机swapon"
	echo "lxc-toolkit.sh uptime -> 查看宿主机uptime"
	echo "lxc-toolkit.sh load -> 查看宿主机load负载"
	echo "lxc-toolkit.sh top -> 查看宿主机processes统计"
	echo "lxc-toolkit.sh cpu -> 查看宿主机cpu核心"
	echo "lxc-toolkit.sh all -> 同时运行上述所有的命令"
    exit 1
fi

if [ "$(id -u)" != 0 ] ;then
echo -e "\033[31m未使用root权限运行，无法获取系统信息\033[0m"
exit 0
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
if [ "$ID" = "alpine" ]; then
        #系统是 Alpine Linux。
		os="alpine"
else
        #系统不是 Alpine Linux。
		os="debian"
fi
else
    #/etc/os-release 文件不存在。将就用debian。其他系统暂时未考虑
	os="debian"
fi

#检测alpine的lxc，其实还有更好的方法。暂时没用
if [ "$os" == "alpine" ]; then
if grep -qa container=lxc /proc/1/environ; then
	vm="lxc"
elif grep -qa lxc /proc/1/cgroup; then
    vm="lxc"
else
    vm="kvm"
fi
fi

if [ "$os" == "debian" ] ;then
if command -v systemd-detect-virt >/dev/null 2>&1; then
    echo "正在检测环境..."
if systemd-detect-virt -q; then
    vm=$(systemd-detect-virt)
else
    vm="none"
fi
else
    apt-get install -y virt-what
	getvm=$(virt-what)
if [[ "$getvm" == *"lxc"* ]]; then
    vm="lxc"
else
    vm="none"
fi
fi
fi

if [ "$vm" != "lxc" ]
then
echo -e "\033[31m虚拟化为 $vm 不是lxc,该脚本对非lxc系统无意义\033[0m"
exit 0
fi

echo -e "\033[32m正在检测挂载点...\033[0m"
read -r device mountpoint fstype rest < /etc/mtab
echo "挂载点设备名: $device"
echo "挂载点: $mountpoint"
echo "文件系统类型: $fstype"

mnt="none"
if [ "$mountpoint" == "/" ]; then
if [[ "$device" == *loop* ]]; then
    mnt="loop"
fi
fi

if [ "$vm" == "lxc" ]
then
echo -e "\033[32m开始检测宿主机系统信息...\033[0m"
chmod 755 lxc-check
if [ "$mnt" == "loop" ] ;then
if [[ -x "./lxc-check" ]]; then
if [ "$ty" == "all" ] ; then
./lxc-check -c -m -d -s -l -p -u
fi
if [ "$ty" == "free" ] ; then
./lxc-check -m
fi
if [ "$ty" == "fdisk" ] ; then
./lxc-check -d
fi
if [ "$ty" == "swapon" ] ; then
./lxc-check -s
fi
if [ "$ty" == "uptime" ] ; then
./lxc-check -u
fi
if [ "$ty" == "load" ] ; then
./lxc-check -l
fi
if [ "$ty" == "top" ] ; then
./lxc-check -p
fi
if [ "$ty" == "cpu" ] ; then
./lxc-check -c
fi
else
   echo -e "\033[31m缺少检测配置文件，退出...\033[0m"
fi
else
if [[ -x "./lxc-check" ]]; then
if [ "$ty" == "all" ] ; then
./lxc-check -c -m -s -l -p -u
fi
if [ "$ty" == "free" ] ; then
./lxc-check -m
fi
if [ "$ty" == "fdisk" ] ; then
mount
fi
if [ "$ty" == "swapon" ] ; then
./lxc-check -s
fi
if [ "$ty" == "uptime" ] ; then
./lxc-check -u
fi
if [ "$ty" == "load" ] ; then
./lxc-check -l
fi
if [ "$ty" == "top" ] ; then
./lxc-check -p
fi
if [ "$ty" == "cpu" ] ; then
./lxc-check -c
fi
else
    echo -e "\033[31m缺少检测配置文件，退出...\033[0m"
fi
fi
else
echo -e "\033[31m系统不是lxc,退出...\033[0m"
exit 0
fi