message("Start packages installation\n")

# Liste des paquets à installer. 
# A compléter si nécessaire
packages=c(
 "survey",
 'kableExtra',
 'fmsb',
 'gapminder',
 'wordcloud',
 "ggrepel"
)

message("Packages list:");
message(paste(packages, collapse = ", "));

# Adresses pour le téléchargement des paquets
repositories=c(c("http://ftp.igh.cnrs.fr/pub/CRAN/", "https://mirror.ibcp.fr/pub/CRAN/"));

# Installation des paquets par stack de 25 éléments à la fois
stackSize = 50;
for (index in seq(1, length(packages), stackSize)) {
  lastIndex = index + stackSize - 1;
  if (lastIndex > length(packages)) {
    lastIndex = length(packages);
  }
  
  install.packages(
    packages[index: lastIndex],
    repos=repositories,
    verbose=TRUE,
    # Fait interrompre le build Travis car il n'a pas de sorti pendant trop longtemps!
    #quiet=TRUE,
    # slow mode
    Ncpus=8
  );
  
  message("Installation done for this batch:\n");
  message(paste(packages[index: lastIndex], collapse = ",\n"));
}

# Vérification de l'installation des paquets. Si un paquet n'a
# pu être installé, le script renvoi un code d'erreur.
installedPackages=packages %in% installed.packages()[,1];
if (sum(installedPackages, na.rm = TRUE) != length(packages)) {  
  # Liste des paquets n'ayant pu être installés
  unInstalledPackages=packages[ !installedPackages ];
  message("Some package could not be installed:")
  message(paste(unInstalledPackages, collapse = ",\n"));
  quit(status=1) 
}

message("Installation done.\n")

