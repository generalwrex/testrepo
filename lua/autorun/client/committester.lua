concommand.Add( "testcommitchecker", function(ply, cmd, args, str)

	local ply = LocalPlayer()

	if not args[1] then return end
	
	local checker = GitChecker(args[1], nil, 1)	
	
	PrintTable(checker:Execute())
	
end)