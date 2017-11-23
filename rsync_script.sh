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
  number=$number                  # if $maxcount is a Number variable

# delete sourcedir_tmp if exist
  if [[ -f sourcedir_tmp ]]; then # sollte die Datei existiere > löschen
   rm sourcedir_tmp            
  fi
# make sourcedir_tmp
  touch sourcedir_tmp             # erstellen von temporären Quelordner-Datei

# input counter $maxcount
 echo -e "Wie viele Ordner sind zu Kopieren?"
 read -r maxcount

# $maxcount can not be empty
 while [[ "$maxcount" = "" ]]; do
   echo -e "Error: Anzahl ist leer"
   echo -e "Wie viele Ordner sind zu Kopieren?"
   read -r maxcount
 done #end $maxcount check
 
# check if $maxcount is number
number='^[0-9]+$'
if ! [[ $maxcount =~ $number ]] ; then
   echo "Error: Anzahl ist keine Zahl" >&2; ./rsync_script.sh 1
fi


for (( i = 0; i < $maxcount; i++)); do

  # input $sourcedir
  echo -e "Welcher Ordner soll kopiert werden?(vom qnap)"

  read -r sourcedir

  # $sourcedir can not be empty
  while [[ "$sourcedir" = "" ]]; do
    echo -e "Error: Quellordner ist leer"
    echo -e "Welche Ordner soll kopiert werden?(vom qnap)"
    echo -e ""
    read -r sourcedir
  done #end $sourcedir check

  echo "$sourcedir" >> $source_files
done
  # input $destdir
  echo -e "Wohin soll der Ordner kopiert werden?(local)"
  read -r destdir

  # $destdir can bot be empty
  while [[ "$destdir" = "" ]]; do
    echo -e "Error: Quellordner ist Leer"
    echo -e "Wohin soll der Ordner kopiert werden?(local)"
    echo -e ""
    read -r destdir
  done #end $destdir check

  # input $cpuser
  echo -e "Mit welchem user soll Kopiert werden?[suv]"
  read -r cpuser

  # input $cpuser fallback
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


# final output of all inputs
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

# final question if start or restart
  case $confirm in
    y*|Y*|j*|J*|"" )
      echo
      echo -e "GOGO GADGET"
      rsync -avzh --progress --dry-run --files-from=$source_files $cpuser@$cpserver:/ $destdir
      ;;
    n*|N* )
      echo -e "Ordentlich Tippen! Script restart"
      ./rsync_script.sh
  esac