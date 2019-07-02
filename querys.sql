select 'INICIO ANÁLISE' as mensagem;



select 'quantidade de dados iniciais' as nota;
select count(*) from taxi_services;
select 'quantidade de dados depois de limpeza' as nota;
select count(*) from datawarehouse;
select 'viagens que se iniciam em praça ou poi' as nota;
select count(*) from datawarehouse_initial;
select 'viagens que terminam em praça ou poi' as nota;
select count(*) from datawarehouse_final;
select 'viagens que iniciam e terminam em praça ou poi' as nota;
select count(*) from datawarehouse_i_f;
select 'quantidade de praças/pois' as nota;
select count(*) from (select distinct dw_points.name from dw_points) as tmp;
select 'total de kms' as nota;
select round(sum(metros)/1000,2) from datawarehouse;



select 'PANORAMA GERAL' as label;

select 'visão geral semanal' as label;
select d.day_of_week,
       d.hour,
       count(*) 
  from datawarehouse as dw1 
  join dw_date as d 
    on dw1.id_data_inicial = d.id 
 group by 1,2 
 order by 1,2 asc;

select 'visao geral anual' as label;
select d.day_of_year,
       count(*) 
  from datawarehouse as dw1 
  join dw_date as d 
    on dw1.id_data_inicial = d.id 
 group by 1 
 order by 1 asc;


select 'velocidades segunda a sexta' as label;
select d.hour, 
       avg(v) 
  from datawarehouse as dw 
  join dw_date as d 
    on d.id=dw.id_data_inicial 
 where d.day_of_week > 0 
   and d.day_of_week < 6 
 group by 1
 order by 1 asc;

select 'velocidades fim de semana' as label;
select d.hour, 
       avg(v) 
  from datawarehouse as dw 
  join dw_date as d 
    on d.id=dw.id_data_inicial 
 where d.day_of_week < 1 
    or d.day_of_week > 5 
 group by 1
 order by 1 asc;



select 'PONTOS' as label;



select 'mais serviços a partir de uma praça/poi' as mensagem;
select dw_points.name, 
       count(*) 
  from datawarehouse_initial as dw 
  join dw_points on dw.id_local_inicial = dw_points.id 
 group by 1 order by 2 desc limit 10;


select 'mais serviços para uma praça/poi' as mensagem;
select dw_points.name, 
       count(*) 
  from datawarehouse_final as dw 
  join dw_points on dw.id_local_final = dw_points.id 
 group by 1 order by 2 desc limit 10;


select 'campanha e aeroporto:' as sublabel;

select 'serviços por dow em campanha' as mensagem;
select  dw_date.day_of_week,  
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name = 'Campanhã' 
  group by 1 
  order by 2 desc;


select 'serviços por hour em campanha' as mensagem;
select  dw_date.hour, 
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name = 'Campanhã' 
  group by 1 
  order by 2 desc;


select 'serviços por dow e hour em campanha' as mensagem;
select  dw_date.day_of_week, 
	    dw_date.hour, 
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name = 'Campanhã' 
  group by 1,2 
  order by 1,2;


select 'alfas em campanha' as mensagem;
select '18h às 23:59' as mensagem;
select cast(to_char(to_timestamp(initial_ts),'HH24') as integer) as hour, 
 	   cast(to_char(to_timestamp(initial_ts),'MI')   as integer) as min, 
 	   count(*) as c  
  from taxi_services as ts 
  join dw_points     as p 
    on st_distancesphere(ts.initial_point,p.location) < 75
 where cast(to_char(to_timestamp(initial_ts),'yyyymmddHH24') as integer) 
       in 
       ( select distinct dw_date.id
           from datawarehouse_initial as dw 
   		   join dw_points on dw.id_local_inicial = dw_points.id 
   		   join dw_date   on dw.id_data_inicial  = dw_date.id 
 		  where dw_date.hour >= 18 
 		)
   and p.name = 'Campanhã'
 group by 1,2 
 order by 1,2;

