FROM archlinux:base-devel

# WORKAROUND for glibc 2.33 and old Docker
# See https://github.com/actions/virtual-environments/issues/2658
# Thanks to https://github.com/lxqt/lxqt-panel/pull/1562
#RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
#    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
#    bsdtar -C / -xvf "$patched_glibc"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN date
RUN echo "[multilib]" >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
RUN echo "[archlinuxcn]" >> /etc/pacman.conf
# RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
RUN echo 'Server = https://repo.archlinuxcn.org/$arch' >> /etc/pacman.conf
RUN useradd -m -p 123456 packer
RUN pacman -Syu --noconfirm
RUN pacman-key --init
RUN pacman -Sy archlinux-keyring --noconfirm
RUN pacman-key --lsign-key "farseerfc@archlinux.org"
RUN pacman -S archlinuxcn-keyring --noconfirm
RUN pacman -S base-devel git  --noconfirm
RUN pacman -S sudo yay jq paru nushell tree --noconfirm
RUN echo 'packer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
COPY entrypoint.nu /entrypoint.nu
ENTRYPOINT ["/entrypoint.nu"]
