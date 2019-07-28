-- TEST::: Print the weeks listed
function print_weeks()
    for i,line in ipairs(weeknum) do
        tex.print(line)
	end
end