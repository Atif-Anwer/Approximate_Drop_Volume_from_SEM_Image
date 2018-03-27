%%
% For all pictures - Scale is 168px = 500um
% Which means that 1px = 2.9762um
% For the pixels Area of the drop, simply multiply by the scale factor above
% to find out the area in um of the drop
% For volume of drop: V=?r^2h
% where: 
%       r is the diameter of the tube
%       h is the length of the drop

clear;
clc;
    %------------- Read image -------------
    I = imread('K1_OM5_Q100.jpg');
    % Change filename accordingly...
    BW = rgb2gray(I);
    BW = ~(BW < 100);

    se = strel('disk',15);
    BW = imerode(BW, se);
    BW = imdilate(BW, se);
    
    cc = bwconncomp(BW);
        
    s = regionprops(BW,'BoundingBox', 'Centroid', 'Area', 'Image','PixelIdxList','MajorAxisLength','MinorAxisLength');
    [sortedareas, areaidx] = sort([s.Area], 'descend');
    s = s(areaidx);
    
    %------------- Show images -------------
    subplot(2,2,1); imshow(I);title('Original image');
    subplot(2,2,3); imshow(BW);title('Drop Centers');
    hold on
    % plot centeroids on the remaining objects
    centroids = cat(1, s.Centroid);
    plot(centroids(:,1),centroids(:,2), 'r*')
    hold off
    
    %------------- filter regions wrt area -------------
    toDelete = [s.Area] > 95000;
    s(toDelete,:) = [];
    
    toDelete = [s.Area] < 2500;
    s(toDelete,:) = [];
    
    % create a new image with the now filtered objects
    updatedBW = false(size(BW));
    
    %------------- Show color coded image wrt objects -------------
    [B,L] = bwboundaries(BW,'noholes');
    subplot(2,2,2)
    imshow(label2rgb(L, @jet, [.5 .5 .5]));title('All segments in an image');
    hold on
    for k = 1:length(B)
       boundary = B{k};
       plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    end
    
    % loop for the total number of struct rows
    for k = 1:numel(s)
        % only keep the top three (?)
        if k < 4
            updatedBW(s(k).PixelIdxList) = 1;
            Length(k) = s(k).MajorAxisLength*2.9762;
            Height(k) = s(k).MinorAxisLength*2.9762;
            Volume(k) = pi*((Height(k)/2)^2)*(Length(k));
            index(k) = k;
        end
    end
    
    %------------- Display Segmented drops -------------
    
    subplot(2,2,4); imshow(updatedBW);title('Segmented drops and gaps');
    hold on
    % Add the numbers of the drops
    for k = 1:3
            x = s(k).Centroid(1);
            y = s(k).Centroid(2);
            text(x, y, sprintf('%d', k), 'Color', 'r', ...
                'FontWeight', 'bold');
    end
    hold off
    
    % ------------- Display table -------------
    fprintf('-------------\nNOTE: \nData has been calculated in um \n(1px = 2.9762um from the scale in images)\n-------------');
    RowNames = {'Drop 1';'Drop 2';'Drop 3'};
    format shortEng    
    Drops = table;
    Drops.Number = index';
    Drops.Length = Length';
    Drops.Height = Height';
    Drops.Volume = Volume'
    
    
    