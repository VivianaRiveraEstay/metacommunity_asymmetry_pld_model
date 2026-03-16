clc; clear; close all;

N = 30;
PLD_values = [10 30 60];
mu_values  = [0 5];

figure('Color','w','Position',[100 100 1400 800])

for r = 1:length(mu_values)

    mu_shift = mu_values(r);

    for c = 1:length(PLD_values)

        PLD = PLD_values(c);

        C = generate_asymmetric_connectivity(N, PLD, mu_shift);

        subplot(length(mu_values), length(PLD_values), (r-1)*length(PLD_values)+c)

        imagesc(C)
        colormap(flipud(gray))

        cb = colorbar;
        title(cb,'$c_{ij}$','Interpreter','latex','FontSize',24)

        axis square
        set(gca,'YDir','normal','FontSize',24)

        xlabel('Source patch','FontSize',24)
        ylabel('Destination patch','FontSize',24)

        title(sprintf('$\\mathrm{PLD} = %d,\\; \\mu = %d$',PLD,mu_shift),...
              'Interpreter','latex',...
              'FontSize',24)

    end
end