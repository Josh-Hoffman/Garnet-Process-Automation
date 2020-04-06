#!/bin/bash


######################
#// Joshua Hoffman //#
######################


export q=0
export CDAT=$(date +'%m-%d-%y')
export CTIM=$(date +'%H-%M')
export CDIR=$(pwd)
export PEMK="$CDIR"/Pool_SN/files/hx.pem
export WDIR="$CDIR"/Pool_SN/"$CDAT"
export SDIR="$WDIR"/Shipping
export FPTH="$FDIR"/Downloaded
export BBLO="$WDIR"/all/Black_Board.txt
export TIME='|==============================[[_$CDAT_$CTIM_]]================================|'
export LINS='|==================================================================================|'
export VLIN='|===============================[[Garnet-v0.8]]================================|'

declare -A file
declare -A ptah
declare -A name
declare -A full

file[1]="/proc/sys/kernel/random/uuid"
file[2]="/proc/sys/kernel/random/uuid"
file[3]="/proc/sys/kernel/random/uuid"
file[4]="/proc/sys/kernel/random/uuid"
file[5]="/proc/sys/kernel/random/uuid"
file[6]="/proc/sys/kernel/random/uuid"
file[7]="/proc/sys/kernel/random/uuid"
file[8]="/proc/sys/kernel/random/uuid"
file[9]="/proc/sys/kernel/random/uuid"
file[10]="/proc/sys/kernel/random/uuid"
file[11]="/proc/sys/kernel/random/uuid"
file[12]="/proc/sys/kernel/random/uuid"
file[13]="/proc/sys/kernel/random/uuid"
file[14]="/proc/sys/kernel/random/uuid"
file[15]="/proc/sys/kernel/random/uuid"
file[16]="/proc/sys/kernel/random/uuid"
file[17]="/proc/sys/kernel/random/uuid"
file[18]="/proc/sys/kernel/random/uuid"
file[19]="/proc/sys/kernel/random/uuid"
file[20]="/proc/sys/kernel/random/uuid"

a=1
b=1
export ARLE="${#file[@]}"

	while [[ $a -le $ARLE  ]]; do
	ptah[$a]=${file[$b]%/*}
	name[$a]=${file[$b]##*/}
	full[$a]=${file[$b]}
	((a++)) && ((b++))
	done