select 'serviços por dow e hour no aeroporto' as mensagem;
select  dw_date.day_of_week, 
	    dw_date.hour, 
	    count(*) 
   from datawarehouse_final as dw 
   join dw_points on dw.id_local_final = dw_points.id 
   join dw_date   on dw.id_data_final  = dw_date.id 
  where dw_points.type = 'Aeroporto' 
  group by 1,2 
  order by 3 desc;


select 'serviços por dow e hour a chegar ao aeroporto' as mensagem;
select  dw_date.day_of_week,
		dw_date.hour, 
	    count(*) 
   from datawarehouse_final as dw 
   join dw_points on dw.id_local_final = dw_points.id 
   join dw_date   on dw.id_data_final  = dw_date.id 
  where dw_points.type = 'Aeroporto' 
  group by 1,2 
  order by 1,2 asc;


select 'praça com mais viagens para o aeroporto total' as mensagem;
select p1.name, 
       p2.name, 
       count(*)                              
  from datawarehouse_i_f as dw 
  join dw_date   as d  on dw.id_data_inicial  = d.id
  join dw_points as p1 on dw.id_local_inicial = p1.id 
  join dw_points as p2 on dw.id_local_final   = p2.id 
 where p2.type = 'Aeroporto' 
 group by 1,2  
 order by 3 desc
 limit 10;

select 'praça com mais viagens para o aeroporto diurnas' as mensagem;
select p1.name, 
       p2.name, 
       count(*)                              
  from datawarehouse_i_f as dw 
  join dw_date   as d  on dw.id_data_inicial  = d.id
  join dw_points as p1 on dw.id_local_inicial = p1.id 
  join dw_points as p2 on dw.id_local_final   = p2.id 
 where p2.type = 'Aeroporto'
   and d.hour >= 8 
 group by 1,2  
 order by 3 desc
 limit 12;

select 'praça com mais viagens para o aeroporto noturnas' as mensagem;
select p1.name, 
       p2.name, 
       count(*)                              
  from datawarehouse_i_f as dw 
  join dw_date   as d  on dw.id_data_inicial  = d.id
  join dw_points as p1 on dw.id_local_inicial = p1.id 
  join dw_points as p2 on dw.id_local_final   = p2.id 
 where p2.type = 'Aeroporto' 
   and d.hour < 8
 group by 1,2  
 order by 3 desc
 limit 12;

select 'outros pontos:' as sublabel;

select 'serviços por dow and hour no eskada' as mensagem;
select  dw_date.day_of_week, 
	    dw_date.hour, 
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name like 'Eskada%' 
  group by 1,2 
  order by 1,2 asc;


select 'FIM PONTOS' as label;
select 'EVENTOS' as label;



select 'doy, queima e nos primavera sound -> a sair praça/poi:Queimodromo' as mensagem;
select  dw_date.day_of_year, 
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name = 'Queimodromo' 
  group by 1 
  order by 2 desc 
  limit 11;


select 'doy, queima e nos primavera sound -> a chegar praça/poi:Queimodromo' as mensagem;
select  dw_date.day_of_year, 
	    count(*) 
   from datawarehouse_final as dw 
   join dw_points on dw.id_local_final = dw_points.id 
   join dw_date   on dw.id_data_final  = dw_date.id 
  where dw_points.name = 'Queimodromo' 
  group by 1 
  order by 2 desc 
  limit 11;


select 'dia com mais saidas em campanha' as mensagem;
select  dw_date.day_of_year, 
        count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name = 'Campanhã' 
  group by 1 
  order by 2 desc 
  limit 1;


select 'semana com mais serviços' as mensagem;
select d.week_of_year, 
	   count(*) 
  from datawarehouse_initial as dw 
  join dw_date as d on d.id = dw.id_data_inicial 
 group by 1 
 order by 2 desc
 limit 1; 


