function [curve, T1s, PLT1, fiterror, fitparam] = processSegmets(timetags,triggers,darktimes,fromto,correction,read_width)
    % Calculate the number of segments to chop the data to.
    segments = size(fromto,1);
    
    % Variables initialization.
    curve = zeros(segments,length(darktimes));
    curve_f = zeros(size(curve));
    fitparam = zeros(segments, 5);
    T1s = zeros(segments,1);
    PLT1 = zeros(segments,1);
    fiterror = zeros(segments,1);
    
    % Segment the data and calculate the curve.    
    for i=1:segments
        seg_timetags = timetags(fromto(i,1):fromto(i,2));
        seg_triggers = triggers(fromto(i,1):fromto(i,2));
        tmp = getT1curve(seg_triggers,seg_timetags,correction,read_width);
        curve(i,:) = tmp;
        
        % Calculate the T1 value
        [curve_f(i,:), fitparam(i,:), PLT1(i), fiterror(i)] = biexp_model(darktimes,curve(i,:));
        T1s(i) = max(fitparam(i,[3 5])); % T1 is the longest time constant.
    end
end