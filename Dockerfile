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
RUN chown devuser ~/.gitconfig
##COPY tmux.conf ~/.tmux.conf
##RUN chown devuser ~/.tmux.conf
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
RUN wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
RUN wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
RUN mkdir -p ~/.fonts
RUN mv PowerlineSymbols.otf ~/.fonts/
RUN fc-cache -vf ~/.fonts/
RUN mkdir -p ~/.config/fontconfig/conf.d/
RUN mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

WORKDIR /home/devuser

RUN echo 'source ~/.bashrc' > ~/.bash_profile
RUN echo 'source ~/.bashrc' > ~/.profile

RUN git clone https://github.com/creationix/nvm.git ~/.nvm
#RUN cd ~/.nvm
WORKDIR /home/devuser/.nvm
RUN git checkout v0.33.2
WORKDIR /home/devuser
RUN exec $SHELL
RUN . ~/.bashrc

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc

RUN exec $SHELL
RUN . ~/.bashrc

RUN echo $NVM_DIR
RUN echo `command -v nvm`
#RUN nvm install --lts
#RUN nvm use --lts
#RUN nvm ls
#RUN node -v
##RUN echo '. ~/.nvm/nvm.sh' >> ~/.bashrc

### FINAL TWEAKS
##USER devuser
#RUN npm install -g yarn

EXPOSE 80

#ENTRYPOINT ["/bin/bash"]
#CMD ["-c"]

CMD ["/bin/bash", "-c"]
