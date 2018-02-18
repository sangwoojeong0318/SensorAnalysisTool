%% ************************************************************************
%  Function name: FnFast_llh2enu
%  Description: Cartesian coordinate -> WGS84 coordinate
%  Datum: WGS84
% *************************************************************************
% Copyright (c) 2014, ACE Lab
% All rights reserved.

function enu = FnFast_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt)

if nargin ~= 5 && nargin ~= 4
  warning('Incorrect number of input arguments');
  fprintf('----------------------------------------------------\n');
  fprintf('Usage: FastConv_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt)\n');
  fprintf('----------------------------------------------------\n\n');
  return
end

if nargin == 4
    Hgt = zeros(size(Lat));
end

KappaLat = FnKappaLat(Ref_Lat, Hgt);
KappaLon = FnKappaLon(Ref_Lat, Hgt);

e = (Lon - Ref_Lon) ./ KappaLon;
n = (Lat - Ref_Lat) ./ KappaLat;
u = Hgt;

enu = [e, n, u];

end

%% ***************************************************************
%  Embedded Matlab: FnKappaLat
%  Description: WGS84 -> ENU
% *************************************************************************
function KappaLat = FnKappaLat(Ref_Latitude, h)

% Geometric constants set for coordinate conversion
a = double( 6378137.0 ); % SemiMajorAxis
e2 = double( 0.00669437999014 ); % FirstEccentricitySquard, e^2
RAD2DEG = double( 180/pi );

% M
Denominator = sqrt(1-e2*sind(Ref_Latitude).^2);
M = a .* (1-e2) ./ (Denominator^3) ;

% Curvature for the meridian
KappaLat = 1./(M + h)*RAD2DEG;

end

%% ***************************************************************
%  Embedded Matlab: FnKappaLon
%  Description: WGS84 -> ENU
% *************************************************************************
function KappaLon = FnKappaLon(Ref_Latitude, h)

% Geometric constants set for coordinate conversion
a = double( 6378137.0 ); % SemiMajorAxis
e2 = double( 0.00669437999014 ); % FirstEccentricitySquard, e^2
RAD2DEG = double( 180/pi );

% N
Denominator = sqrt(1-e2*sind(Ref_Latitude).^2);
N = a ./ Denominator;

% Curvature for the meridian
KappaLon = 1./((N + h) .* cosd(Ref_Latitude))*RAD2DEG;

end