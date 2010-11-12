# $Id: tapioquita.py,v 0.1a 2011/02/19 19:01:23 paoloo Exp $
# GAMBIARRA para enviar email via ssmtp, fakeando um daemon, necessario para intranet enviar emails via php

import smtpd     # modolo padrao smtp do python (para extender)
import asyncore  # para o controle de thread do modulo smtpd
import md5,os    # para o POG de pegar arquivo randomico

class CustomSMTPServer(smtpd.SMTPServer):
	def process_message(self, peer, mailfrom, rcpttos, data):
		nomeArq = '/tmp/%s.mail' % md5.new(open('/dev/urandom').read(21)).hexdigest()[:20]
		arquivo = open(nomeArq,'w')
		arquivo.write(data)
		arquivo.close()
		os.system('ssmtp %s < %s' % (rcpttos[0],nomeArq))
		os.remove(nomeArq)
		return

server = CustomSMTPServer(('127.0.0.1', 1025), None)
asyncore.loop()
