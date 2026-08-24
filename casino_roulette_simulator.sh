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
  echo -e "\n\n${redColour}[+] Exiting...${endColour}\n"
  tput cnorm; exit 1
}
#CTRL + C 
trap ctrl_c INT


#----------Functions-------------

 #function helpPanel
 function helpPanel() {
   echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Usage:${endColour} ${blueColour} $0 ${endColour}\n "
   echo -e "\t${purpleColour}m)${endColour} ${grayColour} Money to play with${endColour} "
   echo -e "\t${purpleColour}t)${endColour} ${grayColour} Technique to use${endColour} ${purpleColour} (martingale/inverseLabouchere) ${endColour} "
   echo -e "\t${purpleColour}h)${endColour} ${grayColour} Show help panel${endColour}  "
 }

#Function martingale
function martingale() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current Balance: ${endColour}${blueColour}$money${endColour} ${grayColour}USD${endColour}"
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} Enter bet amount -> ${endColour}" && read initial_bet
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} What do you want to bet on continuously? (even/odd) -> ${endColour}" && read par_impar

  if [ "$initial_bet" -gt 0 ] && [ "$initial_bet" -le $money ] && [ "$par_impar" == "even" ] || [ "$par_impar" == "odd" ] && [ "$initial_bet" -gt 0 ] && [ "$initial_bet" -le $money ] ; then

    echo -e "\n\n${yellowColour}[+]${endColour}${grayColour} Starting game with an initial amount of${endColour}${blueColour} $initial_bet${endColour}${grayColour} on${endColour}${blueColour} $par_impar${endColour}"
    
    backup_initial_bet=$initial_bet
    plays_counter=0
    bad_plays_counter=""
    max_earning=0

    tput civis
    while true; do 
      money=$(($money-$initial_bet))
      random_number="$(($RANDOM % 37))"

      #---OPTION EVEN-----
      if [ "$money" -ge 0 ] && [ "$initial_bet" -gt 0 ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${purpleColour}You just bet ${endColour}${blueColour}$initial_bet${endColour}${purpleColour} and currently have ${endColour}${blueColour}$money${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Number rolled:${endColour}${blueColour} $random_number${endColour}"

        if [ "$par_impar" == "even" ]; then
            
          if [ "$(($random_number % 2))" -eq 0 ]; then  
            if [ "$random_number" -eq 0 ]; then
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled 0, house wins (Loss)${endColour}"
              initial_bet=$(($initial_bet*2))
              if [ "$initial_bet" -le $money ]; then
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling bet to${endColour}${blueColour} $initial_bet${endColour}\n"
                bad_plays_counter+="$random_number "
              else
                initial_bet=$money
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling exceeds available balance, betting all in next round:${endColour}${blueColour} $initial_bet${endColour}\n"
                bad_plays_counter+="$random_number "
              fi
            else
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Rolled an even number, YOU WON!${endColour}"
              reward=$(($initial_bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total payout:${endColour}${blueColour} $reward${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current balance:${endColour}${blueColour} $money${endColour}\n"
              initial_bet=$backup_initial_bet
              bad_plays_counter=""
              if [ "$money" -gt $max_earning ]; then
                max_earning=$money
              fi
            fi
          else
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled an odd number, YOU LOST${endColour}"
              initial_bet=$(($initial_bet*2))
              if [ "$initial_bet" -le $money ]; then
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling bet to${endColour}${blueColour} $initial_bet${endColour}\n"
                bad_plays_counter+="$random_number "
              else
                initial_bet=$money
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling exceeds available balance, betting all in next round:${endColour}${blueColour} $initial_bet${endColour}\n"
                bad_plays_counter+="$random_number "
              fi
          fi
       #------------OPTION ODD--------------------- 
        elif [ "$par_impar" == "odd" ]; then
          if [ "$(($random_number % 2))" -eq 0 ]; then
            if [ "$random_number" -eq 0 ]; then
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled 0, house wins (Loss)${endColour}"
            else
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled an even number, YOU LOST${endColour}"
            fi
            initial_bet=$(($initial_bet*2))
            if [ "$initial_bet" -le $money ]; then
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling bet to${endColour}${blueColour} $initial_bet${endColour}\n"
              bad_plays_counter+="$random_number "
            else
              initial_bet=$money
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Doubling exceeds available balance, betting all in next round:${endColour}${blueColour} $initial_bet${endColour}\n"
              bad_plays_counter+="$random_number "
            fi

          else
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Rolled an odd number, YOU WON!${endColour}"
              reward=$(($initial_bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total payout:${endColour}${blueColour} $reward${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current balance:${endColour}${blueColour} $money${endColour}\n"
              initial_bet=$backup_initial_bet
              bad_plays_counter=""
              if [ "$money" -gt $max_earning ]; then
                max_earning=$money
              fi

          fi
        else 
          echo -e "\n${redColour}[!] Invalid bet input!${endColour}"
          tput cnorm; exit 0
        fi
      #-------Out of funds------------
      else
        echo -e "\n\n${redColour}[!] Out of funds to continue betting. GG :(${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Total rounds played:${endColour} ${blueColour}$plays_counter${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}List of last losing numbers: ${blueColour}\n--> [ $bad_plays_counter]${endColour} "
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Peak balance reached: ${endColour}${blueColour}$max_earning${endColour}"

        tput cnorm; exit 0
      fi
      let plays_counter+=1
    done
    tput cnorm
  else
    echo -e "\n\n${redColour}[!] Invalid input values!${endColour}"    
  fi
}

#Function inverseLabouchere
function inverseLabouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current Balance: ${endColour}${blueColour}$money${endColour}"
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} What do you want to bet on continuously? (even/odd) -> ${endColour}" && read par_impar
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} Set target profit ceiling to reset sequence -> ${endColour}" && read tope

  if [ "$tope" -gt 0 ] && [ "$par_impar" == "even" ] || [ "$par_impar" == "odd" ] && [ "$tope" -gt 0 ]; then
    declare -a my_sequence=(1 2 3 4)
    plays_counter=0
    max_sequence=()
    max_earning=0
    bad_plays_counter=""
    bet_to_renew=$(($money + $tope))

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target threshold to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Starting with sequence:${endColour}${blueColour} [${my_sequence[@]}] ${endColour}"
    
    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

    tput civis
    while true; do 
      random_number=$(($RANDOM % 37))
      money=$(($money - $bet))

      if [ "$money" -ge 0 ]; then
        
        echo -e "\n\n${yellowColour}[+]${endColour}${purpleColour} You just bet ${endColour}${blueColour}$bet${endColour}${purpleColour} and currently have ${endColour}${blueColour}$money${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Number rolled:${endColour}${blueColour} $random_number${endColour}"
        #-------------OPTION EVEN----------------------
        if [ "$par_impar" == "even" ];then 
          if [ "$(($random_number % 2))" -eq 0 ];then 
            if [ "$random_number" -eq 0 ]; then
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled 0, house wins (Loss)${endColour}"
              unset my_sequence[0]
              unset my_sequence[-1] 2>/dev/null
              my_sequence=(${my_sequence[@]})
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current sequence: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
              
              if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Critical threshold reached, adjusting target ceiling${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target ceiling to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Critical floor to lower ceiling: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
              fi

              if [ "${#my_sequence[@]}" -gt 1 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              elif [ "${#my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]}
              else
                echo -e "\n${redColour}[!] Sequence depleted${endColour}"
                my_sequence=(1 2 3 4)
                echo -e "\n${turquoiseColour}[!] Resetting sequence to [1 2 3 4]${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              fi
              bad_plays_counter+="$random_number "
            else
              echo -e "\n${yellowColour}[+]${endColour}${greenColour} Rolled an even number, YOU WON!${endColour}"
              reward=$(($bet*2))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total payout:${endColour}${blueColour} $reward${endColour}"
              money=$(($money+$reward))
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current balance:${endColour}${blueColour}$money${endColour}"
              
              if [ $money -gt $bet_to_renew ]; then
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Balance exceeded the target of ${endColour}${blueColour}$bet_to_renew${endColour}${turquoiseColour} to reset sequence"
                let bet_to_renew+=$tope
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target ceiling to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Critical floor to lower ceiling: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
                my_sequence=(1 2 3 4)
                echo -e "\n${turquoiseColour}[!] Resetting sequence to [1 2 3 4]${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              else
                my_sequence+=($bet)
                my_sequence=(${my_sequence[@]})
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current sequence: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
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
          else
            echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled an odd number, YOU LOST${endColour}"
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current sequence: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
            
            if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Critical threshold reached, adjusting target ceiling${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target ceiling to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Critical floor to lower ceiling: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
            fi

            if [ "${#my_sequence[@]}" -gt 1 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "\n${redColour}[!] Sequence depleted${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Resetting sequence to [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
            bad_plays_counter+="$random_number "
          fi
        #-------------------OPTION ODD-----------------------
        else
          if [ "$(($random_number % 2))" -eq 0 ];then
            if [ "$random_number" -eq 0 ]; then
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled 0, house wins (Loss)${endColour}"
            else
              echo -e "\n${yellowColour}[+]${endColour}${redColour} Rolled an even number, YOU LOST${endColour}"
            fi
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current sequence: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
            
            if [ $money -lt $(($bet_to_renew - ($tope * 2))) ]; then 
                echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Critical threshold reached, adjusting target ceiling${endColour}"
                bet_to_renew=$(($bet_to_renew - $tope))
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target ceiling to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 
                echo -e "\n${yellowColour}[+]${endColour}${grayColour} Critical floor to lower ceiling: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
            fi

            if [ "${#my_sequence[@]}" -gt 1 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "\n${redColour}[!] Sequence depleted${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Resetting sequence to [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
            bad_plays_counter+="$random_number "

          else
            echo -e "\n${yellowColour}[+]${endColour}${greenColour} Rolled an odd number, YOU WON!${endColour}"
            reward=$(($bet*2))
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total payout:${endColour}${blueColour} $reward${endColour}"
            money=$(($money+$reward))
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current balance:${endColour}${blueColour}$money${endColour}"
            
            if [ $money -gt $bet_to_renew ]; then
              echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour} Balance exceeded the target of ${endColour}${blueColour}$bet_to_renew${endColour}${turquoiseColour} to reset sequence"
              let bet_to_renew+=$tope
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Target ceiling to reset sequence: ${endColour}${blueColour}$bet_to_renew${endColour}" 
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Critical floor to lower ceiling: ${endColour}${blueColour}$(($bet_to_renew - ($tope * 2)))${endColour}" 
              my_sequence=(1 2 3 4)
              echo -e "\n${turquoiseColour}[!] Resetting sequence to [1 2 3 4]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            else
              my_sequence+=($bet)
              my_sequence=(${my_sequence[@]})
              echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current sequence: ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
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

      else
        echo -e "\n\n${redColour}[!] Out of funds to continue betting. GG :(${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Total rounds played:${endColour} ${blueColour}$plays_counter${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}List of last losing numbers: ${blueColour}\n--> [ $bad_plays_counter]${endColour} "
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Maximum sequence length achieved: ${endColour} ${blueColour}[${max_sequence[@]}]${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Peak balance reached: ${endColour}${blueColour}$max_earning${endColour}"
        tput cnorm; exit 0
      fi

      let plays_counter+=1
    done
    tput cnorm
  else
    echo -e "\n\n${redColour}[!] Invalid input values!${endColour}"    
  fi

}


#Get parameters entered by the user
while getopts "m:t:h" arg; do 
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) ;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingale" ]; then
    martingale
  elif [ "$technique" == "inverseLabouchere" ]; then
    inverseLabouchere
  else
    echo -e "\n${redColour}[!] The specified technique does not exist${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
