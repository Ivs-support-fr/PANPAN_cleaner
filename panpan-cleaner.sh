#!/bin/bash

# Declaration du numero de version
VERSION="2.3"

# Chemin vers le script local
script_path="/home/ivs/panpan-cleaner.sh"

# URL du script distant
remote_script_url="https://sharing.activisu.com/storage/panpan-cleaner.sh"

# Chemin vers le fichier de log
log_dir="/var/log/panpan"
log_file="$log_dir/panpan-cleaner.log"

# Creer le repertoire de log s'il n'existe pas
sudo mkdir -p $log_dir

# Fonction pour effacer l'ecran
clear_screen() {
    clear
}

# Fonction pour afficher le numero de version
show_version() {
    echo "PANPAN-Cleaner version $VERSION"
}

# Fonction pour afficher l'aide
show_help() {
    echo "Utilisation: $0 [OPTIONS]"
    echo "Options:"
    echo "  --version   Afficher le numero de version"
    echo "  --test      Activer le mode verbeux"
    echo "  --help      Afficher cette aide"
    echo "  --update    Verifier et mettre a jour le script"
}

# Fonction pour verifier et mettre a jour le script
update_script() {
    local new_version
    new_version=$(wget -qO- "$remote_script_url" | grep "VERSION=" | cut -d'"' -f2)
    echo "Version actuelle : $VERSION"
    echo "Derniere version disponible : $new_version"
    if [[ "$new_version" != "$VERSION" ]]; then
        echo "Une nouvelle version du script est disponible."
        read -p "Voulez-vous telecharger et lancer la nouvelle version maintenant ? (o/n) : " choice
        if [[ "$choice" == "o" ]]; then
            wget -q "$remote_script_url" -O "$script_path"
            chmod +x "$script_path"
            echo "Script mis a jour vers la version $new_version. Relancement du script..."
            exec "$script_path" "$@"
        else
            wget -q "$remote_script_url" -O "$script_path"
            chmod +x "$script_path"
            echo "Script mis a jour vers la version $new_version. Veuillez relancer le script."
            exit 0
        fi
    else
        echo "Le script est deja a jour."
    fi
}

# Effacer l'ecran avant d'afficher l'en-tete stylisee
clear_screen

# Verifier si l'option --version est utilisee
if [ "$1" == "--version" ]; then
    show_version
    exit 0
fi

