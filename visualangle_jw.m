% Visual Angle Computation
% Wessel@nf.mpg.de
%
% Selectah
%    1 = From Length and Distance to Visual Angle
%        x1 = Length
%        x2 = Distance
%    2 = From Distance and Visual Angle to Length
%        x1 = Distance
%        x2 = Visual Angle
%    3 = From Visual Angle and Length to Distance
%        x1 = Visual Angle
%        x2 = Length
%

function output = visualangle_jw(selectah,x1,x2)

if selectah == 1
    output = 2*atand(x1/(2*x2));
elseif selectah == 2
    output = (tand(x2/2))*2*x1;
elseif selectah == 3
    output = (((tand(x1/2)) / x2) / 2);
end