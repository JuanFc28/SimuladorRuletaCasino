#!/bin/bash
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
  echo -e "\n\n${redColour}[+]Saliendo...${endColour}\n"
  tput cnorm; exit 1
}
#CTRL + C 
trap ctrl_c INT


#----------Funciones-------------

 #funcion helpPanel
 function helpPanel() {
   echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Uso:${endColour} ${blueColour} $0 ${endColour}\n "
   echo -e "\t${purpleColour}m)${endColour} ${grayColour} Dinero con el que se desea jugar${endColour} "
   echo -e "\t${purpleColour}t)${endColour} ${grayColour} Tecnica a utilizar${endColour} ${purpleColour} (martingala/inverseLabrouchere) ${endColour} "
   echo -e "\t${purpleColour}h)${endColour} ${grayColour} Mostrar panel de ayuda${endColour}  "
 }

#Funcion martingala
function martingala() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero Actual: ${endColour}${blueColour}$money${endColour} ${grayColour}pesos${endColour}"
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} Ingrese el dinero a apostar -> ${endColour}" && read initial_bet
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} A que desea apostar continuamente? (par/impar) -> ${endColour}" && read par_impar

  if [ "$initial_bet" -gt 0 ] && [ "$initial_bet" -le $money ] && [ "$par_impar" == "par" ] || [ "$par_impar" == "impar" ] && [ "$initial_bet" -gt 0 ] && [ "$initial_bet" -le $money ] ; then #Comprobacion del input del usuario

    echo -e "\n\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos a un numero${endColour}${blueColour} $par_impar${endColour}"
    
    backup_initial_bet=$initial_bet
    plays_counter=0
    bad_plays_counter=""
    max_earning=0

    tput civis
    while true; do 
      money=$(($money-$initial_bet))
      random_number="$(($RANDOM % 37))"

      #---OPCION PAR-----
      if [ "$money" -ge 0 ] && [ "$initial_bet" -gt 0 ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${purpleColour}Acabas de apostar ${endColour}${blueColour}$initial_bet${endColour}${purpleColour} pesos y tienes ahora ${endColour}${blueColour}$money${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

        if [ "$par_impar" == "par" ]; then #Opcion si se ha escogido PAR
            
          if [ "$(($random_number % 2))" -eq 0 ]; then  
            if [ "$random_number" -eq 0 ]; then #Salio numero 0
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido el 0, por lo tanto perdemos${endColour}"
              initial_bet=$(($initial_bet*2))
              ###Poner condicional para cuando se duplica y es mayor que el money
              if [ "$initial_bet" -le $money ]; then
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Duplicando apuesta a${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
                bad_plays_counter+="$random_number "
              else
                initial_bet=$money
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Duplicar la apuesta supera el dinero restante, Apostando todo en la siguiente juagada:${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
                bad_plays_counter+="$random_number "
              fi
            else #Salio numero par
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Ha salido un numero par, Has GANADO!${endColour}"
              reward=$(($initial_bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $reward${endColour}${grayColour} pesos${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tienes ${endColour}${blueColour} $money${endColour}${grayColour} pesos${endColour}\n"
              initial_bet=$backup_initial_bet
              bad_plays_counter=""
              if [ "$money" -gt $max_earning ]; then
                max_earning=$money
              fi
            fi
          else #Salio numero impar
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido un numero impar, Has PERDIDO${endColour}"
              initial_bet=$(($initial_bet*2))
              if [ "$initial_bet" -le $money ]; then
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Duplicando apuesta a${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
                bad_plays_counter+="$random_number "
              else
                initial_bet=$money
                echo -e "\n${yellowColour}[+]${endColour}${grayColour}Duplicar la apuesta supera el dinero restante, Apostando todo en la siguiente jugada:${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
                bad_plays_counter+="$random_number "
              fi
          fi
       #------------Opcion IMPAR--------------------- 
        elif [ "$par_impar" == "impar" ]; then #Opcion si se ha escogido IMPAR
          if [ "$(($random_number % 2))" -eq 0 ]; then
            if [ "$random_number" -eq 0 ]; then #Salio numero 0
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido el 0, por lo tanto perdemos${endColour}"
            else #Salio numero par
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido un numero par, Has PERDIDO${endColour}"
            fi
            initial_bet=$(($initial_bet*2))
            if [ "$initial_bet" -le $money ]; then
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Duplicando apuesta a${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
              bad_plays_counter+="$random_number "
            else
              initial_bet=$money
              echo -e "\n${yellowColour}[+]${endColour}${grayColour}Duplicar la apuesta supera el dinero restante, Apostando todo en la siguiente jugada:${endColour}${blueColour} $initial_bet${endColour}${grayColour} pesos${endColour}\n"
              bad_plays_counter+="$random_number "
            fi

          else #Salio numero impar
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Ha salido un numero impar, Has GANADO!${endColour}"
              reward=$(($initial_bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $reward${endColour}${grayColour} pesos${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tienes ${endColour}${blueColour} $money${endColour}${grayColour} pesos${endColour}\n"
              initial_bet=$backup_initial_bet
              bad_plays_counter=""
              if [ "$money" -gt $max_earning ]; then
                max_earning=$money
              fi

          fi
        else 
          echo -e "\n${redColour}[!] Has ingresado una apuesta incorrecta!${endColour}"
          tput cnorm; exit 0
        fi
      #-------Sin dinero para apostar------------
      else
        echo -e "\n\n${redColour}[!] Te has quedado sin dinero para apostar GG :("
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${blueColour}$plays_counter${endColour} ${grayColour}jugadas${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}A continuacion se presentan la lista de los ultimos numeros perdedores: ${blueColour}\n--> [ $bad_plays_counter]${endColour} "
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La cantidad maxima ganada fue: ${endColour}${blueColour}$max_earning${endColour} ${grayColour}pesos${endColour}"

        tput cnorm; exit 0
      fi
      let plays_counter+=1
    done
    tput cnorm
  else
    echo -e "\n\n${redColour}[!] Valores ingresados incorrectos! ${endColour}"    
  fi
}

#Funcion inverseLabrouchere
function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero Actual: ${endColour}${blueColour}$money${endColour} ${grayColour}pesos${endColour}"
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} A que desea apostar continuamente? (par/impar) -> ${endColour}" && read par_impar
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} En cuanto quiere establecer el tope de ganancia para renovar la secuencia? -> ${endColour}" && read tope

  if [ "$tope" -gt 0 ] && [ "$par_impar" == "par" ] || [ "$par_impar" == "impar" ] && [ "$tope" -gt 0 ]; then #Comprobacion del input del usuario
    declare -a my_sequence=(1 2 3 4)
    plays_counter=0
    max_sequence=()
    max_earning=0
    bad_plays_counter=""
    bet_to_renew=$(($money + $tope))

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Iniciando con la secuencia${endColour}${blueColour} [${my_sequence[@]}] ${endColour}"
    
    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

    tput civis
    while true; do 
      random_number=$(($RANDOM % 37))
      money=$(($money - $bet))

      if [ "$money" -ge 0 ]; then #Verifica que haya dinero por apostar
        
        echo -e "\n\n${yellowColour}[+]${endColour}${purpleColour} Acabas de apostar ${endColour}${blueColour}$bet${endColour}${purpleColour} pesos y tienes ahora ${endColour}${blueColour}$money${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"
        #-------------Opcion PAR----------------------
        if [ "$par_impar" == "par" ];then #Opcion si se apuesta PAR 
          if [ "$(($random_number % 2))" -eq 0 ];then 
            if [ "$random_number" -eq 0 ]; then #Salio 0
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido el 0, por lo tanto perdemos${endColour}"
              unset my_sequence[0]
              unset my_sequence[-1] 2>/dev/null
              my_sequence=(${my_sequence[@]})
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tenemos queda la secuencia ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
              #Valida si hemos llegado a un tope minimo critico
              if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El minimo critico para renovar el tope es: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
              fi

              if [ "${#my_sequence[@]}" -gt 1 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              elif [ "${#my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]}
              else
                echo -e "\n${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                my_sequence=(1 2 3 4)
                echo -e "\n${turquoiseColour}[!] Restableciendo secuencia a [1 2 3 4]${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              fi
              bad_plays_counter+="$random_number "
            else #Salio numero par
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Ha salido un numero par, Has GANADO!${endColour}"
              reward=$(($bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $reward${endColour}${grayColour} pesos${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tienes ${endColour}${blueColour}$money${endColour}${grayColour} pesos${endColour}"
              #Valida si hemos llegado al tope para renovar secuencia
              if [ $money -gt $bet_to_renew ]; then
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Nuestro dinero a superado el tope de ${endColour}${blueColour}$bet_to_renew${endColour}${turquoiseColour} establecidos para renovar nuestra secuencia"
                let bet_to_renew+=$tope
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El minimo critico para renovar el tope es: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
                my_sequence=(1 2 3 4)
                echo -e "\n${turquoiseColour}[!] Restableciendo secuencia a [1 2 3 4]${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              else
                my_sequence+=($bet)
                my_sequence=(${my_sequence[@]})
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tenemos queda la secuencia ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

                if [ "${#my_sequence[@]}" -gt "${#max_sequence[@]}" ]; then
                  max_sequence=(${my_sequence[@]})
                fi
                if [ "$money" -gt $max_earning ]; then
                  max_earning=$money
                fi
              fi 
              bad_plays_counter=""
            fi
          else #Salio numero impar
            echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido un numero impar, Has PERDIDO${endColour}"
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tenemos queda la secuencia ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
            
            if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El minimo critico para renovar el tope es: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
            fi

            if [ "${#my_sequence[@]}" -gt 1 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "\n${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Restableciendo secuencia a [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
            bad_plays_counter+="$random_number "
          fi
        #-------------------Opcion IMPAR-----------------------
        else #Opcion si se apuesta IMPAR 
          if [ "$(($random_number % 2))" -eq 0 ];then
            if [ "$random_number" -eq 0 ]; then #Salio 0
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido el 0, por lo tanto perdemos${endColour}"
            else #Salio numero par
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido un numero par, Has PERDIDO${endColour}"
            fi
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tenemos queda la secuencia ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
            
            if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Hemos llegado a un minimo critico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} El minimo critico para renovar el tope es: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
            fi

            if [ "${#my_sequence[@]}" -gt 1 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "\n${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Restableciendo secuencia a [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
            bad_plays_counter+="$random_number "


          else #Salio numero impar
            echo -e "\n${yellowColour}[+]${endColour}${greenColour} Ha salido un numero impar, Has GANADO!${endColour}"
            reward=$(($bet*2))
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $reward${endColour}${grayColour} pesos${endColour}"
            money=$(($money+$reward))
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tienes ${endColour}${blueColour}$money${endColour}${grayColour} pesos${endColour}"
            #Valida si hemos llegado al tope para renovar secuencia
            if [ $money -gt $bet_to_renew ]; then
              echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Nuestro dinero a superado el tope de ${endColour}${blueColour}$bet_to_renew${endColour}${turquoiseColour} establecidos para renovar nuestra secuencia"
              let bet_to_renew+=$tope
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope para renovar la secuencia es: ${endColour}${blueColour}$bet_to_renew${endColour}" 
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} El minimo critico para renovar el tope es: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Restableciendo secuencia a [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            else
              my_sequence+=($bet)
              my_sequence=(${my_sequence[@]})
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ahora tenemos queda la secuencia ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

              if [ "${#my_sequence[@]}" -gt "${#max_sequence[@]}" ]; then
                max_sequence=(${my_sequence[@]})
              fi
              if [ "$money" -gt $max_earning ]; then
                max_earning=$money
              fi
            fi 
            bad_plays_counter=""

          fi
        fi


      else #Te has quedado sin dinero para apostar 
        echo -e "\n\n${redColour}[!] Te has quedado sin dinero para apostar GG :("
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${blueColour}$plays_counter${endColour} ${grayColour}jugadas${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}A continuacion se presentan la lista de los ultimos numeros perdedores: ${blueColour}\n--> [ $bad_plays_counter]${endColour} "
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La secuencia maxima obtenida ha sido: ${endColour} ${blueColour}[${max_sequence[@]}]${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La cantidad maxima ganada fue: ${endColour}${blueColour}$max_earning${endColour} ${grayColour}pesos${endColour}"
        tput cnorm; exit 0
      fi

      let plays_counter+=1
    done
    tput cnorm
  else
    echo -e "\n\n${redColour}[!] Valores ingresados incorrectos! ${endColour}"    
  fi

}


#Obtener el parametro ingresado por el usuario
while getopts "m:t:h" arg; do 
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) ;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == martingala ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe ${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
     