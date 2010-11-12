// Configuração de proxy para acessar periódicos de fora da universidade
function FindProxyForURL(url, host) {
	var dominios = ['elsevier.com', 'ieee.org', 'acm.org', 'periodicos.capes.gov.br', 'schoolar.google.com'];
	for (var d in dominios){ if(dnsDomainIs(host, dominios[d])){ return "PROXY proxy.ufc.br:8080"; } }
	return "DIRECT";
}