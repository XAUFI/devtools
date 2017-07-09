FROM xaufi/ubuntu-16.04:stable
MAINTAINER David Bautista <dbautistav@gmail.com>

# CREATE NON-ROOT USER
RUN useradd -ms /bin/bash devuser
RUN chown -R devuser:devuser /home/devuser/. && \
  echo "devuser:devuser" | chpasswd
RUN mkdir -p /home/devuser
RUN mkdir -p /home/devuser/.tmp
RUN cp /root/.bashrc /home/devuser/.bashrc
RUN chown -R devuser:devuser /home/devuser/.

# CONFIGURATION
USER devuser
SHELL ["bash", "-c"]
WORKDIR /home/devuser/.tmp
RUN git config --global core.editor "vim"
RUN git config --global push.default simple
RUN git config --global color.ui true
#RUN chown devuser ~/.gitconfig
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
RUN wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
RUN mkdir -p ~/.fonts
RUN mv PowerlineSymbols.otf ~/.fonts/
RUN fc-cache -vf ~/.fonts/
RUN mkdir -p ~/.config/fontconfig/conf.d/
RUN mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

WORKDIR /home/devuser

CMD ["zsh"]
