% Charger les données du fichier double_tapMat.txt
data_tap = load('double_tapMat.txt');
data_fist = load('fistMat.txt');

% Obtenir le nombre de capteurs (colonnes) dans les données
nbCapteurs_tap = size(data_tap, 2) - 1; % Exclure la colonne de temps

% Affichage des signaux pour double_tapMat.txt
figure('Name', 'Signaux de double_tapMat.txt', 'Position', [100, 100, 1000, 600]);

for capteur = 1:nbCapteurs_tap
    subplot(4, 2, capteur);  % Organisation en 4 lignes et 2 colonnes
    plot(data_tap(:, 1), data_tap(:, capteur + 1), 'LineWidth', 1.5);
    title(['Signal EMG de Capteur ' num2str(capteur) ' (Double Tap)']);
    xlabel('Temps');
    ylabel('Amplitude');
    grid on;
end

% Affichage des signaux pour fistMat.txt
nbCapteurs_fist = size(data_fist, 2) - 1;
figure('Name', 'Signaux de fistMat.txt', 'Position', [100, 100, 1000, 600]);

for capteur = 1:nbCapteurs_fist
    subplot(4, 2, capteur);  % Organisation en 4 lignes et 2 colonnes
    plot(data_fist(:, 1), data_fist(:, capteur + 1), 'LineWidth', 1.5);
    title(['Signal EMG de Capteur ' num2str(capteur) ' (Fist)']);
    xlabel('Temps');
    ylabel('Amplitude');
    grid on;
end

% Affichage comparatif de l'un des signaux (capteur 8)
figure('Name', 'Comparaison Double Tap et Fist');
subplot(2, 1, 1);
plot(data_tap(:, 1), data_tap(:, 9), 'b', 'LineWidth', 1.5);
title('Signal du Capteur 8 - Double Tap');
xlabel('Temps');
ylabel('Amplitude');
grid on;

subplot(2, 1, 2);
plot(data_fist(:, 1), data_fist(:, 9), 'b', 'LineWidth', 1.5);
title('Signal du Capteur 8 - Fist');
xlabel('Temps');
ylabel('Amplitude');
grid on;

% Calcul des moyennes des capteurs et création du nuage de points
moyennes_tap = mean(data_tap(:, 2:end), 1);
moyennes_fist = mean(data_fist(:, 2:end), 1);

figure('Name', 'Nuage de Points des Moyennes');
scatter(1:nbCapteurs_tap, moyennes_tap, 'filled', 'b', 'DisplayName', 'Double Tap');
hold on;
scatter(1:nbCapteurs_fist, moyennes_fist, 'filled', 'r', 'DisplayName', 'Fist');
xlabel('Capteurs');
ylabel('Moyenne des Valeurs des Capteurs');
title('Comparaison des Moyennes des Capteurs entre Double Tap et Fist');
legend;
grid on;

% Étape 1: Sélection et transformation des signaux
signal_tap = data_tap(:, 9);  % Prendre tout le signal du capteur 8 (Double Tap)
signal_fist = data_fist(:, 9);  % Prendre tout le signal du capteur 8 (Fist)

% Étape 2: Délimitation des ondes avec un seuil basé sur une fraction de la moyenne
seuil_tap = 0.7 * mean(abs(signal_tap));  % Seuil basé sur la moyenne absolue
seuil_fist = 0.7 * mean(abs(signal_fist));

% Délimitation du signal Tap
delim_tap = signal_tap;
delim_tap(abs(signal_tap) < seuil_tap) = 0;  % Délimitation basée sur la magnitude
delim_tap(abs(signal_tap) >= seuil_tap) = max(signal_tap);

% Délimitation du signal Fist
delim_fist = signal_fist;
delim_fist(abs(signal_fist) < seuil_fist) = 0;
delim_fist(abs(signal_fist) >= seuil_fist) = max(signal_fist);

% Affichage des signaux originaux et délimités pour le capteur 8
figure('Name', 'Délimitation des Signaux du Capteur 8');
subplot(2, 1, 1);
plot(data_tap(:, 1), signal_tap, 'b');
hold on;
plot(data_tap(:, 1), delim_tap, 'r');
title('Double Tap - Délimitation des Signaux (Capteur 8)');
xlabel('Temps');
ylabel('Amplitude');
grid on;

subplot(2, 1, 2);
plot(data_fist(:, 1), signal_fist, 'b');
hold on;
plot(data_fist(:, 1), delim_fist, 'r');
title('Fist - Délimitation des Signaux (Capteur 8)');
xlabel('Temps');
ylabel('Amplitude');
grid on;

% Ajout de la convolution pour le 8ème signal avec plusieurs fenêtres rectangulaires

% Paramètres de la fenêtre rectangulaire pour plusieurs périodes
T = 100;  % Largeur de la fenêtre (100 unités)
A = 1;    % Facteur d'amplitude
t0_values = [400, 450, 530, 600, 690];  % Centres des différentes fenêtres

% Créer une figure pour afficher les résultats de convolution
figure('Name', 'Convolution du 8ème Signal avec Fenêtres Rectangulaires');

% Affichage du signal original
subplot(length(t0_values) + 1, 1, 1);
plot(data_fist(:, 1), signal_fist, 'm'); % Signal original en rose
title('8ème Signal Original (fistMat.txt)');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

% Appliquer et afficher la fenêtre rectangulaire pour chaque période
for i = 1:length(t0_values)
    t0 = t0_values(i);  % Centre de la fenêtre
    
    % Fenêtre rectangulaire centrée sur t0
    rect_window = A * (abs(data_fist(:, 1) - t0) <= T / 4);  % Largeur T/4
    
    % Appliquer la fenêtre au signal
    windowed_signal = signal_fist .* rect_window;
    
    % Afficher le signal fenêtré
    subplot(length(t0_values) + 1, 1, i + 1);
    plot(data_fist(:, 1), windowed_signal, 'm');  % Signal fenêtré en rose
    title(['Signal avec Fenêtre Rectangulaire Appliquée (t0 = ', num2str(t0), ')']);
    xlabel('Temps (s)');
    ylabel('Amplitude');
    grid on;
end
