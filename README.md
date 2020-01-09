># ● Ping FTP

Autor: Dhaniel Ricardo

O Script tem como objetivo ***balancear*** a escolha de um link, de acordo com seu ***ms*** em um ping.

Esse Ping é composto de 5 tentativas e envio de pacotes, caso uma delas falhe, o link em questão será descartado naquele momento da possibilidade de escolha, para evitar qualquer perca, mesmo estando com ***ms*** baixo.

Caso todos os links estejam ***perdendo pacotes*** naquele momento, o script balanceará o link para o que estiver perdendo menos pacotes, mesmo com ***ms mais alto***, pois será o mais seguro mesmo com alguma demora. 

Todas as ***operações do script*** são armazenadas em um arquivo de log chamado ***ftp.log***, para consultas posteriores. datados e organizados por operação.

Esse script é *livre* e seus desenvolvedores encorajam as práticas de DevOps.
