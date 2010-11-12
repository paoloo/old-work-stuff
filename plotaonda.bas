' -- plotador de onda na tela, com aquisição via P2 do microfone

CONST SoundBlaster = &H220
CONST comando = SoundBlaster + &HC
CONST dados = SoundBlaster + &HA
DEFINT A-Z
DIM Ponto(640) 'resolucao 640x480 na screen 12
SCREEN 12
DO
  OUT comando, &H20 'envia comando de leitura da placa de som(microfone)
  PRESET (i, Ponto(i)) 'zera o array Ponto
  Ponto(i) = INP(dados) 'le do microfone
  PSET (i, Ponto(i)) 'plota o pixel
  i = (i + 1) MOD 640
LOOP