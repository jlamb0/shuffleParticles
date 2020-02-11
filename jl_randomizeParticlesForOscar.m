function out = jl_randomizeParticlesForOscar(coordArray, imageSize)
% This function takes particle coordinate data exported from ImageJ,
% randomizes the particles and exports a new .tif image.
% After banalizing the image in ImageJ, find particles coordinates in Igor and Copy
% and paste into a variable "coordArray".
% JTL & OV 2016-05-16
%
% NOTE 2020-02-11:
% This is the source code as it appears in Vivas et al. (2017) eLife; 6:e28029.
% I plan to update the code for my own use in the coming months. When I do, I will
% be changing the name of the function and making improvements to the handling of
% the object outlines. I do not have an expected timeline for this project, and 
% I am posting this code for reference only. If you have questions, please contact
% Jason at jtlambert@ucdavis.edu.

% Reformat coordArray

outputImage = zeros(imageSize);


nanThese = cellfun(@isempty, coordArray);
coordArray(nanThese) = {nan};
coordArray(end+1,:) = {nan};
coordArray = cell2mat(coordArray);

Xdata = coordArray(:,1);
Ydata = coordArray(:,2);

% Define start and end points for the coordinates in the list that mark
% each particle (particles are separated by NaNs, line-breaks in original
% ImageJ export).
particleEndPoints = find(isnan(Xdata));
particleStartPoints = [1; particleEndPoints + 1];
particleStartPoints = particleStartPoints(1:end-1);

particleEndPoints = particleEndPoints -1;
particleRowIndices = [particleStartPoints, particleEndPoints];

perimeterLengths = particleRowIndices(:,2) - particleRowIndices(:,1);
[sortedLengths, sortIndex] = sort(perimeterLengths, 'descend');

particleRowIndices = particleRowIndices(sortIndex,:);
% Map out new positions for each particle.
for iPart = 1:size(particleRowIndices,1)
    % Generate new origin and coordiniates for particle
    curParticleRows = particleRowIndices(iPart,:);
    curCoords = coordArray(curParticleRows(1):curParticleRows(2),:);
    curCoordForm = curCoords -...
        repmat(curCoords(1,:), size(curCoords,1),1);
    
    newOrigin = [floor(imageSize(1) * rand), floor(imageSize(2) * rand)];
    newCoords = repmat(newOrigin, size(curCoordForm,1), 1) + curCoordForm;
    
    outlinePixelValues = [];
    if min(min(newCoords)) > 0 & max(max(newCoords)) < imageSize(1)
        for i = 1:size(newCoords,1)
            outlinePixelValues = [outlinePixelValues; outputImage(newCoords(i,1), newCoords(i,2))];
        end
    end
    
    % Check that the new coordinates don't make the object fall off the
    % edge of the image and that the new particle position isn't already
    % occupied by another particle.
    while any(any(newCoords < 0)) | any(any(newCoords > min(imageSize))) | any(outlinePixelValues == 256) | isempty(outlinePixelValues)
        newOrigin = floor(imageSize * rand);
        newCoords = repmat(newOrigin, size(curCoordForm,1), 1) + curCoordForm;
        
        outlinePixelValues = [];
        if min(min(newCoords)) > 0 & max(max(newCoords)) < imageSize(1)
            for i = 1:size(newCoords,1)
                outlinePixelValues = [outlinePixelValues; outputImage(newCoords(i,1), newCoords(i,2))];
            end
        end
    end   
    
    % Make pixels for new outline
    for i = 1:size(newCoords,1)
        try
        outputImage(newCoords(i,1), newCoords(i,2)) = 256;
        catch
            'a'
        end
    end
    
    disp(sprintf('Particle %d of %d successfully remapped', iPart, size(particleRowIndices,1)));
end %for iPart


% Export outputImage
imwrite(outputImage, 'C:\Users\zitoLabUser\Desktop\particleOutputImage.tif', 'TIFF', 'Compression', 'none')
imshow(outputImage);
