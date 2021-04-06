function correctSeries = correct2ContinuousAngled(angleSeries)
% Take series in degree and convert to (0,inf) avoiding abrupted change
    
    cutoffDegree = 180;
    threshold = 160;
    nSample = size(angleSeries,1);
    nSeries = size(angleSeries,2);
    haftRound = zeros(size(angleSeries));
    correctSeries(1,:) = angleSeries(1,:);
    for i = 2:nSample
        curSign = sign(angleSeries(i-1,:));
        haftRound(i,:) = haftRound(i-1,:) + curSign .* (abs(angleSeries(i,:) - angleSeries(i-1,:)) > threshold);
        correctSeries(i,:) = cutoffDegree*haftRound(i,:) + (cutoffDegree*sign(haftRound(i,:)) + angleSeries(i,:));
    end
    
    for i = 2:nSample
        curSign = sign(angleSeries(i-1,:));
        haftRound(i,:) = haftRound(i-1,:) + curSign .* (abs(angleSeries(i,:) - angleSeries(i-1,:)) > threshold);
        correctSeries(i,:) = cutoffDegree*haftRound(i,:) + (cutoffDegree*sign(haftRound(i,:)) + angleSeries(i,:));
    end

end