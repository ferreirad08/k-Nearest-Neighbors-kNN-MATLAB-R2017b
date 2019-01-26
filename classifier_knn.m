function [label,Ynearest,Xnearest] = classifier_knn(X,Y,Xnew,k,status_plot)
%k-Nearest Neighbors (kNN)
%
%Author: David Ferreira - Federal University of Amazonas
%Contact: ferreirad08@gmail.com
%
%classifier_knn
%
%Syntax
%1. label = classifier_knn(X,Y,Xnew,k)
%2. [label,Ynearest,Xnearest] = classifier_knn(X,Y,Xnew,k)
%3. classifier_knn(X,Y,Xnew,k,'plot');
%
%Description 
%1. Returns the estimated label of one test instances.
%2. Returns the estimated label of one test instance, the k nearest training labels and the k nearest training instances.
%3. Creates a chart circulating the nearest training instances (For plotting, instances must have only two or three features (2-D or 3-D)).
%
%X is an M-by-N matrix, with M instances of N features. 
%Y is an M-by-1 matrix, with respective M labels to each training instance. 
%Xnew is an 1-by-N matrix, with one instance of N features to be classified.
%k is a scalar, with the number of nearest neighbors selected.
%status_plot is a string, with the value 'plot' only to create the chart.
%
%Examples
%1.
%     X = [8 5 1; 3 7 2; 3 6 3; 7 3 1]; 
%     Y = {'fruit';'vegetable';'protein';'fruit'}; 
%     Xnew = [6 4 1]; 
%     k = 3;
%     label = classifier_knn(X,Y,Xnew,k)
%     label = 
%         'fruit'
%
%2.
%     [label,Ynearest,Xnearest] = classifier_knn(X,Y,Xnew,k)
%     label = 
%         'fruit'
%     Ynearest =
%         'fruit'
%         'fruit'
%         'protein'
%     Xnearest = 
%         7 3 1
%         8 5 1
%         3 6 3
%
%3.
%     classifier_knn(X,Y,Xnew,k,'plot');
%               Note: images 2-D and 3-D are among the downloaded files.

tf = iscell(Y);
if tf, [Y,Ccell] = cell2id(Y); end

% Euclidean distance between two points
A = repmat(Xnew,size(X,1),1)-X;
distances = sqrt(sum(A.^2,2));
% Sort the distances in ascending order and check the k nearest training labels
[distances,I] = sort(distances);
Ynearest = Y(I(1:k));
% Frequencies of the k nearest training labels
N = histc(Ynearest,1:max(Ynearest));
frequencies = N(Ynearest);
% Nearest training label with maximum frequency (if duplicated, check the nearest training instance)
[~,J] = max(frequencies);
label = Ynearest(J);

% Check the number of input arguments
if nargin > 4 && strcmp(status_plot,'plot')
    data_dimension = size(X,2);
    switch data_dimension
        case 2
            figure
            hold on
            grid on

            r = distances(k);
            xc = Xnew(1);
            yc = Xnew(2);

            theta = linspace(0,2*pi);
            x = r*cos(theta) + xc;
            y = r*sin(theta) + yc;
            plot(x,y,':k')
            axis equal

            plot(xc,yc,'xk',...
                'MarkerSize',8,...
                'LineWidth',2)

            Markers = {'o','s','^','d','v','>','<','p','h','+','*','.'};
            C = unique(Y);
            for i = 1:size(C,1)
                L = find(Y==C(i));
                plot(X(L,1),X(L,2),Markers{i})
            end
        case 3
            figure
            
            plot3(Xnew(1),Xnew(2),Xnew(3),'xk',...
                'MarkerSize',8,...
                'LineWidth',2)
            
            hold on
            grid on
            
            Xnearest = X(I(1:k),:);
            for i = 1:k
                plot3([Xnew(1) Xnearest(i,1)],...
                    [Xnew(2) Xnearest(i,2)],...
                    [Xnew(3) Xnearest(i,3)],':k')
            end

            Markers = {'o','s','^','d','v','>','<','p','h','+','*','.'};
            C = unique(Y);
            for i = 1:size(C,1)
                L = find(Y==C(i));
                plot3(X(L,1),X(L,2),X(L,3),Markers{i})
            end            
        otherwise
            error('For plotting, instances must have only two or three features (2-D or 3-D).')
    end
end

% Check the number of output arguments
if nargout > 1 && tf, Ynearest = Ccell(Ynearest); end
if nargout > 2, Xnearest = X(I(1:k),:); end
if tf, label = Ccell(label); end
end