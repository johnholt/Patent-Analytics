import std, patent;

xmlFiles :=std.File.LogicalFileList('thor::patents**::xml');
txtFiles :=std.File.LogicalFileList('thor::patents**::txt');
sgmFiles :=std.File.LogicalFileList('thor::patents**::sgm');

// AllFiles_cnt := count(xmlFiles) + count(txtFiles) + count(sgmFiles);
AllFiles := xmlFiles + txtFiles + sgmFiles;

rec := record
	string50 fileName;
	string50 fileExt;
	recordof(AllFiles);
end;

rec xform(AllFiles l) := transform
	suffix_length := length(trim('::xml'));
	prefix_length := length(trim('thor::patents::') + 1);
	withoutSuffix := l.name[1..(LENGTH(TRIM(l.name))-suffix_length)];
	self.fileName := withoutSuffix[prefix_length..]; 
	self.fileExt  := l.name[(LENGTH(TRIM(l.name))-2)..];
	self := l;
end;
AllFiles_v1 := project(AllFiles, xform(left));

patent.layout_filetype doRollup(recordof(AllFiles_v1) l, dataset(recordof(AllFiles_v1)) allRows) := transform
	self.fileName := l.fileName;
	self.txt := if (count(allRows(fileExt = 'txt')) > 0, true, false);
	self.xml := if (count(allRows(fileExt = 'xml')) > 0, true, false);
	self.sgm := if (count(allRows(fileExt = 'sgm')) > 0, true, false);
end;

result := ROLLUP(group(sort(AllFiles_v1, fileName), fileName), GROUP, doRollup(LEFT, ROWS(LEFT)));

EXPORT FileNames_sprayed := result;
// EXPORT FileNames_sprayed := AllFiles_v1;
