function [ array_of_blocks ] = parseInput(filedata)
%parseInput is a function for separating blocks of raw data from each other
%return an array of strings, each containing data for one block


    numBlocks = strfind(filedata,'*');
    if ~isEmpty(numBlocks)
        array_of_blocks = {1,length(numBlocks)};

        array_of_blocks{1,1} = filedata(1:numBlocks(1));

        for i=2:length(numBlocks)
            array_of_blocks{1:i} = filedata(numBlocks(i-1):numBlocks(i));
        end
    else
        array_of_blocks = {filedata};
    end

end