select 'doy, serralves em festa -> a chegar praça/poi:Serralves' as mensagem;
select  dw_date.day_of_year, 
	    count(*) 
   from datawarehouse_final as dw 
   join dw_points on dw.id_local_final = dw_points.id 
   join dw_date   on dw.id_data_final  = dw_date.id 
  where dw_points.name like '%erralves%' 
  group by 1 
  order by 2 desc 
  limit 10;


select 'doy, serralves em festa -> a sair praça/poi:Serralves' as mensagem;
select  dw_date.day_of_year, 
	    count(*) 
   from datawarehouse_initial as dw 
   join dw_points on dw.id_local_inicial = dw_points.id 
   join dw_date   on dw.id_data_inicial  = dw_date.id 
  where dw_points.name like '%erralves%' 
  group by 1 
  order by 2 desc 
  limit 10;


select 'meo mares vivas -> a chegar lá' as mensagem;
select  d.day_of_year, 
     	count(*) 
   from datawarehouse_final as dw 
   join dw_points      on dw.id_local_final = dw_points.id 
   join dw_date as d   on dw.id_data_inicial  = d.id 
  where dw_points.name like 'Meo%'
    and (d.day_of_year = 197 or d.day_of_year = 198 or d.day_of_year = 199) 
group by 1 order by 2 desc;


select 'praças que vão para o queimodromo' as mensagem;
select 'durante a queima ou durante o nos' as mensagem;
select p1.name,
	   count(*) 
  from datawarehouse_i_f as dw 
  join dw_points as p1 on p1.id = dw.id_local_inicial 
  join dw_points as p2 on p2.id = dw.id_local_final 
  join dw_date   as d  on  d.id = dw.id_data_inicial
   and (
   	   (d.day_of_year >= 123 and d.day_of_year <=130) 
   	or (d.day_of_year >= 156 and d.day_of_year <=157)
   	   ) 
 where p2.name like 'Queimodromo' 
 group by 1
 order by 2 desc 
 limit 10;


select 'FIM EVENTOS' as label;
select 'VIAGENS' as label;


select 'viagens mais longas' as mensagem;
select round(metros/1000,2) as kms, 
       to_char((seg || ' second')::interval, 'HH24:MI:SS') as tempo, 
       v, 
	   porto.concelho,
	   porto.freguesia,
	   portu.diStrito,
	   portu.concelho,
	   portu.freguesia 
  from datawarehouse, 
       dw_caop_porto as porto, 
       dw_caop       as portu 
 where metros in (select metros 
 	                from datawarehouse 
 	               order by 1 desc 
 	               limit 20) 
   and st_within(local_final, portu.geom) 
   and st_within(local_inicial, porto.geom)
  order by 1 desc;


select 'viagens mais longas a partir de cada praça/poi' as mensagem;
select round(dw2.metros/1000,2) as kms, 
       to_char((seg || ' second')::interval, 'HH24:MI:SS') as tempo,
       v,
	   p.name                   as origem, 
	   dw_caop.distrito         as d_dist, 
	   dw_caop.concelho         as d_con, 
	   dw_caop.freguesia        as d_freg 
  from datawarehouse_initial as dw2 
  inner join ( select dw1.id_local_inicial as id_tmp, 
  				      max(metros) as max_m 
  				 from datawarehouse_initial as dw1 
  		     group by dw1.id_local_inicial ) as tmp 
  on (tmp.id_tmp = dw2.id_local_inicial and dw2.metros = tmp.max_m) 
  inner join dw_points as p 
  on dw2.id_local_inicial = p.id, dw_caop 
  where st_within(dw2.local_final,dw_caop.geom) 
  order by 1 desc
  limit 20;


