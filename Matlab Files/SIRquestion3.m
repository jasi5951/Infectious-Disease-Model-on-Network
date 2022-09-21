function SIRquestion3(filename, k)
recoveredpercentage = zeros(1, 100);
    for numbersim = 1:100
        del = 10;
        b = 4 * 10^-4;
        u = del * b/k;
        dt = 5 * 10^-3 * 1/b;
        
        q = u * dt;

        load("-mat", filename, 'U');

        susceptibleNodes = ones(1, length(U));
        infectiousNodes = zeros(1, length(U));
        recoveredNodes = zeros(1, length(U));
        
        susceptibleNodesGraph = [sum(susceptibleNodes, "all")];
        infectiousNodesGraph = [sum(infectiousNodes, "all")];
        recoveredNodesGraph = [sum(recoveredNodes, "all")];
        
        infectiousNodes(1, 1) = 1;
        susceptibleNodes(1, 1) = 0;
        susceptibleNodesGraph(end + 1) = sum(susceptibleNodes, "all");
        infectiousNodesGraph(end + 1) = sum(infectiousNodes, "all");
        recoveredNodesGraph(end + 1) = sum(recoveredNodes, "all");
        
        while sum(susceptibleNodes) ~= 0 && sum(infectiousNodes) ~= 0
            for i = find(infectiousNodes)
                for s = find(susceptibleNodes)
                    if U(i, s) == 1 && s ~= i && susceptibleNodes(1, s) == 1
                        infected = b*dt;
                        probinfected = rand/100;
                        if infected > probinfected
                            susceptibleNodes(1, s) = 0;
                            infectiousNodes(1, s) = 1;
                        end
                    end
                end
                    
                recovered = q;
                probrecovered = rand/10;
                if recovered > probrecovered
                    infectiousNodes(1, i) = 0;
                    recoveredNodes(1, i) = 1;
                end
                susceptibleNodesGraph(end + 1) = sum(susceptibleNodes, "all");
                infectiousNodesGraph(end + 1) = sum(infectiousNodes, "all");
                recoveredNodesGraph(end + 1) = sum(recoveredNodes, "all");
                disp("susceptible: " + sum(susceptibleNodes, "all") + " infected: " + sum(infectiousNodes, "all") + " recovered: " + sum(recoveredNodes, "all"))
            end
        end
        
        disp(sum(recoveredNodes, "all")/length(U));
        recoveredpercentage(1, numbersim) = sum(recoveredNodes, "all")/length(U);
    end
    disp(recoveredpercentage);
    histogram(recoveredpercentage, 'BinWidth', 0.01);
    ytickformat('percentage');
    ylabel("Percentage of Simulations");
    xlabel("Percentage of Recovered Nodes");
    hold off;
end

