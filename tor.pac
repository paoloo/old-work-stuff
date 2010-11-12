// Configuração de proxy para usar o TOR apenas para acessar os hidden services e não para navegacao normal

function FindProxyForURL(url, host) {
	if (dnsDomainIs(host, ".onion")) { return "SOCKS localhost:9050"; } else { return "DIRECT"; }
}