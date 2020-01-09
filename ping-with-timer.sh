#!/bin/bash

## TEMPORIZADOR ##

while true; do

## VARIAVEIS ##

ftp1='177.10.249.146'
ftp2='201.59.201.90'
ftp3='201.30.158.147'
menor_ping=99999999
menor_perca=99999999
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
log='ftp.log'
path='/home/dhaniel/Gitlab/ping_ftp'

## CRIANDO LOG ##
if [ ! -e $path/$log ]; then
    touch $path/$log
fi

## PINGANDO NOS LINKS ##
echo $data 'Coletando informações dos links FTP...' >> $path/$log 2>&1
ping -c 5 $ftp1 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $path/$ftp1 
ping -c 5 $ftp2 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $path/$ftp2
ping -c 5 $ftp3 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $path/$ftp3

## LIMPANDO ARQUIVOS ##
sed -i '/^$/d' $path/$ftp1
sed -i '/^$/d' $path/$ftp2
sed -i '/^$/d' $path/$ftp3

## CALCULANDO MEDIA DO FTP1 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data "Calculando média de ping do link $ftp1" >> $path/$log 2>&1
if [ $(wc -l $path/$ftp1 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $path/$ftp1)
    l2=$(sed '2!d' $path/$ftp1)
    l3=$(sed '3!d' $path/$ftp1)
    l4=$(sed '4!d' $path/$ftp1)
    l5=$(sed '5!d' $path/$ftp1)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp1 é $media ms"  >> $path/$log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp1
    fi
        
else
    pacotes_perdidos=$(echo 5 - $(wc -l $path/$ftp1 | awk '{print $1}') | bc)
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp1                
    fi
    echo $data "Link $ftp1 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $path/$log 2>&1
    
fi


## CALCULANDO MEDIA DO FTP2 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data 'Calculando média de ping do link' $ftp2 >> $path/$log 2>&1
if [ $(wc -l $path/$ftp2 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $path/$ftp2)
    l2=$(sed '2!d' $path/$ftp2)
    l3=$(sed '3!d' $path/$ftp2)
    l4=$(sed '4!d' $path/$ftp2)
    l5=$(sed '5!d' $path/$ftp2)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp2 é $media ms"  >> $path/$log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp2
    fi

else
    pacotes_perdidos=$(echo 5 - $(wc -l $path/$ftp2 | awk '{print $1}')| bc)  
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp2
        
    fi
    echo $data "Link $ftp2 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $path/$log 2>&1
fi


## CALCULANDO MEDIA DO FTP3 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data 'Calculando média de ping do link' $ftp3 >> $path/$log 2>&1
if [ $(wc -l $path/$ftp3 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $path/$ftp3)
    l2=$(sed '2!d' $path/$ftp3)
    l3=$(sed '3!d' $path/$ftp3)
    l4=$(sed '4!d' $path/$ftp3)
    l5=$(sed '5!d' $path/$ftp3)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp3 é $media ms"  >> $path/$log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp3
    fi

else
    pacotes_perdidos=$(echo 5 - $(wc -l $path/$ftp3 | awk '{print $1}')| bc)
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp3
        
    fi
    echo $data "Link $ftp3 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $path/$log 2>&1
    
fi

## DEFININDO MELHOR FTP NO ARQUIVO ##

data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $melhor_link > $path/ftp_atual.txt
if [ ! $( cat $path/ftp_atual.txt ) = "" ]; then
    echo $data "Link com melhor ping atualmente é $melhor_link"  >> $path/$log 2>&1
else
    echo $data "Todos os links estão perdendo pacotes, o link que menos perdeu pacotes foi o $link_menor_perca e será usado nesse momento." >> $path/$log 2>&1
    echo $link_menor_perca > $path/ftp_atual.txt
fi

## REMOVENDO ARQUIVOS DESNECESSÁRIOS ##

rm -rf $path/$ftp1
rm -rf $path/$ftp2
rm -rf $path/$ftp3

## TEMPORIZADOR ##

sleep 2m
done

## FIM ##
