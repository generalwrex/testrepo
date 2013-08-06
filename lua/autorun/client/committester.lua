include("commitchecker.lua")

concommand.Add( "testcommitchecker", function(ply, cmd, args, str)

	local ply = LocalPlayer()

	if not args[1] then return end
	
	print(args[1])
	
	local checker = GitChecker(args[1], {"2465c6cb7b6e02da7aacff92218ff58f2ccdaa70"}, 0)	
	PrintTable(checker)
	
	
	checker:Execute(function(success, json) print("Callback has registered", (success and "success!" or "failure.")) if json then PrintTable(json) end end)
	
end)