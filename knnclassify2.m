function outClass = knnclassify2(sample, TRAIN, group, K, distance,rule)
%KNNCLASSIFY classifies data using the nearest-neighbor method
%
%   CLASS = KNNCLASSIFY(SAMPLE,TRAINING,GROUP) classifies each row of the
%   data in SAMPLE into one of the groups in TRAINING using the nearest-
%   neighbor method. SAMPLE and TRAINING must be matrices with the same
%   number of columns. GROUP is a grouping variable for TRAINING. Its
%   unique values define groups, and each element defines the group to
%   which the corresponding row of TRAINING belongs. GROUP can be a
%   numeric vector, a string array, or a cell array of strings. TRAINING
%   and GROUP must have the same number of rows. CLASSIFY treats NaNs or
%   empty strings in GROUP as missing values and ignores the corresponding
%   rows of TRAINING. CLASS indicates which group each row of SAMPLE has
%   been assigned to, and is of the same type as GROUP.
%
%   CLASS = KNNCLASSIFY(SAMPLE,TRAINING,GROUP,K) allows you to specify K,
%   the number of nearest neighbors used in the classification. The default
%   is 1.
%
%   CLASS = KNNCLASSIFY(SAMPLE,TRAINING,GROUP,K,DISTANCE) allows you to
%   select the distance metric. Choices are
%             'euclidean'    Euclidean distance (default)
%             'cityblock'    Sum of absolute differences, or L1
%             'cosine'       One minus the cosine of the included angle
%                            between points (treated as vectors)
%             'correlation'  One minus the sample correlation between
%                            points (treated as sequences of values)
%             'Hamming'      Percentage of bits that differ (only
%                            suitable for binary data)
%
%   CLASS = KNNCLASSIFY(SAMPLE,TRAINING,GROUP,K,DISTANCE,RULE) allows you
%   to specify the rule used to decide how to classify the sample. Choices
%   are:
%             'nearest'   Majority rule with nearest point tie-break
%             'random'    Majority rule with random point tie-break
%             'consensus' Consensus rule
%
%   The default behavior is to use majority rule. That is, a sample point
%   is assigned to the class from which the majority of the K nearest
%   neighbors are from. Use 'consensus' to require a consensus, as opposed
%   to majority rule. When using the consensus option, points where not all
%   of the K nearest neighbors are from the same class are not assigned
%   to one of the classes. Instead the output CLASS for these points is NaN
%   for numerical groups, '' for string named groups or <undefined> for
%   categorical groups. When classifying to more than two groups or when
%   using an even value for K, it might be necessary to break a tie in the
%   number of nearest neighbors. Options are 'random', which selects a
%   random tiebreaker, and 'nearest', which uses the nearest neighbor among
%   the tied groups to break the tie. The default behavior is majority
%   rule, nearest tie-break.
%
%   Examples:
%
%      % training data: two normal components
%      training = [mvnrnd([ 1  1],   eye(2), 100); ...
%                  mvnrnd([-1 -1], 2*eye(2), 100)];
%      group = [ones(100,1); 2*ones(100,1)];
%      gscatter(training(:,1),training(:,2),group);hold on;
%
%      % some random sample data
%      sample = unifrnd(-5, 5, 100, 2);
%      % classify the sample using the nearest neighbor classification
%      c = knnclassify(sample, training, group);
%
%      gscatter(sample(:,1),sample(:,2),c,'mc'); hold on;
%      c3 = knnclassify(sample, training, group, 3);
%      gscatter(sample(:,1),sample(:,2),c3,'mc','o');
%
%   See also CLASSIFY, CLASSPERF, CROSSVALIND, KNNIMPUTE, SVMCLASSIFY,
%   SVMTRAIN.

%   Copyright 2004-2008 The MathWorks, Inc.


%   References:
%     [1] Machine Learning, Tom Mitchell, McGraw Hill, 1997

bioinfochecknargin(nargin,3,mfilename)

% grp2idx sorts a numeric grouping var ascending, and a string grouping
% var by order of first occurrence
[gindex,groups] = grp2idx(group);
nans = find(isnan(gindex));
if ~isempty(nans)
    TRAIN(nans,:) = [];
    gindex(nans) = [];
end
ngroups = length(groups);

[n,d] = size(TRAIN);
if size(gindex,1) ~= n
    error(message('bioinfo:knnclassify:BadGroupLength'));
elseif size(sample,2) ~= d
    error(message('bioinfo:knnclassify:SampleTrainingSizeMismatch'));
end
m = size(sample,1);

if nargin < 4
    K = 1;