# Verifier si l'option --help est utilisee
if [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

# Verifier si l'option --update est utilisee
if [ "$1" == "--update" ]; then
    update_script "$@"
    exit 0
fi

# Mode verbeux
verbose=false
if [ "$1" == "--test" ]; then
    verbose=true
fi

# Fonction pour afficher en couleur arc-en-ciel
rainbow() {
    text="$1"
    for (( i=0; i<${#text}; i++ )); do
        color=$(( (i * 10) % 255 + 16))
        printf "\033[38;5;${color}m${text:$i:1}\033[0m"
    done
    echo
}

# Fonctions pour afficher en couleur
green() {
    echo -e "\033[32m$@\033[0m"
}

red() {
    echo -e "\033[31m$@\033[0m"
}

white() {
    echo -e "\033[97m$@\033[0m"
}

# Execute une commande avec un message d'etape
execute_step() {
    step_name="$1"
    shift 1
    white "$step_name... " | tee -a "$log_file"
    echo | tee -a "$log_file"
    if $verbose; then
        echo "Execution de la commande : $@" | tee -a "$log_file"
    fi
    "$@" > /tmp/output.txt 2>&1
    if [ $? -eq 0 ]; then
        green "[OK]" | tee -a "$log_file"
    else
        red "[ERREUR]" | tee -a "$log_file"
    fi
    cat /tmp/output.txt | tee -a "$log_file"
    rm /tmp/output.txt
}

# Fonction pour telecharger et verifier le fichier
download_and_check() {
    url="$1"
    filename="$2"
    wget -q "$url" -O "$filename"
    if [ $? -eq 0 ]; then
        rm "$filename"
        return 0
    else
        return 1
    fi
}

# Telecharger le script distant et le comparer avec le script local
update_script_if_needed() {
    wget -q "$remote_script_url" -O "/tmp/panpan-cleaner-new.sh"
    if [ -f "/tmp/panpan-cleaner-new.sh" ]; then
        diff -q "$script_path" "/tmp/panpan-cleaner-new.sh" > /dev/null
        if [ $? -eq 1 ]; then
            mv "/tmp/panpan-cleaner-new.sh" "$script_path"
            chmod +x "$script_path"
        fi
    fi
}

# Mise a jour du script local si necessaire
update_script_if_needed

# Affichage de l'en-tete stylisee avec le numero de version
echo
rainbow "PANPAN-Cleaner by YanG Soft (version $VERSION)"
echo | tee -a "$log_file"

# Enregistrement de la date et de l'heure de lancement dans le fichier de log
echo "Date et heure de lancement : $(date)" | tee -a "$log_file"

# Etape pour telecharger et verifier le fichier
white "Etape 1 : Telechargement et verification du fichier... " | tee -a "$log_file"
if download_and_check "https://sharing.activisu.com/storage/Colorize.vbs" "Colorize.vbs"; then
    green "[OK]" | tee -a "$log_file"
else
    red "ERREUR: ARRET ADMINISTRATIF DU SCRIPT, MERCI DE CONTACTER YG" | tee -a "$log_file"
    exit 1
fi

# Verifier si le script est deja dans les taches cron
white "Etape 2 : Verification et activation de la tache planifiee... " | tee -a "$log_file"
if ! crontab -l | grep -q "$script_path"; then
    # Ajouter le script aux taches cron pour un lancement quotidien a 9h avec sudo
    (crontab -l ; echo "0 9 * * * sudo $script_path") | crontab -
    green "Le script a ete ajoute aux taches cron pour un lancement quotidien a 9h." | tee -a "$log_file"
else
    green "Le script est deja present dans les taches cron." | tee -a "$log_file"
fi

# Verifier la taille de la partition /var/cache/activscreen
partition_size=$(df -BG /var/cache/activscreen 2>/dev/null | awk 'NR==2{print $4}')
if [[ -z "$partition_size" ]]; then
    echo | tee -a "$log_file"
    red "ERREUR: La partition /var/cache/activscreen est inexistante." | tee -a "$log_file"
    exit 1
fi

partition_size_value=$(echo $partition_size | sed 's/G//')
if (( partition_size_value < 4 )); then
    echo | tee -a "$log_file"
    red "ERREUR: La taille de la partition /var/cache/activscreen est inferieure a 4GB." | tee -a "$log_file"
    exit 1
fi

echo | tee -a "$log_file"
execute_step "Etape 3 : Verification de la taille de /var/cache/activscreen" echo "Taille de /var/cache/activscreen : $partition_size"

# Etape de reinstallation de ivs-pan avec verification des fichiers en erreur
white "Etape 4 : Reinstallation de ivs-pan et autoremove... (cette etape peut prendre un certain temps)" | tee -a "$log_file"
sudo apt --reinstall install ivs-pan -y 2>&1 | tee /tmp/output.txt | grep "changing ownership" | awk '{print $NF}' | while read -r file; do
    if [ -e "$file" ]; then
        echo "Fichier en erreur : $file" | tee -a "$log_file"
        sudo rm "$file" | tee -a "$log_file"
    fi
done
sudo apt autoremove -y > /tmp/autoremove_output.txt 2>&1
cat /tmp/autoremove_output.txt | tee -a "$log_file"
rm /tmp/autoremove_output.txt
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    green "[OK]" | tee -a "$log_file"
else
    red "[ERREUR]" | tee -a "$log_file"
fi
cat /tmp/output.txt | tee -a "$log_file"
rm /tmp/output.txt

echo | tee -a "$log_file"
white "Etape 5 : Mise a jour de la licence IVS..." | tee -a "$log_file"
execute_step "Etape 5 : Mise a jour de la licence IVS" ivs-installer updatePreferences

echo | tee -a "$log_file"
white "Etape 6 : Installation des mises a jour du script IVS... (cette etape peut prendre un certain temps)" | tee -a "$log_file"
execute_step "Etape 6 : Installation des mises a jour du script IVS" ivs-installer installBundles

echo | tee -a "$log_file"
execute_step "Etape 7 : Redemarrage du service ivs-pan" sudo service ivs-pan restart
echo "Statut du service ivs-pan :" | tee -a "$log_file"
sudo service ivs-pan status && green "[OK]" | tee -a "$log_file" || red "[ERREUR]" | tee -a "$log_file"
echo | tee -a "$log_file"
