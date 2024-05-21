

## Description

PANPAN-Cleaner est un script de maintenance pour les systèmes Linux. Il permet de vérifier la taille des partitions, de réinstaller et nettoyer les paquets `ivs-pan`, de mettre à jour la licence et les bundles IVS, ainsi que de redémarrer les services nécessaires. Le script inclut également des fonctionnalités d'auto-mise à jour.

## Fonctionnalités

- Vérification de la taille de la partition `/var/cache/activscreen`.
- Réinstallation et nettoyage des paquets `ivs-pan`.
- Mise à jour de la licence IVS.
- Installation des mises à jour des bundles IVS.
- Redémarrage des services `ivs-pan`.
- Auto-mise à jour du script.
- Journalisation détaillée des opérations effectuées.
- Mode verbeux pour des informations supplémentaires lors de l'exécution.

## Prérequis

- Système d'exploitation Linux.
- Paquets `ivs-pan` et `ivs-installer` installés.
- Droits `sudo`.

## Installation

1. Clonez le dépôt GitHub :
   ```bash
   git clone https://github.com/votre-utilisateur/panpan-cleaner.git
Accédez au répertoire du script :

bash
Copier le code
cd panpan-cleaner
Rendez le script exécutable :

bash
Copier le code
chmod +x panpan-cleaner.sh
Utilisation
Options disponibles
--version : Affiche la version actuelle du script.
--test : Active le mode verbeux pour des informations détaillées lors de l'exécution.
--help : Affiche l'aide avec les options disponibles.
--update : Vérifie et met à jour le script.
Exemples
Exécuter le script normalement :

bash
Copier le code
sudo ./panpan-cleaner.sh
Exécuter le script en mode verbeux :

bash
Copier le code
sudo ./panpan-cleaner.sh --test
Vérifier et mettre à jour le script :

bash
Copier le code
sudo ./panpan-cleaner.sh --update
Afficher la version actuelle du script :

bash
Copier le code
sudo ./panpan-cleaner.sh --version
Afficher l'aide :

bash
Copier le code
sudo ./panpan-cleaner.sh --help
Journalisation
Le script enregistre toutes les actions effectuées dans un fichier log situé dans /var/log/panpan/panpan-cleaner.log.

Contribuer
Les contributions sont les bienvenues ! Pour contribuer, veuillez cloner ce dépôt et soumettre une pull request.

Fork le projet
Créez votre branche de fonctionnalité (git checkout -b feature/AmazingFeature)
Committez vos changements (git commit -m 'Add some AmazingFeature')
Push sur la branche (git push origin feature/AmazingFeature)
Ouvrez une Pull Request
Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

css
Copier le code

Enregistrez ce contenu dans un fichier nommé `README.md` dans le répertoire de votr
