#!/bin/bash

# variables

  maxcount=$maxcount              # Anzahl an Ordnern, die kopiert werden sollen
  sourcedir=$sourcedir            # Qullordner (wird in source_files geschrieben)
  destdir=$destdir                # Zielordner
  cpuser=$cpuser                  # User auf Zeilserver
  confirm=$confirm                # Finale Abfrage, ob der Vorgang gestartet werden soll
  cpserver=$cpserver              # Zeilserver
  sourcedir_tmp=$source_files     # Datei für Quellordner
  source_files=./sourcedir_tmp    # Ort für Quellordner File

# temp datei löschen wenn existent
  if [[ -f sourcedir_tmp ]]; then # sollte die Datei existiere > löschen
   rm sourcedir_tmp            
  fi
  touch sourcedir_tmp             # erstellen von temporären Quelordner-Datei

# Wieviele Ordner insgesammt $maxcount
 echo -e "Wie viele Ordner sind zu Kopieren?"
 read -r maxcount
 while [[ "$maxcount" = "" ]]; do
   echo -e "Die Anzahl der Ordner darf nicht Leer / 0 sein"
   echo -e "Wie viele Ordner sind zu Kopieren?"
   read -r maxcount
 done #ende $maxcount check


# for (( i = 0; i < $maxcount; i++ )); do
for (( i = 0; i < $maxcount; i++)); do

  # Welche(r) Ordner $sourcedir
  echo -e "Welcher Ordner soll kopiert werden?(vom qnap)"

  read -r sourcedir
  while [[ "$sourcedir" = "" ]]; do
    echo -e "Quellordner darf nicht Leer sein"
    echo -e "Welche Ordner soll kopiert werden?(vom qnap)"
    echo -e ""
    read -r sourcedir
  done #ende $sourcedir check

  echo "$sourcedir" >> $source_files
done
  # Wohin soll kopiert werden $destdir
  echo -e "Wohin soll der Ordner kopiert werden?(local)"
  read -r destdir
  while [[ "$destdir" = "" ]]; do
    echo -e "Zeilordner nach nicht leer sein"
    echo -e "Wohin soll der Ordner kopiert werden?(local)"
    echo -e ""
    read -r destdir
  done #ende $destdir check

  # Welcher User soll genutzt werden $cpuser
  echo -e "Mit welchem user soll Kopiert werden?[suv]"
  read -r cpuser
  while [[ "$cpuser" = "" ]]; do
    cpuser=suv
  done #ende $cpuser check

  echo -e "Von welchem Server soll kopiert werden?[tiffy]"
  read -r cpserver
  while [[ "$cpserver" = "" ]]; do
    cpserver=tiffy
    # echo -e "Server darf nicht leer sein"
    # echo -e "Von welchem Server soll kopiert werden?"
    # read -r cpserver
  done #cpuser check



  echo -e "Quellordner:"
  cat $source_files
  echo -e "--------------------"
  echo -e "Zeilordner: $destdir"
  echo -e ""--------------------""
  echo -e "Copy User: $cpuser"
  echo -e ""--------------------""
  echo -e "Server: $cpserver"

  echo -e "Sind diese Angaben richtig ? [Y]es / [N]o"
  read -r confirm

  case $confirm in
    y*|Y*|j*|J*|"" )
      echo
      echo -e "GOGO GADGET"
      rsync -avzh --progress --dry-run --files-from=$source_files $cpuser@$cpserver:/ $destdir
      ;;
    n*|N* )
      echo -e "Ordentlich Tippen! Script restart"
      ./rsync_script_3
  esac
# done #ende for $maxcount