elseif ~isnumeric(K)
    error(message('bioinfo:knnclassify:KNotNumeric'));
end
if ~isscalar(K)
    error(message('bioinfo:knnclassify:KNotScalar'));
end

if K<1
    error(message('bioinfo:knnclassify:KLessThanOne'));
end

if isnan(K)
    error(message('bioinfo:knnclassify:KNaN'));
end

if nargin < 5 || isempty(distance)
    distance  = 'euclidean';
elseif ischar(distance)
    distNames = {'euclidean','cityblock','cosine','correlation','hamming'};
    i = find(strncmpi(distance, distNames,numel(distance)));
    if length(i) > 1
        error(message('bioinfo:knnclassify:AmbiguousDistance', distance));
    elseif isempty(i)
        error(message('bioinfo:knnclassify:UnknownDistance', distance));
    end
    distance = distNames{i};
else
    error(message('bioinfo:knnclassify:InvalidDistance'));
end

if nargin < 6
    rule = 'nearest';
elseif ischar(rule)
    
    % lots of testers misspelled consensus.
    if strncmpi(rule,'conc',4)
        rule(4) = 's';
    end
    ruleNames = {'random','nearest','farthest','consensus'};
    i = find(strncmpi(rule, ruleNames,numel(rule)));
    % %   May need this if we add more rules and introduce the possibility of
    % %   ambiguity.
    %     if length(i) > 1
    %         error('bioinfo:knnclassify:AmbiguousRule', ...
    %             'Ambiguous ''Rule'' parameter value:  %s.', rule);
    %     else
    if isempty(i)
        error(message('bioinfo:knnclassify:UnknownRule', rule));
    end
    rule = ruleNames{i};
    %     end
else
    error(message('bioinfo:knnclassify:InvalidRule'));
end

% Calculate the distances from all points in the training set to all points
% in the test set.

if strncmpi(distance,'hamming',3)
        if ~all(ismember(sample(:),[0 1]))||~all(ismember(TRAIN(:),[0 1]))
            error(message('bioinfo:knnclassify:HammingNonBinary'));
        end
end
dIndex = knnsearch(TRAIN,sample,'distance', distance,'K',K);
% find the K nearest

if K >1
    classes = gindex(dIndex);
    % special case when we have one sample(test) point -- this gets turned into a
    % column vector, so we have to turn it back into a row vector.
    if size(classes,2) == 1
        classes = classes';
    end
    % count the occurrences of the classes
    
    counts = zeros(m,ngroups);
    for outer = 1:m
        for inner = 1:K
            counts(outer,classes(outer,inner)) = counts(outer,classes(outer,inner)) + 1;
        end
    end
    
    [L,outClass] = max(counts,[],2);
    
    % Deal with consensus rule
    if strcmp(rule,'consensus')
        noconsensus = (L~=K);
        
        if any(noconsensus)
            outClass(noconsensus) = ngroups+1;
			if isnumeric(group) || islogical(group)
				groups(end+1) = {'NaN'};
			else
				groups(end+1) = {''};
			end
        end
    else    % we need to check case where L <= K/2 for possible ties
        checkRows = find(L<=(K/2));
        
        for i = 1:numel(checkRows)
            ties = counts(checkRows(i),:) == L(checkRows(i));
            numTies = sum(ties);
            if numTies > 1
                choice = find(ties);
                switch rule
                    case 'random'
                        % random tie break
                        
                        tb = randsample(numTies,1);
                        outClass(checkRows(i)) = choice(tb);
                    case 'nearest'
                        % find the use the closest element of the equal groups
                        % to break the tie
                        for inner = 1:K
                            if ismember(classes(checkRows(i),inner),choice)
                                outClass(checkRows(i)) = classes(checkRows(i),inner);
                                break
                            end
                        end
                    case 'farthest'
                        % find the use the closest element of the equal groups
                        % to break the tie
                        for inner = K:-1:1
                            if ismember(classes(checkRows(i),inner),choice)
                                outClass(checkRows(i)) = classes(checkRows(i),inner);
                                break
                            end
                        end
                end
            end
        end
    end
    
else
    outClass = gindex(dIndex);
end

% Convert back to original grouping variable
if isa(group,'categorical') % this is true also for nominal and ordinal
	glevels = group([]);
	glevels(1:numel(groups),1) = groups;
	outClass = glevels(outClass);
elseif isnumeric(group) || islogical(group)
    groups = str2num(char(groups)); %#ok
    outClass = groups(outClass);
elseif ischar(group)
    groups = char(groups);
    outClass = groups(outClass,:);
else %if iscellstr(group)
    outClass = groups(outClass);
end



