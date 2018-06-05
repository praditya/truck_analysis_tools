function [ ] = kmlcreate( name,lat,long,alt )
%kmlcreate writes points to KML for plotting in google maps

% <?xml version="1.0" encoding="UTF-8"?>
% <kml xmlns="http://www.opengis.net/kml/2.2">
%   <Document>
%     <name>Paths</name>
%     <description>Examples of paths. Note that the tessellate tag is by default
%       set to 0. If you want to create tessellated lines, they must be authored
%       (or edited) directly in KML.</description>
%     <Style id="yellowLineGreenPoly">
%       <LineStyle>
%         <color>7f00ffff</color>
%         <width>4</width>
%       </LineStyle>
%       <PolyStyle>
%         <color>7f00ff00</color>
%       </PolyStyle>
%     </Style>
%     <Placemark>
%       <name>Absolute Extruded</name>
%       <description>Transparent green wall with yellow outlines</description>
%       <styleUrl>#yellowLineGreenPoly</styleUrl>
%       <LineString>
%         <extrude>1</extrude>
%         <tessellate>1</tessellate>
%         <altitudeMode>absolute</altitudeMode>
%         <coordinates> -112.2550785337791,36.07954952145647,2357
%           -112.2549277039738,36.08117083492122,2357
%           -112.2552505069063,36.08260761307279,2357
%           -112.2564540158376,36.08395660588506,2357
%           -112.2580238976449,36.08511401044813,2357
%           -112.2595218489022,36.08584355239394,2357
%           -112.2608216347552,36.08612634548589,2357
%           -112.262073428656,36.08626019085147,2357
%           -112.2633204928495,36.08621519860091,2357
%           -112.2644963846444,36.08627897945274,2357
%           -112.2656969554589,36.08649599090644,2357 
%         </coordinates>
%       </LineString>
%     </Placemark>
%   </Document>
% </kml>
lat;
long;
alt;
fileID = fopen(name,'wt');
fprintf(fileID,'<?xml version="1.0" encoding="UTF-8"?>');
fprintf(fileID,'\n<kml xmlns="http://www.opengis.net/kml/2.2">');
fprintf(fileID,'\n\t<Document>');
fprintf(fileID,'\n\t\t<Style id="yellowLineGreenPoly">');
fprintf(fileID,'\n\t\t\t<LineStyle>');
fprintf(fileID,'\n\t\t\t\t<color>7f00ffff</color>');
fprintf(fileID,'\n\t\t\t\t<width>4</width>');
fprintf(fileID,'\n\t\t\t</LineStyle>');
fprintf(fileID,'\n\t\t\t<PolyStyle>');
fprintf(fileID,'\n\t\t\t\t<color>7f00ff00</color>');
fprintf(fileID,'\n\t\t\t</PolyStyle>');
fprintf(fileID,'\n\t\t</Style>');
fprintf(fileID,'\n\t\t<Placemark>');
fprintf(fileID,'\n\t\t\t<name>Absolute Extruded</name>');
fprintf(fileID,'\n\t\t\t<description>Transparent green wall with yellow outlines</description>');
fprintf(fileID,'\n\t\t\t<styleUrl>#yellowLineGreenPoly</styleUrl>');
fprintf(fileID,'\n\t\t\t<LineString>');
fprintf(fileID,'\n\t\t\t\t<extrude>1</extrude>');
fprintf(fileID,'\n\t\t\t\t<tessellate>1</tessellate>');
fprintf(fileID,'\n\t\t\t\t<altitudeMode>absolute</altitudeMode>');
fprintf(fileID,'\n\t\t\t\t<coordinates>');

fspec = '\n\t\t\t\t\t%f,%f,%f';
nums = [long'; lat'; zeros(length(lat),1)';];
fprintf(fileID,fspec,nums);

fprintf(fileID,'\n\t\t\t\t</coordinates>');
fprintf(fileID,'\n\t\t\t</LineString>');
fprintf(fileID,'\n\t\t</Placemark>');
fprintf(fileID,'\n\t</Document>');
fprintf(fileID,'\n</kml>');

end

