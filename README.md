# -analyse-de-signaux-d-lectromyographie
Analyse des Signaux EMG

Introduction au Projet

Ce projet porte sur l’analyse des signaux électromyographiques (EMG), enregistrés à l’aide de capteurs placés sur des muscles pour étudier leur activation. Deux gestes ont été analysés : le "double tap" et le "fist". L’objectif était de développer un programme Matlab capable de charger, visualiser et analyser ces signaux pour identifier les périodes d’activité musculaire.

Ce travail combine une approche technique, avec le développement d’une solution logicielle, et une démarche scientifique pour comparer ces deux gestes à partir de leurs signaux EMG.


Objectifs et Hypothèses

Objectifs

Les principaux objectifs de ce projet sont les suivants :

Développer un programme en Matlab capable de charger et visualiser les signaux EMG de deux gestes différents.

Analyser les périodes d’activité musculaire pour chacun des gestes, en identifiant les phases d’activation et de repos.

Appliquer des techniques de traitement du signal, notamment la convolution, pour lisser les données et mettre en évidence les tendances globales des signaux.

Comparer les signaux des gestes "double tap" et "fist" pour observer les différences en termes d’amplitude et de durée.

Hypothèses

Voici les hypothèses formulées avant l’analyse des signaux :

Le geste "fist" produira des amplitudes plus élevées car il demande plus d’effort musculaire que le "double tap".

Les périodes d’activation seront plus longues pour le "fist", car c’est un mouvement plus soutenu.

La convolution aidera à clarifier les signaux en réduisant le bruit.

Un seuil permettra de mieux identifier les moments où les muscles sont actifs, en filtrant le bruit.

Développement Logiciel

Chargement des Données

Les données EMG sont chargées à partir de fichiers texte contenant les signaux captés par 8 capteurs.

% Charger les données du fichier
data_tap = load('double_tapMat.txt');
data_fist = load('fistMat.txt');

Affichage des Signaux

Les signaux capturés sont affichés pour chaque capteur en utilisant des graphiques organisés en grille pour une comparaison visuelle rapide.

figure('Name', 'Signaux de double_tapMat.txt');
for capteur = 1:8
    subplot(4, 2, capteur);
    plot(data_tap(:, 1), data_tap(:, capteur + 1));
    title(['Capteur ' num2str(capteur)]);
end

Affichage Comparatif du Signal 8

Le signal du capteur 8 est comparé pour les deux gestes.

figure('Name', 'Comparaison Double Tap et Fist');
subplot(2, 1, 1);
plot(data_tap(:, 1), data_tap(:, 9));
title('Capteur 8 - Double Tap');
subplot(2, 1, 2);
plot(data_fist(:, 1), data_fist(:, 9));
title('Capteur 8 - Fist');

Calcul des Moyennes des Capteurs

Les moyennes des valeurs captées par chaque capteur sont calculées pour chaque geste.

moyennes_tap = mean(data_tap(:, 2:end), 1);
moyennes_fist = mean(data_fist(:, 2:end), 1);

Délimitation des Signaux

Un seuil est utilisé pour identifier les périodes d’activation musculaire.

seuil_tap = 0.7 * mean(abs(data_tap(:, 9)));
delim_tap = data_tap(:, 9);
delim_tap(abs(data_tap(:, 9)) < seuil_tap) = 0;

Convolution des Signaux

Une convolution est appliquée pour lisser les signaux.

T = 100;
rect_window = (abs(data_fist(:, 1) - 450) <= T / 4);
windowed_signal = data_fist(:, 9) .* rect_window;

Approche Scientifique

Analyse des Signaux Bruts

Les signaux bruts des deux gestes montrent que "fist" présente des amplitudes et fréquences plus élevées.

Application de la Convolution

La convolution réduit le bruit et met en évidence les tendances globales des signaux.

Validation des Hypothèses

Les hypothèses initiales sont confirmées :

Les amplitudes du geste "fist" sont plus élevées.

La convolution simplifie l’analyse des signaux.

Résultats

Les différences entre "double tap" et "fist" sont clairement observées, notamment en termes d’amplitude et de durée d’activation musculaire.

Auteur: 

Ismail Messaoudi


Traitement du Signal
