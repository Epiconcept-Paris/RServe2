# RServe2
R Server based on Debian 10

## Gestion des processus
Le fichier de /etc/Rserv.conf contient la ligne:
 - tag.argv enable
 
Cela permet de distinguer le processus principal des processus fils. Exemple de ps aux:

**USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND**   
root         1  0.0  0.0   2388   752 ?        Ss   16:38   0:00 /bin/sh   
root        17  0.0  0.5 194280 61896 ?        Ss   16:39   0:00 /usr/lib/R/bi/RsrvSRV --no-save   
root        27  0.0  0.4 196332 60216 ?        S    16:46   0:00 /usr/lib/R/bi/RsrvCHq --no-save   
root        29  0.0  0.4 196332 60216 ?        S    16:47   0:00 /usr/lib/R/bi/RsrvCHq --no-save   

 - /usr/lib/R/bi/RsrvSRV est le processus serveur principal
 - /usr/lib/R/bi/RsrvCHq est un processus (fork) fils

En cas de non réponse du serveur on peut tuer le processus fils le plus vieux pour tenter de débloquer la situation.

## Mémoire
Comme on peut le voir ci-dessus, un processus utilise environ **200Mo** de mémoire rien que pour la connexion. Si on execute un simple script cela peut très vite augmenter. Ci dessous, un ***ps aux*** avec le troisième processus exécutanr un simple script:

**USER       PID %CPU %MEM     VSZ    RSS TTY    STAT START   TIME COMMAND**   
root         1  0.0  0.0    2388    752 ?      Ss   16:38   0:00 /bin/sh   
root        17  0.0  0.5  194280  61896 ?      Ss   16:39   0:00 /usr/lib/R/bi/RsrvSRV --no-save   
root        27  0.0  0.4  196332  60216 ?      S    16:46   0:00 /usr/lib/R/bi/RsrvCHq --no-save   
root        29  0.1  1.5 3481784 189084 ?      Sl   16:47   0:01 **/usr/lib/R/bi/RsrvCHq --no-save**   

Comme on peut le voir, la mémoire demandée par un simple script est d'environ **3.4Go**!
