# Muda output node do TOR. Se um cctld(country code top level domain) for dado como
# parametro, ele escolhe a saida apenas naquele pais. (Detalhe: descomente
# ControlPort e sete para 9051 no /etc/tor/torrc para funcionar)

if [ -z "$1" ]; then biscoito=""; else biscoito="SETCONF ExitNodes={"$1"}\r\nSETCONF StrictNodes=1\r\n"; fi; echo -e 'AUTHENTICATE ""\r\n'$biscoito'SIGNAL NEWNYM\r\nQUIT' | nc localhost 9051 ; }