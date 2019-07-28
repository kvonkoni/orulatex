-- Creating a string parser function
function split(str,pat)
	local tbl={}
	str:gsub(pat,function(x) tbl[#tbl+1]=x end)
	return tbl
end