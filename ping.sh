#!/bin/bash

## VARIAVEIS ##
ftp1='177.10.249.146'
ftp2='201.59.201.90'
ftp3='201.30.158.147'
menor_ping=99999999
menor_perca=99999999
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
log='ftp.log'

## CRIANDO LOG ##
if [ ! -e $log ]; then
    touch $log
fi

## PINGANDO NOS LINKS ##
echo $data 'Coletando informações dos links FTP...' >> $log 2>&1
ping -c 5 $ftp1 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $ftp1 
ping -c 5 $ftp2 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $ftp2
ping -c 5 $ftp3 | awk '{print $7}' | cut -f2 -d "=" | grep [0-9] | grep -v ")" > $ftp3

## LIMPANDO ARQUIVOS ##
sed -i '/^$/d' $ftp1
sed -i '/^$/d' $ftp2
sed -i '/^$/d' $ftp3

## CALCULANDO MEDIA DO FTP1 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data "Calculando média de ping do link $ftp1" >> $log 2>&1
if [ $(wc -l $ftp1 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $ftp1)
    l2=$(sed '2!d' $ftp1)
    l3=$(sed '3!d' $ftp1)
    l4=$(sed '4!d' $ftp1)
    l5=$(sed '5!d' $ftp1)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp1 é $media ms"  >> $log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp1
    fi
        
else
    pacotes_perdidos=$(echo 5 - $(wc -l $ftp1 | awk '{print $1}') | bc)
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp1                
    fi
    echo $data "Link $ftp1 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $log 2>&1
    
fi


## CALCULANDO MEDIA DO FTP2 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data 'Calculando média de ping do link' $ftp2 >> $log 2>&1
if [ $(wc -l $ftp2 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $ftp2)
    l2=$(sed '2!d' $ftp2)
    l3=$(sed '3!d' $ftp2)
    l4=$(sed '4!d' $ftp2)
    l5=$(sed '5!d' $ftp2)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp2 é $media ms"  >> $log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp2
    fi

else
    pacotes_perdidos=$(echo 5 - $(wc -l $ftp2 | awk '{print $1}')| bc)  
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp2
        
    fi
    echo $data "Link $ftp2 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $log 2>&1
fi


## CALCULANDO MEDIA DO FTP3 ##
data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $data 'Calculando média de ping do link' $ftp3 >> $log 2>&1
if [ $(wc -l $ftp3 | awk '{print $1}' ) -eq 5 ]; then
    l1=$(sed '1!d' $ftp3)
    l2=$(sed '2!d' $ftp3)
    l3=$(sed '3!d' $ftp3)
    l4=$(sed '4!d' $ftp3)
    l5=$(sed '5!d' $ftp3)
    total=$(echo $l1 + $l2 + $l3 + $l4 + $l5 | bc)
    media=$(echo $total / 5 | bc)
    echo $data "Média de ping do link $ftp3 é $media ms"  >> $log 2>&1
    if [ $media -lt $menor_ping ]; then
        menor_ping=$media
        melhor_link=$ftp3
    fi

else
    pacotes_perdidos=$(echo 5 - $(wc -l $ftp3 | awk '{print $1}')| bc)
    if [ $pacotes_perdidos -lt $menor_perca ]; then
        menor_perca=$pacotes_perdidos
        link_menor_perca=$ftp3
        
    fi
    echo $data "Link $ftp3 está perdendo $pacotes_perdidos pacotes em um intervalo de 5 pings e não entrará na distribuição nesse momento." >> $log 2>&1
    
fi

## DEFININDO MELHOR FTP NO ARQUIVO ##

data=$(echo "["$(date "+%d/%b/%y %H:%M:%S")"]")
echo $melhor_link > ftp_atual.txt
if [ ! $( cat ftp_atual.txt ) = "" ]; then
    echo $data "Link com melhor ping atualmente é $melhor_link"  >> $log 2>&1
else
    echo $data "Todos os links estão perdendo pacotes, o link que menos perdeu pacotes foi o $link_menor_perca e será usado nesse momento." >> $log 2>&1
    echo $link_menor_perca > ftp_atual.txt
fi

## REMOVENDO ARQUIVOS DESNECESSÁRIOS ##

rm -rf $ftp1
rm -rf $ftp2
rm -rf $ftp3

## FIM ##
