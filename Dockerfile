FROM archlinux:latest
RUN echo '[archlinuxcn]\nSigLevel = TrustAll\nServer = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
RUN pacman -Syu base-devel git yay --noconfirm && sed -i '/E_ROOT/d' /usr/bin/makepkg
COPY entrypoint.sh /entrypoint.sh
COPY pkgs /inner-pkgs
ENTRYPOINT ["/entrypoint.sh"]
