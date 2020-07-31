FROM archlinux:latest
RUN echo "[archlinuxcn]" >> /etc/pacman.conf
RUN echo "SigLevel = TrustAll" >> /etc/pacman.conf
RUN echo 'Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
RUN pacman -Syu base-devel git  --noconfirm && sed -i '/E_ROOT/d' /usr/bin/makepkg
RUN pacman -S yay --noconfirm
COPY entrypoint.sh /entrypoint.sh
COPY pkgs /inner-pkgs
ENTRYPOINT ["/entrypoint.sh"]