select 'viagens mais rápidas em velocidades' as mensagem;
select round(metros/1000,2) as kms, 
       to_char((seg || ' second')::interval, 'HH24:MI:SS') as tempo, 
       v, 
  	   porto.concelho,
       porto.freguesia,
       portu.diStrito,
       portu.concelho,
       portu.freguesia 
  from datawarehouse as dw, 
       dw_caop_porto as porto, 
       dw_caop       as portu 
 where v in (select v 
               from datawarehouse 
              order by 1 desc limit 20) 
   and st_within(local_final, portu.geom) 
   and st_within(local_inicial, porto.geom) 
 order by 3 desc;


select 'viagens mais demoradas' as mensagem;
select * from (
select round(metros/1000,2) as kms, 
       to_char((seg || ' second')::interval, 'HH24:MI:SS') as tempo, 
       v, 
  	   porto.concelho,
       porto.freguesia,
       portu.diStrito,
       portu.concelho,
       portu.freguesia 
  from datawarehouse as dw, 
       dw_caop_porto as porto, 
       dw_caop       as portu 
 where seg in (select seg 
               from datawarehouse 
              order by 1 desc limit 20) 
   and st_within(local_final, portu.geom) 
   and st_within(local_inicial, porto.geom) 
 union
select round(metros/1000,2) as kms, 
       to_char((seg || ' second')::interval, 'HH24:MI:SS') as tempo, 
       v,
       porto1.concelho,
       porto1.freguesia,
       'ESPANHA',
       'ESPANHA',
       'Espanha'
  from datawarehouse as dw1,
       dw_caop_porto as porto1 
 where seg in (select seg 
               from datawarehouse
               order by 1 desc limit 20
               ) 
 and dw1.id not in(select dw.id
                 from datawarehouse as dw, 
                      dw_caop_porto as porto, 
                      dw_caop       as portu 
                where seg in  ( select seg 
                                  from datawarehouse 
                                 order by 1 desc 
                                 limit 20) 
                  and st_within(local_final, portu.geom) 
                  and st_within(local_inicial, porto.geom)
               )
 and st_within(local_inicial,porto1.geom)
 ) as tmp order by 2 desc
;


select 'FIM VIAGENS' as label;
select 'TAXISTAS' as label;


select 'taxistas com mais serviços' as mensagem;
select id_taxi, 
       count(*)
  from datawarehouse 
 group by 1 
 order by 2 desc
 limit 5;

select 'média' as mensagem;
select avg (c) 
  from (select id_taxi, 
               count(*) as c
  		   from datawarehouse 
 		  group by 1 
 		  order by 2 desc
          limit 5) as avg;


select 'serviços de taxistas com mais serviços por praça' as mensagem;
select id_taxi, 
	   count(*) as c
  from datawarehouse 
 where id_taxi in (select id_taxi 
                      from (select id_taxi,
                                   id_local_inicial,
                                   count(*) 
                              from datawarehouse_initial 
                             group by 1,2 
                             order by 3 desc
                             limit 5) as tmp) 
 group by 1 
 order by 2 desc;


select 'média' as mensagem;
select avg (c) 
  from (select id_taxi, 
	   count(*) as c
  from datawarehouse 
 where id_taxi in (select id_taxi 
                      from (select id_taxi,
                                   id_local_inicial,
                                   count(*) 
                              from datawarehouse_initial 
                             group by 1,2 
                             order by 3 desc
                             limit 5) as tmp) 
 group by 1 
 order by 2 desc
) as avg;


select 'praças usadas por taxistas com mais serviços' as mensagem;
select id_taxi,
	   p.name, 
	   count(*) 
  from datawarehouse_initial as dwi 
  join dw_points as p 
    on dwi.id_local_inicial = p.id 
 where id_taxi in (select id_taxi from (select id_taxi,
 	                      count(*)
 					 from datawarehouse 
 					group by 1 
 					order by 2 desc
 					limit 5) as tmp)
 group by 1,2 
 having count(*) > 150 
 order by 1,3 desc;


