_:
''
  #!/usr/bin/env zsh
  #This script provides a rofi menu interface for wifi control
  #It uses and requires nmcli
  get_match()
  {
    selection=$(echo -e "$1" | rofi -dmenu -p "$2")
    [[ -z "$selection" ]] && exit 1
    does_match_=$(echo -e "$1" | grep "$selection")
    [[ -n "$1" ]] && [[ -z "$does_match_" ]] && exit 1
    echo "$selection"
  }

  toggle_entry="WiFi"
  create_option="Manual connection"


  #Checks if wifi is currently enabled
  state=$(nmcli -fields WIFI g)
  enable_test=$(echo "$state" | grep "enabled")
  echo $enable_test
  if [[ -z "$enable_test" ]]; then
  	toggle="$toggle_entry on"
    selection=$(get_match "Yes\nNo" "Enable WiFi")
    if [ $selection = "Yes" ];then
      nmcli radio wifi on
    fi
    exit 1
  else
  	toggle="$toggle_entry off"
  fi

  fields="SSID,BARS,SECURITY"
  lines_full=$(nmcli --fields $fields dev wifi list|sed "/\(^--\|$(echo $fields|cut -d',' -f1)\)/d"|sed 's/\s\{2,\}/_:_/g')
  lines=$(echo -e "$lines_full"| awk -F "_:_" '{print $1"  "$2}')
  cons=$(nmcli con show)
  current=$(iwgetid -r)
  ssid_field=$(echo -e "$fields"| awk  'BEGIN{FS=","}{for(i=1;i<=NF;++i) {if($i ~ "SSID") print i}}')


  #Takes input from the user using a rofi menu
  selection=$(get_match "$toggle\n$lines\n$create_option" "WiFi")
  selected_ssid=$(echo $selection|sed 's/\s\{2,\}/|/g'|awk -F "|" "{print \$$ssid_field}" )

  #Create new connection
  if [ "$selected_ssid" = "$create_option" ]; then
    manual_ssid=$(echo "Enter the SSID of the network." | rofi -dmenu -p "SSID" -config ~/.dotfiles/rofi/config.rasi)
    if [ -z "$manual_ssid" ];then
      exit 1
    fi
  #if connection already exists
    matches00=$(echo -e "$cons" |sed 's/\s\{2,\}/|/g'|awk -F "|" "/$manual_ssid/{print \$1}")
    if [[ -n "$matches00" ]];then #If a match exists to the selected networks 
      n_matches00=$(echo -e "$matches00" |wc -l)
      if [[ "$n_matches00" -eq "1" ]]; then #If only one match, connect
        nmcli con up "$manual_ssid"
      else #if more matches, prompt selection menu for which one to choose
        chosen_cons00 = $(get_match "$matches00" "Which")
        nmcli con up "$chosen_cons00"
      fi
    else
      #if no matches
      manual_password=$(echo "Enter the Password of the network (or leave blank)." | rofi -dmenu -p "Password" -config ~/.dotfiles/rofi/config.rasi)
      if [ "$manual_password" = "" ];then
        nmcli dev wifi con "$manual_ssid"
      else
        nmcli dev wifi con "$manual_ssid" password "$manual_password"
      fi
    fi
  #Toggle wifi on
  elif [ "$selected_ssid" = "$toggle_entry on" ];then
    nmcli radio wifi on
  #Toggle wifi off
  elif [ "$selected_ssid" = "$toggle_entry off" ];then
    nmcli radio wifi off
  #An existing connection was selected
  elif [[ -n "$selection" ]];then
    matches=$(echo -e "$cons" |sed 's/\s\{2,\}/|/g'|awk -F "|" "/$selected_ssid/{print \$1}")

    if [[ -n "$matches" ]];then #If a match exists to the selected networks 
      n_matches=$(echo -e "$matches" |wc -l)
      if [[ "$n_matches" -eq "1" ]]; then #If only one match, connect
        nmcli con up "$selected_ssid"
      else #if more matches, prompt selection menu for which one to choose
        chosen_cons = $(get_match "$matches" "Which")
        nmcli con up "$chosen_cons"
      fi

    else #if no matches
      wlan_=$(nmcli dev|grep wifi|sed 's/ \{2,\}/|/g'|cut -d'|' -f1)  
      sec0=$(echo -e "$lines_full"|grep "$selected_ssid"| awk '/802\.1X/')

      #if security is 802.1x
      if [[ -n "$sec0" ]];then
        user_name=$(echo "Enter identity." | rofi -dmenu -p "Identity" -config ~/.dotfiles/rofi/config.rasi)
        if [[ -z "$user_name" ]];then
          exit 1
        fi
        password0=$(echo "Enter password of your identity (or leave empty)." | rofi -dmenu -p "Password" -config ~/.dotfiles/rofi/config.rasi)
        n_matches_=$(echo -e "$wlan_"|wc -l)
        #if more than one wlan device let user pick
        if [[ "$n_matches_" -gt "1" ]];then
          wlan_=$(get_match "$wlan_" "ifname")
        fi
        #add connection
        nmcli con add type wifi con-name "$selected_ssid" ifname "$wlan_" ssid "$selected_ssid" -- \
          wifi-sec.key-mgmt wpa-eap 802-1x.eap ttls \
          802-1x.phase2-auth mschapv2 802-1x.identity "$user_name" 802-1x.password "$password0"
        #connect
        nmcli con up "$selected_ssid"
      #if security is not 802.1x
      else
        sec=$(echo -e "$lines_full"|grep "$selected_ssid"| awk '/(WPA|WEP)/')
        if [[ -n "$sec" ]];then #if network is secured, prompt for password
          password_=$(echo "Enter password of the newtork (or leave blank)." | rofi -dmenu -p "Password" -config ~/.dotfiles/rofi/config.rasi)
        fi
        nmcli dev wifi con "$selected_ssid" password "$password_"
      fi
    fi
  fi

''

