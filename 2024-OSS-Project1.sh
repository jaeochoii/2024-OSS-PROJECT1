#!/bin/bash

echo "************OSS1 - Project1************"
echo "*         StudentID : 12192821        *"
echo "*          Name : JaeO Choi           *"
echo "***************************************"

while true; do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"


        read -p "Enter your CHOICE (1~7): " choice

        case $choice in
                1)
                        read -p "Do you want to get the Heung-min Son's data? (y/n): " players
                        if [ "$players" = "y" ]; then
                                while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8
                                do
                                        if [ "$col1" = "Heung-Min Son" ]; then
                                                echo "Team: $col4, Apperance: $col6, Goal: $col7, Assist: $col8"
                                        fi
                                done < "players.csv"
                        fi
                        ;;

		2)
			            read -p "What do you want to get the team data of league_position[1~20]: " position
            if [ $position -ge 1 ] && [ $position -le 20 ]; then
               
                data=$(awk -v pos=$position -F ',' 'NR==pos {printf "%s %.2f\n", $1, $2/($2+$3+$4)}' teams.csv)
                echo "$position $data"
            
            fi
            ;;
		3)
			            read -p "Do you want to know Top-3 attendance data and average attendance? (y/n): " answer3
            echo ""
            if [ "$answer3" = "y" ]; then
		echo "***Top-3 Attendance Match***"
                top_matches=$(awk -F ',' 'NR>1 {print $0, $2}' matches.csv | sort -t, -k2 -nr | head -n 3)
                echo "$top_matches" | while read -r line; do
                    col2=$(echo "$line" | awk -F ',' '{print $2}')
                    col3=$(echo "$line" | awk -F ',' '{print $3}')
                    col4=$(echo "$line" | awk -F ',' '{print $4}')
                    col1=$(echo "$line" | awk -F ',' '{print $1}')
                    echo "$col3 vs $col4 ($col1)"
                    col7=$(echo "$line" | awk -F ',' '{print $7}')
                    echo "$col2  $col7"
                    echo ""
                
                done
            fi
            ;;

		4)
			read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n): " answer4
            if [ "$answer4" = "y" ]; then
                awk -F ',' 'NR > 1 {print $6","$1}' teams.csv | sort -n | while IFS=, read -r ranking team; do
                    echo "$ranking $team"
                    player=$(LC_ALL=C awk -F ',' -v team="$team" 'NR > 1 && $4 == team {print $1","$7}' players.csv | sort -t ',' -k2nr | head -n 1)
                    player_name=$(echo "$player" | cut -d ',' -f1)
                    player_score=$(echo "$player" | cut -d ',' -f2)
                    echo "$player_name $player_score"
                done
            fi
            ;;
		7)
			echo "Bye!"
			exit 0
			;;
     
        esac
done
