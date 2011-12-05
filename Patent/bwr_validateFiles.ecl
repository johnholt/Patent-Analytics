
import std, patent;

sprayed 	:= patent.FileNames_sprayed;
xml_sprayed := sprayed(fileExt = 'xml');
txt_sprayed := sprayed(fileExt = 'txt');
sgm_sprayed := sprayed(fileExt = 'sgm');

fullText 	:= patent.FileNames_FullText;
bgData	 	:= patent.FileNames_BGData;
ocrText 	:= patent.FileNames_OCRText;

xml_join := join(fullText, xml_sprayed, left.filename = right.filename, transform(recordof(right), self := right));
output(count(xml_join), named('xml_join'));
output(count(xml_sprayed), named('xml_sprayed'));

txt_join := join(fullText, txt_sprayed, left.filename = right.filename, transform(recordof(right), self := right));
output(count(txt_join), named('txt_join'));
output(count(txt_sprayed), named('txt_sprayed'));

sgm_join := join(fullText, sgm_sprayed, left.filename = right.filename, transform(recordof(right), self := right));
output(count(sgm_join), named('sgm_join'));
output(count(sgm_sprayed), named('sgm_sprayed'));

output(count(fullText), named('FullText_TotalCount'));
output(count(sprayed), named('Sprayed_TotalCount'));