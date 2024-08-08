%https://www.rs.tus.ac.jp/mark.sadgrove/resources/notes/PhCBandStructureNotes.pdf
% Band diagram from the plane wave decomposition method as
% per A. J. Danner’s notes
% http://www.ece.nus.edu.sg/stfpage/eleadj/planewave.htm

% Clean up workspace
clear all;
%close all

% PhC parameters
d1 = 200e-9;
d2 = 200e-9;
d = d1 + d2;
n1 = sqrt(13);
n2 = sqrt(12);

% Input light parameters
kz = linspace(0,2*pi/d,100);
c = 3e8;

% Decomposition constants
N = 0.50; % This chooses the number of bands
% NB: choosing this number too small will lead to
% an inaccurate band diagram due to truncation of
% the Fourier series.

% Create matrix and solve eigenvalue equation
w2 = zeros(2*N+1,length(kz)); % Set up storage array
for kk = 1:length(kz)
    % Make matrix using for loop
    M = zeros(2*N+1,2*N+1); % Added semicolon to suppress output
    for nn = (-N):N
        for pp = (-N):N
            Fn = (d1/d) * (1/n1^2-1/n2^2) * sinc((pp-nn)*d1/d);
            if ((pp-nn)==0)
                Fn = Fn + 1/n2^2;
            end
            M(nn+N+1,pp+N+1) = (2*pi/d*nn + kz(kk))^2 * Fn;
        end
    end
    w2(:,kk) = sort(eig(M)); % Find and sort the eigenvalues
end

% Plot band diagram
figure(2)
clf
plot(kz*d,sqrt(w2)*d)
hold on
plot(kz*d,abs(kz)*d,'k-','LineWidth',2)
hold off
axis tight
set(gca,'FontSize',14)
xlabel('k_zd','FontSize',14)
ylabel('\omega d/c','FontSize',14)
ylim([0,2*pi])
