function recall = compute_recall_combined(query_B, database_B, attr_pred_query, attr_pred_database, query_label, database_label, query_Attribute, database_Attribute, leave_one_out)
%  This function computes recall. 
%  query_B ---- size: Nq * k, value: {1, -1}
%  database_B ---- size: Nd * k, value: {1, -1}
%  attr_pred_query ---- size: Nq * m, value: [0, 1]
% attr_pred_database ---- size: Nd * m, value: [0, 1]
% query_label ---- size: Nq * 1, value: {0, 1, 2, ..., C}
% database_label ---- size: Nd * 1, value: {0, 1, 2, ..., C}
% query_Attribute ---- size: Nq * m, value: {0, 1}
% database_Attribute ---- size: Nd * m, value: {0, 1}
% leave_one_out ---- size: 1 * 1, value: {0, 1}

pos = [5, 10, 20, 50, 75,100];

q_num = length(query_label);
d_num = length(database_label);
attr_num = size(attr_pred_query, 2);
dis_mtx = -query_B * database_B';

recall = zeros(q_num, attr_num, length(pos));

for i = 1:q_num
    if mod(i, 1000) == 0
        fprintf('Processed %d images.\n', i);
    end
    if leave_one_out
        database_label_temp = database_label;
        database_label_temp(i) = [];
        dis_mtx_temp = dis_mtx(i, :);
        dis_mtx_temp(i) = [];
        attr_pred_database_temp = attr_pred_database;
        attr_pred_database_temp(i, :) = [];
        database_Attribute_temp = database_Attribute;
        database_Attribute_temp(i,:) = [];
    else
        database_label_temp = database_label;
        dis_mtx_temp = dis_mtx(i, :);
        attr_pred_database_temp = attr_pred_database;
        database_Attribute_temp = database_Attribute;
    end
    for j = 1:attr_num
        query = attr_pred_query(i, j) > 0.5;
        num_gt = sum(database_label_temp==query_label(i) & database_Attribute_temp(:, j)~=query_Attribute(i,j));
        if num_gt == 0
            recall(i, j, :) = NaN;
            continue;
        end
        gt_idx = find(database_label_temp==query_label(i) & database_Attribute_temp(:, j)~=query_Attribute(i,j));
        if ~query
            idx = find(attr_pred_database_temp(:, j) <0.5);
            [~, sort_idx] = sort(dis_mtx_temp(idx), 'ascend');
            idx = idx(sort_idx);
            for k=1:length(pos)
                if length(idx) >= pos(k)
                    recall(i, j, k) = length(intersect(idx(1:pos(k)), gt_idx)) / num_gt;
                else
                    recall(i, j, k) = length(intersect(idx, gt_idx)) / num_gt;
                end
            end
        else
            recall(i, j, :) = NaN;
%             idx = find(attr_pred_database_temp(:, j) > 0.5);
%             [~, sort_idx] = sort(dis_mtx_temp(idx), 'ascend');
%             idx = idx(sort_idx);
%             for k=1:length(pos)
%                 if length(idx) >= pos(k)
%                     recall(i, j, k) = length(intersect(idx(1:pos(k)), gt_idx)) / num_gt;
%                 else
%                     recall(i, j, k) = length(intersect(idx, gt_idx)) / num_gt;
%                 end
%             end
        end
    end
end

end