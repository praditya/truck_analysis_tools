function [ ] = pathwrite( name,lat,long,alt )
%pathwrite writes coordinates to KML for plotting in google maps

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
%         <coordinates>

%         </coordinates>
%       </LineString>
%     </Placemark>
%   </Document>
% </kml>
% lat
% long
% alt
fileID = fopen(name,'wt');
fprintf(fileID,'<?xml version="1.0" encoding="UTF-8"?>');
fprintf(fileID,'\n<kml xmlns="http://www.opengis.net/kml/2.2">');
fprintf(fileID,'\n\t<Document>');
fprintf(fileID,'\n\t\t<Style id="yellowLine">');
fprintf(fileID,'\n\t\t\t<LineStyle>');
fprintf(fileID,'\n\t\t\t\t<color>7f00ffff</color>');
fprintf(fileID,'\n\t\t\t\t<width>4</width>');
fprintf(fileID,'\n\t\t\t</LineStyle>');
fprintf(fileID,'\n\t\t</Style>');
fprintf(fileID,'\n\t\t<Placemark>');
fprintf(fileID,'\n\t\t\t<name>Path</name>');
fprintf(fileID,'\n\t\t\t<description>Yellow lined path</description>');
fprintf(fileID,'\n\t\t\t<styleUrl>#yellowLine</styleUrl>');
fprintf(fileID,'\n\t\t\t<LineString>');
fprintf(fileID,'\n\t\t\t\t<extrude>1</extrude>');
fprintf(fileID,'\n\t\t\t\t<tessellate>1</tessellate>');
fprintf(fileID,'\n\t\t\t\t<altitudeMode>absolute</altitudeMode>');
fprintf(fileID,'\n\t\t\t\t<coordinates>');

fspec = '\n\t\t\t\t\t%f,%f,%f';
nums = [long'; lat'; alt'];
fprintf(fileID,fspec,nums);

fprintf(fileID,'\n\t\t\t\t</coordinates>');
fprintf(fileID,'\n\t\t\t</LineString>');
fprintf(fileID,'\n\t\t</Placemark>');
fprintf(fileID,'\n\t</Document>');
fprintf(fileID,'\n</kml>');
fclose(fileID)
end

