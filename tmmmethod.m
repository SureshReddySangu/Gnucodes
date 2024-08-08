%https://www.rs.tus.ac.jp/mark.sadgrove/resources/notes/PhCBandStructureNotes.pdf
% Clean up workspace
close all
clear all

% EM constants
c = 1; % Normalized units

% PhC constants
d1 = 2/10;
d2 = 2/10;
d = d1 + d2;
n1 = sqrt(13);
n2 = sqrt(12);

% Light constants
w = linspace(0, 2*pi, 200);
D1 = w * n1 * d1;
D2 = w * n2 * d2;

% Right hand side of the characteristic equation is independent of k_z
RHS = cos(D1).*cos(D2) - 0.5*(n1^2+n2^2)/(n1*n2) * sin(D1) .* sin(D2);

% Define the wave number space
kz = linspace(0, 2*pi, 100);

% Pre-allocate arrays for plotting
Omegas_total = [];
kz_total = [];

% Calculate the bands, one point of kz at a time
for ll = 1:length(kz)
    LHS = cos(kz(ll) * d);
    [indw, zero] = crossing(LHS - RHS, w); % Zero finding algorithm, see crossing.m

    if ~isempty(indw)
        Omegas = w(indw);
        Omegas_total = [Omegas_total, Omegas];
        kz_total = [kz_total, repmat(kz(ll), size(Omegas))];
    end
end

% Plotting
figure(1)
clf
plot(kz_total * d, Omegas_total * d / c, '.', 'MarkerSize', 10)
hold on

% Add light line
plot(kz * d, abs(kz) * d / c, 'k-', 'LineWidth', 2)

axis([min(kz*d), max(kz*d), min(w*d/c), max(w*d/c)])
set(gca, 'FontSize', 14)
xlabel('k_zd', 'FontSize', 14)
ylabel('\omega d/c', 'FontSize', 14)
ylim([0, 2*pi])
hold off
