# Bash script para enviar uma menssagem para um canal/usuario no IRC e depois desconectar.

( echo NICK $NICK; echo USER $NICK \* \* :$NICK; sleep 1; echo JOIN \#$CANAL; echo PRIVMSG \#$CANAL :$MSG; echo QUIT :$MSG; sleep 10; ) | nc $IRC_SERVER $IRC_PORT &>/dev/null