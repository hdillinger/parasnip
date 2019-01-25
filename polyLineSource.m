% read in centerline csv from paraview
centerlines = csvread('centerline.csv',1,0);

centerlines_com = mean(centerlines, 1);
centerlines = centerlines - centerlines_com;

% compute distance map
% D = pdist2(centerlines,centerlines,'squaredeuclidean');
% [~, idx] = sort(D(:,1),1);
% idx = knnsearch(centerlines,centerlines);
% centerlinessort = centerlines(idx,:);

% convert to polar form
[theta, rho, r] = cart2pol(centerlines(:,1), centerlines(:,2), centerlines(:,3));
% sort by angle
[~ ,I] = sort(theta);
centerlinessort = centerlines(I,:);


% fit spline
CS = [0; cumsum(sqrt(sum(diff(centerlinessort(:,1:3),[],1).^2,2)))];
[~, IA, ~] = unique(CS);
centerlinesinterp = interp1(CS(IA), centerlinessort(IA,:), linspace(0,CS(end),30),'pchip');
csvwrite('centerlines_interp.csv',centerlinesinterp);

centerlinesinterp = centerlinesinterp + centerlines_com;

string = [];
for i=1:size(centerlinesinterp,1)
    string = strcat(string,num2str(centerlinesinterp(i,1)),',',num2str(centerlinesinterp(i,2)),',',num2str(centerlinesinterp(i,3)),',');
end

disp(string);

string = [];
normal = diff(centerlinesinterp(:,1:3),[],1);
for i=1:size(normal,1)
    string = strcat(string,num2str(normal(i,1)),',',num2str(normal(i,2)),',',num2str(normal(i,3)),',');
end

disp(string);

% string = [];
% for i=1:3:size(centerlinesinterp,1)
%     string = strcat(num2str(centerlinesinterp(i,1)),',',num2str(centerlinesinterp(i,2)),',',num2str(centerlinesinterp(i,3)),',');
%     disp(string)
% end