ARGUMENTS () {

a=0

declare -A argu=();
declare -A vars=();
declare -i indx=1;

vars["-s1"]="SN1=${SN1}";
vars["-s2"]="SN2=${SN2}";
vars["-i1"]="IP1=${IP1}";
vars["-i2"]="IP2=${IP2}";
vars["-p1"]="PO1=${PO1}";
vars["-p2"]="PO2=${PO2}";
vars["-x"]="EXIT=${EXIT:-0}";
vars["-c"]="CONF=${CONF:-0}";
vars["-f"]="TEST=${TEST:-0}";
vars["-b"]="STAR=${STAR:-1}";
vars["-v"]="DISP=${DISP:-2}";
vars["-l"]="LOCA=${LOCA:-2}";
vars["-t"]="TRYS=${TRYS:-10}";
vars["-h"]="THRS=${THRS:-10}";
vars["-e"]="STOP=${STOP:-30}";
vars["-d"]="DSPS=${DSPS:-G}";				 
vars["-u"]="DIRC=${DIRC:-PULL}";
vars["-r"]="DISC=${DISC:-full}";
vars["-n"]="FNAM=${FNAM:-name}";
vars["-n"]="DEST=${DEST:-ptah}";
vars["-w"]="PRNT=${PRNT:-serial}";

	for a in ${vars[@]}; do
	export ${a/=*=/=}
	done

	for a in "$@"; do
	argu[$indx]=$a;
	back="$(expr $indx - 1)";
	
		if [[ $i == *"="* ]]; then
		labl=${a%=*}
		else 
		labl=${argu[$back]}
		fi

		if [[ -n $labl ]] && [[ -n ${vars[$labl]} ]]; then
		
			if [[ $a == *"="* ]]; then 
			export ${vars[$labl]}=${a#$labl=}
			else
			export $(echo "${vars[$labl]}=${argu[$indx]}" | awk -F'=' '{if($3){print $1"="$3}else{print $1"="$2}}')
			fi
			
		fi
		
	((indx++))
	done

}

BLACK_BOARD () {

clear

	DISPLAY () {

	BBUP="$(stat $BBLO 2> /dev/null | awk -F'[.|" "]' '/Modify:/ {print $2 " " $3}')"
	echo $VLIN
	echo "|"
	echo "|                  Black Board - Updated: $BBUP"
	echo "|"
	echo $LINS
	cat "$BBLO" | grep -A 42 -B 2 '| 10 |'
	
	}

	if [[ $DISP = 1 ]]; then
	"DISPLAY"
	
	elif [[ ! -f $BBLO && $CONF = 1 ]]; then
	echo $LINS
	echo "|"
	echo "| Current Black Board not found, generating."
	echo "|"
	bash "$CDIR"/Black_Board_3.bash && x=3	
	"DISPLAY"
	

	elif [[ $x != 3 && $CONF = 1 && $DISP != 1 ]]; then
	"DISPLAY"
	echo $LINS
	echo -n "| Would you like to update the Black Board" && "YES_NO"
	
		if [[ $? = 0 ]]; then
		bash "$CDIR"/Black_Board_3.bash
		"DISPLAY"
		fi

	else
	return 1
	fi

}

YES_NO () {

unset RET

	while [[ -z $RET ]]; do 
	read -p " (y/n)?: " YESNO
	YESNO=${YESNO,,}
	
		if [[ ! $YESNO =~ ^(yes|y)$ && $CONF = 1 ]]; then
		echo -n "Are you sure" && read -p " (y/n)?: " YESTW
		YESTW=${YESTW,,}
		
			if [[ $YESTW =~ ^(yes|y)$ ]]; then
			RET="1" && break
			else
			break
			fi
			
		elif [[ ! $YESNO =~ ^(yes|y)$ ]]; then 
		RET="1" && break
		else 
		break
		fi

	done

RET=${RET:-0}

	if [[ $EXIT != 0 && $RET == 1 ]]; then 
	exit 1
	fi

return $RET

}

USR_INPUT () {

	while [[ -z $INPT ]]; do
	read -ep " Input?: " INPT
	
		if [[ $CONF = 1 ]]; then 
		echo -n "| You have selected $INPT" && "ARGUMENTS" -x 1 && "YES_NO"
		fi
	
	done

eval ${1:-UI}=\$INPT

}

STORAGE_DROP () {

SIZE=$((THRS*150/100))
	
	SIMULATE () {

	ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP "fallocate -l ${SIZE}$DSPS Test_File.txt"
	sleep 1
	ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP "seq $STAR $STOP | sort -R | head -n 1 > timer.txt"
	sleep 1
	ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP "cat timer.txt | xargs sleep && rm -f Test_File.txt; rm -f timer.txt" &
	
	}


	if [[ $TEST = 1 ]]; then 
	"SIMULATE" $@
	fi

	while [[ -z $OGST || -z $OGST_STO ]]; do
	OGST=$(ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP df --total -B"$DSPS" | grep "total" | awk '{print $3}' | tr -d "GMKTB")
	OGST_STO=$(ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP df --total -B"$DSPS" | grep "total" | awk '{print $2" "$3" "$4}' | tr -d "GMKTB")
	done

HITT=$((OGST - THRS))
OGST_DSP=( $OGST_STO )
a=1
b=


echo "| Checking for storage drop! Time: $(date +'%H:%M:%S') Threshhold: ${THRS}$DSPS HIt: ${HITT}$DSPS"
echo "| Original - Total: ${OGST_DSP[0]}$DSPS Used: ${OGST_DSP[1]}$DSPS Avaliable: ${OGST_DSP[2]}$DSPS"
echo "|"
echo "|"
echo "|"

	while true; do
	STOR=$(ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP df --total -B"$DSPS" | grep "total" | awk '{print $3}' | tr -d "GMKTB")
	STOR_DSP=$(ssh -i $PEMK -p $PO -o StrictHostKeyChecking=no root@$IP df --total -B"$DSPS"| grep "total" | awk '{print $2" "$3" "$4}' | tr -d "GMKTB")
	STOR_ARR=( $STOR_DSP )
	
		if [[ $STOR -lt $HITT ]];then
		tput cuu 2 && tput el
		DRAM=$((STOR - OGST))
		echo "| Storage drop detected! Time: $(date +'%H:%M:%S') Check: $a Dropped: $DRAM$DSPS"
		echo "| Current - Total: ${STOR_ARR[0]}$DSPS Used: ${STOR_ARR[1]}$DSPS Avaliable: ${STOR_ARR[2]}$DSPS"
		echo $LINS
		break
		
		elif [[ $a -lt $TRYS ]]; then
		tput cuu 2 && tput el
		echo "| Time: $(date +'%H:%M:%S') Check: $a Max: $TRYS Waiting for storage to drop... "
		echo "| Current - Total: ${STOR_ARR[0]}$DSPS Used: ${STOR_ARR[1]}$DSPS Avaliable: ${STOR_ARR[2]}$DSPS"
		sleep 1
		((a++))
		else 
		tput cuu 2 && tput el
		echo "| Max storage checks reached! Check: $a Time: $(date +'%H:%M:%S')"
		echo "| Current - Total: ${STOR_ARR[0]}$DSPS Used: ${STOR_ARR[1]}$DSPS Avaliable: ${STOR_ARR[2]}$DSPS"
		echo -n "| Continue checking" && "YES_NO"
		
			if [[ $? = 0 ]]; then
			tput cuu 1 && tput el
			a=
			continue
			else 
			break 
			fi
			
		fi
		
	done

return $a

}

SERIAL () {

	while true; do
	echo -n "| Enrer ${PRNT} serial" && read -ep " SN: " -i "SERIAL-N-" USRIN
	SERNU=${USRIN//[^A-Z0-9\-]/}
	LONG=${#SERNU}

		if [[ $LONG != 25 ]] && [[ $LONG != 18 ]]; then 
		echo -n "| Invalid Serial number, try again" && "ARGUMENTS" -x 1 && "YES_NO"

			if [[ $? != 1 ]]; then 
			((a++))
			echo -n "| Try number ${a}"
			continue
			fi

		else

			if [[ $LONG = 25 ]]; then	
			SERNU=$(echo $SERNU | cut -b 12-26)
			tput cuu 1 && tput el
			echo "| Serial number: $SERNU"
			fi

		break
		fi

	done

((q++))
export q=$q
export SNUM="SN${q}" && eval export \$SNUM=\$SERNU
return 1

}

SERVICE_RESTART () {

a=
b=
c=

	while true; do
	
		if [[ -z $a ]]; then
		a=1
		"whale" $@
		
			if [[ -z $b ]]; then
			VUON=$(ssh -i $PEMK -o StrictHostKeyChecking=no -p $PO root@$IP 2> /dev/null service Tony status | grep "Active" | awk -F'[-|:]' '{print $3"-"$4":"$5}')
			SSHR=$(ssh -i $PEMK -o StrictHostKeyChecking=no -p $PO root@$IP 2> /dev/null "service Tony restart")
			SHRT=$?
			b=1
			continue
			fi
			
		elif [[ -z $VUON || -z $SHRT ]]; then
		a=
		b=
		continue
		elif [[ -z $VUTW && -n $VUON && -n $SHRT ]]; then
		
			if [[ -z $c ]]; then
			echo $LINS
			echo "| Service restarted! Uptime: $VUON Restablishing connection..."
			echo $LINS
			c=1
			fi

		VUTW=$(ssh -i $PEMK -o StrictHostKeyChecking=no -p $PO root@$IP 2> /dev/null service tiger status | grep "Active" | awk -F'[-|:]' '{print $3"-"$4":"$5}')
		
			if [[ -z $VUTW ]]; then
			a=
			continue
			fi

		else
		break 2
		fi
	
	done

echo "| Success! Uptime: $VUON Current: $VUTW"
return 0

}

SSH_ACCESS () {

if [[ $CONF != 0 ]]; then
echo -n "| Enable=2 - Temp-enable=1 - Disable=0" && "USR_INPUT" TEST
echo "| Setting SSH registry value to $TEST..."
fi

	while true; do
	SSHD=$(ssh -i $PEMK -o StrictHostKeyChecking=no -p $PO root@$IP 2> /dev/null "sed -i s/t32:*./t32:$SSHS/ /proc/sys/kernel/random/uuid")
	SSHT=$(ssh -i $PEMK -o StrictHostKeyChecking=no -p $PO root@$IP 2> /dev/null "cat /proc/sys/kernel/random/uuid | grep -c t32:$SSHS")
	SSTI=$(ssh -q -i $PEMK -o ConnectTimeout=1 -o StrictHostKeyChecking=no -p $PO root@$IP "stat /proc/sys/kernel/random/uuid | grep Modify | cut -b 14-18,17-24")
	
		if [[ $SSHT = 1 ]]; then
		sleep 1
		echo "| SSH reg value is set to $SSHS. Modified: $SSTI"
		break
		
		elif [[ $SSHT != 1 && $a != $TRYS ]]; then
		echo "| ERROR: SSH reg value no set. Try: $a"
		((a++))
		sleep 1
		"whale" $@
		continue
		
		else 
		echo "| ERROR: SSH reg value no set. Try: $a, exiting..."
		exit 1
		fi

	done

}

whale () {

	SSH_STATUS () {
	
		while true; do
		export IPC=$(curl -s www.google.com | tr "{" '\n' | grep ${!SNUM} | tr -d '"}' | tr ":," "\t" | awk '{print $4}' 2> /dev/null)
		export POC=$(curl -s www.google.com | tr "{" '\n' | grep ${!SNUM} | tr -d '"}' | tr ":," "\t" | awk '{print $8}' 2> /dev/null)
		export LI=$(ssh -q -i $PEMK -o ConnectTimeout=1 -o StrictHostKeyChecking=no -p $POC root@$IPC true 2> /dev/null); ES="$?"
		
			if [[ -z $ES || $ES != 0 ]] && [[ $a -lt $TRYS ]]; then
			tput cuu 1 && tput el
			echo "| Failure $a: Max: $TRYS SN: ${!SNUM} IP: ${IPC:-Error} Port: ${POC:-Error}"
			
			elif [[ $ES = 0 ]] && [[ $a -le $TRYS ]]; then
			tput cuu 1 && tput el
			echo "| SN: ${!SNUM} IP: ${IPC:-Error} Port: ${POC:-Error}"
			break
			
			else 
			tput cuu 1 && tput el
			echo "| Failure: $a: Max: $TRYS SN: ${!SNUM} IP: ${IPC:-Error} Port: ${POC:-Error}"
			echo $LINS
			exit 0
			fi
	
		sleep 3
		((a++))
		done
		
	export SNIP="IP${q}"
	eval export \$SNIP=\$IPC
	export SNPO="PO${q}"
	eval export \$SNPO=\$POC
	return 1

	}

a=1
echo "| Checking whale connection for server ${!SNUM}"
echo "|"

	while true; do
	
	CONC=$(curl -s www.google.com | grep -c ${!SNUM})
	
		if [[ $CONC != 1 ]] && [[ $a -lt $TRYS ]]; then 
		tput cuu 1 && tput el
		echo "| Connection attempt $a of $TRYS"
		
		elif [[ $a -ge $TRYS ]]; then 
		echo "| Max connection attempts, exiting..."
		echo $LINS
		exit 1
		else 
		
		tput cuu 1 && tput el
		echo "| whale connection detected, attempt $a of $TRYS"
		echo "|"
		break	
		fi
	
	sleep 2
	((a++))
	done

 "SSH_STATUS" $@

return $a

}

TRANSFER () {

	TRANSFER_CHECK () {
	
	export z
	KEY="$4"
	TSER="$3"
	NAME="$2"
	SCP_INF="$1"
	SCP_RET="${1%%-*}"
	SCP_TIM="${1##*-}"
	SCP_SIZ=$(echo "$1" | awk -F'-|_' '{print $2}')
	FIL_SIZ=$(stat "$5" 2> /dev/null | awk '/Size/ {print $2}')
	NAME=$( echo ${NAME##*/} | cut -d "." -f 1 | cut -d "_" -f 3-10)
	NAME=${NAME#"Templates"} && NAME=${NAME#"_"}
	
	printf -v NAME %-20.20s "${NAME^}"
	printf -v FIL_SIZ %-3.3s "$FIL_SIZ"
	printf -v KEY %-2.2s "$KEY"
	printf -v SCP_RET %-1.1s "$SCP_RET"
	
		if [[ $y = 1 ]]; then
		echo "| Key | File                  | ST | Serial            | Time | Transfered  | Size |"
		echo $LINS
		((y++))
		fi
	
		if [[ $SCP_RET != 0 ]]; then
		
			if [[ ${NAME} = "hw_hostname" && $SCP_RET != 0 ]]; then
			((e--))
			fi
		
		paste <(echo "| ${KEY}") <(echo "| ${NAME//$'\n'/}") <(echo "| ${SCP_RET//$'\n'/}") <(echo "| ${TSER//$'\n'/}") <(echo "| ${SCP_TIM//$'\n'/}") <(echo "| ${SCP_SIZ//$'\n'/} Bytes   ") <(echo "|${FIL_SIZ//$'\n'/} |")  | column -s $'\t' -t | tee -a "$LOGS"
		((e++))
		else
		paste <(echo "| ${KEY//$'\n'/}") <(echo "| ${NAME//$'\n'/}") <(echo "| ${SCP_RET//$'\n'/}") <(echo "| ${TSER//$'\n'/}") <(echo "| ${SCP_TIM//$'\n'/}") <(echo "| ${SCP_SIZ//$'\n'/} Bytes  |") <(echo "${FIL_SIZ//$'\n'/} |")  | column -s $'\t' -t | tee -a "LOGS"
		fi
	
	((z++))
	
	export SCP_RET=${SCP_RET:-1}
	
	}

mkdir -p "$CDIR"/Pool_SN/"$CDAT"
mkdir -p "$WDIR"/Shipping
mkdir -p "$FDIR"/Downloaded
export SAFN="$FNAM" && export SAFD="$DISC" && export SAFP="$DEST"
DISP_DIRC=${DIRC,,}

	for a in SN IP PO; do
	declare ${a}VA="${LOCA/#/$a}"
	done
	
	for b in FNAM DISC DEST; do
	
		c=${!b}
		if [[ $c = full || ptah || name ]]; then
		declare -x SAFE_${b}=${c}
		eval export ${b}=\${$c[\$STAR]}
		fi
		
	done
	
echo "| ${DISP_DIRC^}ing files SN: ${!SNVA} IP: ${!IPVA} Port: ${!POVA}..."

	while [[ $STAR -le $STOP ]]; do
	#eval DEST=\${"$SAFD"[$STAR]}
	#eval FNAM=\${"$SAFN"[$STAR]}
	#eval DISC=\${"$SAFP"[$STAR]}
	
		if [[ $DIRC = PULL ]]; then
		PULL=$(scp -v -i $PEMK -o StrictHostKeyChecking=no -P ${!POVA} root@${!IPVA}:"${DISC}" "${DEST}/${FNAM}" 2>&1 | awk -F'[,|" "]' '/Transferred/ {print '$?'"_"$3+$6"-"$10}')
		"TRANSFER_CHECK" "$PULL" "${DISC}" "${!SNVA}" "$STAR" "${DEST}/{$FNAM}" "$LOCA"
		else
		PUSH=$(scp -v -i $PEMK -o StrictHostKeyChecking=no -P ${!POVA} "${DISC}" root@${!IPVA}:"${DEST}/${FNAM}" 2>&1 | awk -F'[,|" "]' '/Transferred/ {print '$?'"_"$3+$6"-"$10}')
		"TRANSFER_CHECK" "$PUSH" "${DISC}" "${!SNVA}" "$STAR" "${DEST}/${FNAM}" "$LOCA"
		fi

	((STAR++))
	done

}

CONFIG () {

rm -f "$FPTH"/Final/interfaces
DISP="${3:-0}"
CVSN="$1"
SNPA="$FPTH"/Downloaded/
NEPT="$FPTH"/Final/
c=1
d=1
DNS=$(cut -b 7 ${SNPA}dns | tr '\n' ' ')

	REGIS_DISP () {
	
	echo $LINS
	echo "| Registry config from $RMSN"
	echo $LINS
	echo "| ${VARNM_1:-None} Format: $CON_1"
	echo "| ${VARNM_2:-None} Format: $CON_2"
	echo "| ${VARNM_3:-None} Format: $CON_3"
	echo $LINS	
	echo "| Player Configuration:"
	echo $LINS
	echo "| $RES_1"
	echo "| $RES_2"
	echo "| $RES_3"
	echo "| $RES_4"
	
	}

	IFACE_DISP () {
	
	echo $LINS
	echo "| Interface configuration:"
	echo $LINS
	awk '{print "| " $0}' "$FPTH"/Final/interfaces
	echo $LINS
	echo "| DNS Servers:"
	echo $LINS
	echo "$DISP_DNS"
	echo $LINS
	echo "| NTP Servers:"
	echo $LINS
	echo "$DISP_NTP"
	echo $LINS
	
	}


cp "${SNPA}"dns "${NEPT}"dns
cp "${SNPA}"ntp "${NEPT}"ntp
cp "${SNPA}"ntp
DISP_DNS=$(sed 's/[0-9]/ &/' "${NEPT}"dns | awk '{print "| " $0}')
DISP_NTP=$(sed 's/[0-9]/ &/' "${NEPT}"ntp | awk '{print "| " $0}')

	for c in {1..7}; do
	VARNM=${name[$c]##*_}

		if [[ $c -le 3 ]]; then
		export VARNM_"$c"=$(echo ${VARNM^} | cut -b 1-4)
		export CON_"$c"=$(awk -F\" '/value/ {print $2}' "${SNPA}"${name[$c]} 2> /dev/null)
		else
		export RES_"$d"="$(awk -F[_] '/Template/ {print "Player '$d': " $2}' "${SNPA}"${name[$c]} | cut -d "," -f 1)"
		((d++))
		fi

	((c++))
	done

	for a in ADMIN MEDIA1 MEDIA2; do
	export NICO=$(awk '/CONFIGIN/ && /'$a'/ {print}' "${NEPT}"interfaces_old)
	export NICM=$(awk '/CONFIGIN/ && /'$a'/ {print}' "${NEPT}"interfaces_new)
	export INTF=$(grep -A 5 "$NICM" "${NEPT}"interfaces_new | sed '/^[[:space:]]*$/d' | grep -v "CONFIGINFO:")
	export DISP_"$a"="$(echo "${NICM,,}" | awk -F, '{print "| NIC: " $2}' && echo "$INTF" | sed 's/./\u&/' | awk '{print "| " $1 ": " $2}')"
	echo "$NICO" > "${NEPT}"interface_"$a"
	echo "$INTF" >> "${NEPT}"interface_"$a"
	cat "${NEPT}"interface_"$a" >> "${NEPT}"interfaces
	echo >> "${NEPT}"interfaces
	echo "# ENDCONFIG" >> "${NEPT}"interfaces
	echo >> "${NEPT}"interfaces
	rm -f "${NEPT}"interfaces_"$a"
	done

sed -i '$d ' "${NEPT}"interfaces

	if [[ $DISP = 0 ]]; then
	"REGIS_DISP" && "IFACE_DISP"
	
	elif [[ $DISP = 1 ]]; then
	"REGIS_DISP"
	
	else
	"IFACE_DISP"
	fi

}

CHECK_SERIAL () {

while true; do

	if [[ $RMSN != $SHSN ]]; then
	break
	else	
	echo "| Serial numbers match! Exiting..."
	exit 1
	fi

done

}

REBOOTER () {

a=1

echo "| Rebooting $SN and applying config settings..."
echo $LINS

	while true; do
	"ARGUMENTS" -t 10 -s1 $SN1 && "whale"
	BOOT="$(ssh -i $PEMK -p $SHPO -o StrictHostKeyChecking=no root@$SHIP reboot 2> /dev/null | grep -c "reboot")"

		if [[ $SSHR != 1 ]]; then
		tput cuu 1 && tput el
		echo "| Reboot failure! Attempt $a..."
		
		elif [[ $a -ge $TIME && $SSHR != 1 ]]; then
		echo "| Max reboot attempts, exiting!"
		exit 1
		else
		echo "| $1 is reboting, establishing whale connection..."
		"ARGUMENTS" -t 10 -s1 $SN1 && "whale"  
		
			if [[ $? = 2 ]]; then
			echo "| $SHSN was rebooted sucessfully!"
			fi
		
		break
		fi

	sleep 1
	done

return 0

}
	
#==============================================================================================#
   "ARGUMENTS" -c 1 -d 0                                        &&  "BLACK_BOARD"              #                                                                                              
#==============================================================================================#
   "ARGUMENTS" -w "local"                                       &&  "SERIAL"                   #
#==============================================================================================#
   "ARGUMENTS" -t 5                                             &&  "whale"                    #
#==============================================================================================#
   "ARGUMENTS" -w "remote"                                      &&  "SERIAL"                   #
#==============================================================================================#
   "ARGUMENTS" -x 0                                             $$ "CHECK_SERIAL"              #
#==============================================================================================#
   "ARGUMENTS" -t 5                                             &&  "whale"                    #
#==============================================================================================#
   "ARGUMENTS" -b 1 -e ${ARLE} -i2 $IP2 -p2 $PO2 -s2 $SN2       &&  "TRANSFER"                 #
#==============================================================================================#
   "ARGUMENTS" -v 1                                             &&  "CONFIG"                   #
#==============================================================================================#
   "ARGUMENTS" -b 1 -e 15 -i1 $IP1 -p1 $PO1 -s1 $SN1 -u PUSH    &&  "TRANSFER"                 #
#==============================================================================================#
   "ARGUMENTS" -f 1 -h 50 -b 30 -e 60 -m 90 -s G -t 100         &&  "STORAGE_DROP"             #
#==============================================================================================#
   "ARGUMENTS" -f 0                                             &&  "SSH_ACCESS"               #
#==============================================================================================#
   