select 'serviços taxistas com mais serviços por praça' as mensagem;
select id_taxi, 
       p.name, 
       count(*) 
  from datawarehouse_initial as dwi 
  join dw_points as p 
  on dwi.id_local_inicial = p.id 
  where id_taxi in (select id_taxi 
  	                  from (select id_taxi,
  	                  	           id_local_inicial,
  	                  	           count(*) from datawarehouse_initial 
  	                  	           group by 1,2 
  	                  	           order by 3 desc
  	                  	           limit 5) as tmp) 
  group by 1,2 
  having count(*)>15
  order by 1,3 desc;



select 'TOP 3 TAXISTAS' as sublabel;

select 'total viagens' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 2 desc 
 limit 3;


select 'max total kms' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 3 desc 
 limit 3;


select 'max kms numa unica' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 4 desc 
 limit 3;


select 'melhor media' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 5 desc 
 limit 3;


select 'maiores velocidades' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 6 desc 
 limit 3;


select 'maior duracao' as mensagem;
select id_taxi as taxi, 
       count(*) as total_viagens, 
       round(sum(metros)/1000,2) as kms, 
       round(max(metros)/1000,2) as max_kms, 
       round(avg(metros)/1000,2) as avg_kms, 
       max(v)                    as max_velocity, 
       to_char((max(seg) || ' second')::interval, 'HH24:MI:SS') as max_seg   
  from datawarehouse 
 group by 1 
 order by 7 desc 
 limit 3;


select 'taxistas que fizeram mais serviços por praça' as mensagem;
select * from (
	           select *, 
	                  rank() over (partition by tmp.name order by tmp.count desc) 
	             from (select p.name, 
	             	          dw.id_taxi, 
	             	          count(*) as count 
	             	          from datawarehouse_initial as dw 
	             	          join dw_points as p 
	             	            on p.id=dw.id_local_inicial 
	             	         group by 1,2 
	             	         order by 1,3 desc) as tmp) as rank_filter where rank <= 3;
select 'FIM TAXISTAS' as label;

select 'TOP 3 PRAÇAS' as label;

select 'Melhor media' as mensagem;
select 'metros' as mensagem;
select dw_points.name, AVG(metros), max(metros), min(metros) from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 2 desc limit 3; 
select 'segundos' as mensagem;
select dw_points.name, AVG(seg), max(seg), min(seg)          from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 2 desc limit 3; 
select 'velocidade' as mensagem;
select dw_points.name, AVG(v), max(v), min(v)                from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 2 desc limit 3; 

select 'Maximo' as mensagem;
select 'metros' as mensagem;
select dw_points.name, AVG(metros), max(metros), min(metros) from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 3 desc limit 3; 
select 'segundos' as mensagem;
select dw_points.name, AVG(seg), max(seg), min(seg)          from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 3 desc limit 3; 
select 'velocidade' as mensagem;
select dw_points.name, AVG(v), max(v), min(v)                from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 3 desc limit 3; 

select 'Minimo' as mensagem;
select 'metros' as mensagem;
select dw_points.name, AVG(metros), max(metros), min(metros) from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 4 limit 3; 
select 'segundos' as mensagem;
select dw_points.name, AVG(seg), max(seg), min(seg)          from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 4 limit 3; 
select 'velocidade' as mensagem;
select dw_points.name, AVG(v), max(v), min(v)                from datawarehouse_initial as dw join dw_points on dw.id_local_inicial = dw_points.id group by 1 order by 4 limit 3; 

select 'FIM PRAÇAS' as label;

select 'FIM ANÁLISE' as label;





--verificar os repetidos
/*select name, 
	   count(*) 
  from datawarehouse_initial as dw 
  join dw_points as p on dw.id_local_inicial=p.id 
 where dw.id in (select id 
 					    from datawarehouse_initial 
 					    group by 1  
 					    having count(*) > 1) 
 group by 1 order by 2 desc;
*/
