%% ************************************************************************
%  Function name: FnFast_enu2llh
%  Description: Cartesian coordinate -> WGS84 coordinate
%  Datum: WGS84
% *************************************************************************
% Copyright (c) 2014, ACE Lab
% All rights reserved.

function llh = FnFast_enu2llh(Ref_Lat,Ref_Lon,e,n,u)

if nargin ~= 5 && nargin ~= 4
  warning('Incorrect number of input arguments');
  fprintf('----------------------------------------------------\n');
  fprintf('Usage: FastConv_llh2enu(Ref_Lat,Ref_Lon,Lat,Lon,Hgt)\n');
  fprintf('----------------------------------------------------\n\n');
  return
end

if nargin == 4
    u = zeros(size(e));
end

KappaLat = FnKappaLat(Ref_Lat, u);
KappaLon = FnKappaLon(Ref_Lat, u);

dLon = KappaLon .* e;
dLat = KappaLat .* n;
Height = u;

llh = [Ref_Lat+dLat, Ref_Lon+dLon, Height];

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