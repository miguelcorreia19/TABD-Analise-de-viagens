Autores:
up201404877 André Couto Meira
up201405219 Miguel Ribeiro Correia

O diretório contêm:
	-> 'querys.sql',com as querys que criamos para a nossa análise de dados, com perto de 50 querys;
	-> 'res.txt', com o resultado destas mesmas querys;
        -> 'Report.pdf', com a análise dos resultados.

Quanto ao esquema para a criação da tabela datawarehouse, usamos as seguintes tabelas:
+--------------------------+
|          dw_data         |
+--------------------------+
| DATA ID  	               | <- No formato yyyymmddHH
+--------------------------+
| DIA DA SEMANA            |
+--------------------------+
| DIA DO MÊS               |
+--------------------------+
| DIA DO ANO               |
+--------------------------+
| SEMANA DO MÊS            |
+--------------------------+
| SEMANA DO ANO            |
+--------------------------+
| MÊS ATUAL                |
+--------------------------+
| NOME DO MÊS              |
+--------------------------+
| NOME DO MÊS ABREVIADO    |
+--------------------------+
| ANO                      |
+--------------------------+
| HORA                     |
+--------------------------+


Criamos a tabela dw_points com a tabela taxi_stands, à qual juntamos outros pontos de interesse, num total de 90 pontos.
+--------------------------+
|         dw_points        |
+--------------------------+
| PONTO ID  	           |
+--------------------------+
| NOME                     |
+--------------------------+
| TIPO                     |
+--------------------------+
| LOCALIZAÇÃO              |
+--------------------------+


*Não* criamos a tabela dw_taxis porque esta só conteria uma coluna que pode ser substituida pela própria coluna no datawarehouse.
+--------------------------+
|         dw_taxis         |
+--------------------------+
| TAXI ID  	           |
+--------------------------+

	
Decidimos criar 3 tabelas datawarehouse diferentes porque uma viagem:
		-> Pode começar e não acabar num POI; (datawarehouse_initial)
		-> Pode acabar e não começar num POI; (datawarehouse_final)
		-> Começar e acabar num POI.          (datawarehouse_i_f)
Assim permite-nos guardar a localização, em vez de um id, caso não seja um POI.
	
+--------------------------+		+--------------------------+		+--------------------------+
|  datawarehouse_initial   |		|   datawarehouse_final    |		|    datawarehouse_i_f	   |
+--------------------------+		+--------------------------+		+--------------------------+
| SERVIÇO ID  	           |		| SERVIÇO ID  	           |		| SERVIÇO ID  	           |
+--------------------------+		+--------------------------+		+--------------------------+
| DATA INICIAL ID          |		| DATA INICIAL ID          |		| DATA INICIAL ID          |		
+--------------------------+		+--------------------------+		+--------------------------+
| DATA FINAL ID            |		| DATA FINAL ID            |		| DATA FINAL ID            |		
+--------------------------+		+--------------------------+		+--------------------------+
| DURAÇÃO                  |		| DURAÇÃO                  |		| DURAÇÃO                  |		
+--------------------------+		+--------------------------+		+--------------------------+
| DISTÂNCIA                |		| DISTÂNCIA                |		| DISTÂNCIA                |		
+--------------------------+		+--------------------------+		+--------------------------+
| VELOCIDADE               |		| VELOCIDADE               |		| VELOCIDADE               |		
+--------------------------+		+--------------------------+		+--------------------------+
| ORIGEM ID                |		| LOCALIZAÇÃO INICIAL      |		| ORIGEM ID                |		
+--------------------------+		+--------------------------+		+--------------------------+
| LOCALIZAÇÃO FINAL        |		| DESTINO ID               |		| DESTINO ID               |		
+--------------------------+		+--------------------------+		+--------------------------+
| TAXI ID                  |		| TAXI ID                  |		| TAXI ID                  |		
+--------------------------+		+--------------------------+		+--------------------------+


Na criação das datawarehouses criamos uma tabela mais pequena a partir dos caops (dw_caop_porto). 
Essa tabela só continha os polígonos do distrito do porto o que nos permitiu validar as viagens que lá começam de forma mais rápida (durante a criação).
A criação das datawarehouses demora aproximadamente 15 minutos.
Todas as querys são realizadas em menos de 15 segundos, no seu conjunto. 
A exceção é a contagem de serviços para cada distrito.

Com 1346153 dados iniciais, decidimos fazer uma limpeza.
Para tentar minimizar erros, eliminamos serviços, onde assumimos que só são consideradas viagens válidas:
	-> Com tempos superiores a um minuto e meio e inferior a 1 dia;
	-> Com velocidades compreendidas entre 10 km/h e 150 km/h;
	-> Com uma distância superior a 200m.

Após esta limpeza, ficamos com um total de 1005462 serviços.