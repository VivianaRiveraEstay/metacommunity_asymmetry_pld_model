function dydt = ecosystem_model(t, y, N, a, h, mV, mP, phiV, phiP, AV, AP, f, w, cv, cp)

    V = y(1:N);
    P = y(N+1:end);

    dV = zeros(N,1);
    dP = zeros(N,1);

    for j = 1:N

        % --- Prey dynamics ---
        sumV = 0;
        for i = 1:N
            sumV = sumV + cv(j,i) * f(i) * V(i);
        end

        recruitment = sumV * (AV(j) - phiV * V(j));

        predation = (a(j) * V(j) / (1 + a(j) * h(j) * V(j))) * P(j);

        dV(j) = recruitment - predation - mV * V(j);

        % --- Predator dynamics ---
        sumP = 0;
        for i = 1:N
            sumP = sumP + (a(i) * cp(j,i) * w(i) * V(i) / (1 + a(i) * h(i) * V(i))) * P(i);
        end

        predator_recruitment = sumP * (AP(j) - phiP * P(j));

        dP(j) = predator_recruitment - mP * P(j);

    end

    dydt = [dV; dP];

end