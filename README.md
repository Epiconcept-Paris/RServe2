# RServe2
R Server based on Debian 10

## Gestion des processus
Le fichier de /etc/Rserv.conf contient la ligne:
 - tag.argv enable
 
Cela permet de distinguer le processus principal des processus fils. Exemple de ps aux:

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND   
root         1  0.0  0.0   2388   752 ?        Ss   16:38   0:00 /bin/sh   
root        17  0.0  0.5 194280 61896 ?        Ss   16:39   0:00 /usr/lib/R/bi/RsrvSRV --no-save   
root        27  0.0  0.4 196332 60216 ?        S    16:46   0:00 /usr/lib/R/bi/RsrvCHq --no-save   
root        29  0.0  0.4 196332 60216 ?        S    16:47   0:00 /usr/lib/R/bi/RsrvCHq --no-save   
