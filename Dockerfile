FROM archlinux:latest
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN date
RUN echo "[multilib]" >> /etc/pacman.conf
RUN echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
RUN echo "[archlinuxcn]" >> /etc/pacman.conf
RUN echo 'Server = https://mirrors.ocf.berkeley.edu/archlinuxcn/$arch' >> /etc/pacman.conf
RUN pacman -Syu --noconfirm
RUN pacman-key --init
RUN pacman -Sy archlinux-keyring --noconfirm
RUN pacman -S archlinuxcn-keyring --noconfirm
RUN pacman -S base-devel git  --noconfirm && sed -i '/E_ROOT/d' /usr/bin/makepkg
RUN pacman -S yay jq --noconfirm
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
