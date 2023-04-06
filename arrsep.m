function new_arr = arrsep(arr, gap, cirbnd, thres)
%ARRSEP This function seperates the array for every "circular" distance 
% between any two points are greater than gap. Make sure that the input 
% range is [-cirbnd, cirbnd]. If not, the distance between two points may 
% be negative. (cirbnd = +Inf by default). For cirbnd < 0, then assume that
% there is no circular bound, i.e. cirbnd = +Inf.
% 
%     Usage:
%         out = arrsep(in, gap)
%         out = arrsep(in, gap, cirbnd)
%         out = arrsep(in, gap, cirbnd, eps)
% 
%         [input]:
%             in:     the input array
%             gap:    the minimum distance between adjacent point in the input array
%             cirbnd: the circular bound for the array, this is used to measure the "distance" between angles, e.g. the "distance" between -0.49 and 0.49
%                     is 0.1 + 0.1 = 0.2 with cirbnd = 0.5
%             eps:    the small value to perform the comparsion between two float/bouble variables
%         
%         [output]:
%             out:    the output array
% 
%         [default values]:
%             cirbnd: inf
%             eps:    1e-9
%   ref:
%       https://www.mathworks.com/help/matlab/matlab_external/c-mex-source-file.html
%       https://www.mathworks.com/help/matlab/matlab_external/cpp-mex-api.html
%

error('can not find the mex compiled file.');

end