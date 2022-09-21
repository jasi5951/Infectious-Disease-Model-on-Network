function SIRquestion4()
    filenames = ["A_InVS13.mat", "A_InVS15.mat", "A_LH10.mat", "A_LyonSchool.mat", "A_SFHH.mat", "A_Thiers13.mat"];

    for filenameindex = 1:6
        x = zeros(1, 5);
        y = zeros(1, 5);
        for k = 1:5
            recoveredpercentage = zeros(1, 100);
            for numbersim = 1:100
                del = 10;
                b = 4 * 10^-4;
                u = del * b/k;
                dt = 5 * 10^-3 * 1/b;
                
                q = u * dt;
                
                load("-mat", filenames(filenameindex), 'U');
                
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
                if sum(recoveredNodes, "all")/length(U) >= 0.2
                    recoveredpercentage(1, numbersim) = sum(recoveredNodes, "all")/length(U);
                end
            end
            recoveredpercentage = nonzeros(recoveredpercentage');
            x(1, k) = k*mean(sum(U, 1))/del;
            y(1, k) = length(recoveredpercentage)/100;
        end
        plot(x, y, '-o'); hold on;
    end
    ytickformat('percentage');
    ylabel("Percentage of Simulations (Recovered Nodes >= 20%)");
    xlabel("ρ0 = kd/δ");
    legend('A\_InVS13', 'A\_InVS15', 'A\_LH10', 'A\_LyonSchool', 'A\_SFHH', 'A\_Thiers13');
    hold off;
end
