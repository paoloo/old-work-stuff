' ============= über-micro-simples leitor de smartcards =============
'  1 -- +--- 5   pinagem SC/paralela  25 /+-+-+-+-+-+-+-+ * * * *\ 14
'  2 -- | -- 6      Vcc(1) - (9)D7    13/* * * * + + * * * + + + *\1
'  3 -- | -- 7      R/W(2) - (4)D2
'  4 -- | -- 8    Clock(3) - (2)D0
'                 reset(4) - (3)D1
'                   gnd(5) - (18-25)gnd
'                   Vpp(6) - (8)D6
'                   I/O(7) - (11)BUSY
'
' O leitor é bem simples e não usa alimentacao externa. Lê os 256 bits de um smartcard.
' Paolo Oliveira, Fevereiro de 2005

ca% = 0: cb% = 0: TX% = &H378: RX% = &H379
PRINT "lendo o conteudo do smartcard de 0-255"
OUT TX%, &H80  '10000000
SOUND 0, (18.2 / 10)
OUT TX%, &HC0  '11000000
OUT TX%, &HC1  '11000001
OUT TX%, &HC0  '11000000
al = INP(RX%)
IF ((NOT al) AND 2) = 2 THEN
 PRINT "1";
ELSE
 PRINT "0";
END IF
contador% = 255
OUT TX%, &HC2  '11000010
a: OUT TX%, &HC3  '11000011
OUT TX%, &HC1  '11000001
al = INP(RX%)
IF ((not al) AND 1) = 1 THEN
 PRINT "1";
ELSE
 PRINT "0";
END IF
cb% = cb% + 1
IF cb% = 8 THEN PRINT " "; : cb% = 0: ca% = ca% + 1
IF ca% = 8 THEN PRINT : ca% = 0
contador% = contador% - 1
IF contador% = 0 THEN GOTO b
GOTO a
b: PRINT : END