
import std, patent;

// sprayed
sprayed 	:= patent.FileNames_sprayed;
output(sort(sprayed, filename), all);
output(count(sprayed));
output(count(sprayed(xml = true)));
output(count(sprayed(txt = true)));
output(count(sprayed(sgm = true)));

// A list of zip files
count(patent.FileNames_FullText);
fullText 	:= project(patent.FileNames_FullText, transform(patent.layout_filetype, self.xml := false, self.txt := false, self.sgm := false, self := left));
j1  := join(fullText, sprayed(xml = true), left.filename = right.filename, transform(patent.layout_filetype, self.xml := true, self := left));
j10 := join(fullText, sprayed(xml = true), left.filename = right.filename, transform(recordof(left), self := left), left only);

j2  := join(j10, sprayed(txt = true), left.filename = right.filename, transform(patent.layout_filetype, self.txt := true, self := left));
j20 := join(j10, sprayed(txt = true), left.filename = right.filename, transform(recordof(left), self := left), left only);

j3  := join(j20, sprayed(sgm = true), left.filename = right.filename, transform(patent.layout_filetype, self.sgm := true, self := left));
j30 := join(j20, sprayed(sgm = true), left.filename = right.filename, transform(recordof(left), self := left), left only);
allJoins := j1 + j2 + j3;

patent.layout_filetype doRollup(recordof(allJoins) l, dataset(recordof(allJoins)) allRows) := transform
	self.fileName := l.fileName;
	self.txt := if (count(allRows(txt = true)) > 0, true, false);
	self.xml := if (count(allRows(xml = true)) > 0, true, false);
	self.sgm := if (count(allRows(sgm = true)) > 0, true, false);
end;
allZipFiles := ROLLUP(group(sort(allJoins, fileName), fileName), GROUP, doRollup(LEFT, ROWS(LEFT)));

output(sort(allZipFiles, filename), all);
output(count(allZipFiles));
output(count(allZipFiles(xml = true)));
output(count(allZipFiles(txt = true)));
output(count(allZipFiles(sgm = true)));

output(j30);
output(count(j30));

rec := record
	string50 fileName;
	patent.layout_filetype zipFile;
	patent.layout_filetype sprayedFile;
end;

rec xform1(sprayed l, allZipfiles r) := transform
	self.fileName := l.fileName;
	self.ZipFile.xml := l.xml;
	self.ZipFile.txt := l.txt;
	self.ZipFile.sgm := l.sgm;
	self.sprayedFile.xml := l.xml;
	self.sprayedFile.txt := l.txt;
	self.sprayedFile.sgm := l.sgm;
	self := [];
end;
r1 := join(sprayed, allZipFiles, left.fileName = right.fileName, xform1(left, right));
output(r1, all);

// output(r1(zipFile.xml != sprayedFile.xml or zipFile.sgm != sprayedFile.sgm or zipFile.txt != sprayedFile.txt));
output(r1(zipFile.txt != sprayedFile.txt));