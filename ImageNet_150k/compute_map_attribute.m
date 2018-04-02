function map = compute_map_attribute( attr_pred, ValAttribute )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[n, m] = size (attr_pred);

map = zeros(n, (nchoosek(m,1) + nchoosek(m,2) + nchoosek(m,3)));

choice = cell( size(map,2), 1);
count = 1;
for i = 1:3
    % Find all possible combinations of attribute queries with length j
    temp = combntns(1:m, i);
    for j = 1:size(temp, 1)
        choice{count} = temp(j, :);
        count = count + 1;
    end
end

for i = 1:n
    parfor j = 1:size(choice,1)
        % Figure out the predicted attributes of query image
        query = (attr_pred(i, choice{j}) - 0.5) < 0; 
        
        % Compute the matching score of database images
        database = attr_pred(:, choice{j});
        database(i, :) = [];
        database = abs( repmat(query, size(database, 1), 1) - database);
        score = prod( database, 2);  % sum or prod
        
        % Rank the scores
        [~, idx] = sort( score, 'descend');
        
        % Evaluate the ranking
        query_gt = ValAttribute(i, choice{j});
        database_gt = ValAttribute(:, choice{j});
        database_gt(i, :) = [];
        database_gt = database_gt(idx, :) - repmat(query_gt, [size(database_gt, 1), 1]);
        match = sum(abs(database_gt), 2);
        match_idx = find(match == 0);
        n_match = length(match_idx);
        if n_match > 0
            map(i, j) = sum([1:n_match]./match_idx')/n_match;
        else
            map(i, j) = 0;
        end
    end
end

map = mean(map(:));

end

