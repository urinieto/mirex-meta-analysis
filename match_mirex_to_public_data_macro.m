function [mir2pub pub2mir pwf] = match_mirex_to_public_data_macro(mir2pub, pub2mir, pwf, miranns, pubanns, rel_mir, rel_pub, length_thresh, quality_thresh)

tic
unmatched_mirdata = find(max(transpose(pwf))<.99);
unmatched_pubdata = find(max(pwf)<.99);
% This is how many more songs we have to match.
length(unmatched_mirdata)
if ~isempty(unmatched_mirdata) & ~isempty(unmatched_pubdata),

    for i=row(unmatched_mirdata),
        dothese = find(max(pwf)<.99 & pwf(i,:)==0);
        for j=dothese,
            if (abs(miranns(rel_mir(i)).tim(end)-pubanns(rel_pub(j)).tim(end)) < length_thresh),
                res = boundary_grader(miranns(rel_mir(i)).tim, pubanns(rel_pub(j)).tim, 1, 3);
                pwf(i,j) = res(1);
            end
        end
        toc
    end
end

% After running that, we can update our matches.
% We will choose, for each MIREX song, the best matching public annotation as long as it has a pwf value of at least 0.99.
% (If we just picked the best one, it obviously might be a non-match.)
% We will also choose the best-matching MIREX song for each public annotation in the same manner. This means that the best
% match from mir2pub and from pub2mir could be different! This is expected, since any song by the Beatles will show up
% only once in MIREX, but could show up several times in the public data.

% Recall:
% rel_mir lists the indices (in miranns) of the mir songs we are looking at.
% rel_pub lists the indices (in pubanns) of the pub songs we are looking at.
% We want to find, for each miranns index, which pubanns index matches it.

% Pick best public match for each MIREX annotation:
for i=1:length(rel_mir),
    miranns_id = rel_mir(i);
    [value rel_pub_id] = max(pwf(i,:));
    if value>=quality_thresh,
        pubanns_id = rel_pub(rel_pub_id);
        mir2pub(miranns_id) = pubanns_id;
        pub2mir(pubanns_id) = miranns_id;
    end
end

% Pick best MIREX match for each public annotation:
for i=1:length(rel_pub),
    pubanns_id = rel_pub(i);
    [value rel_mir_id] = max(pwf(:,i));
    if value>=quality_thresh,
        miranns_id = rel_mir(rel_mir_id);
        pub2mir(pubanns_id) = miranns_id;
        mir2pub(miranns_id) = pubanns_id;
    end
end