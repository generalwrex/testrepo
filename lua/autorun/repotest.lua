include("commitchecker.lua")

concommand.Add( "testrepo", function(ply, cmd, args, str)

	if not args[1] then return end
	
	print(args[1])
	
	local checker = GitChecker(args[1], nil, 1)	
	PrintTable(checker)
	
	checker:Execute(function(success, json)
	
		 if json then 
		 
			local filename = json["files"][1]["filename"]
			local commitdate = json["commit"]["committer"]["date"]
			
			// supposed to get a time zone of the local players pc, i have no idea if im using it right!! check it over! on line 34
			local function get_timezone()
				local now = os.time()
				return os.difftime(now, os.time(os.date("!*t", now)))
			end

			// turns a git date into os.time() seconds
			local function format_gitdate(gitdate)
				local dt = string.Explode("T",gitdate)
				local edate = string.Explode("-",dt[1])
				local etime = string.Explode(":",dt[2])
				local time = os.time({year=edate[1],
					month=edate[2],day=edate[3],hour=etime[1],
					min =etime[2],
					sec = string.sub(etime[3],1,2)})
				return time+get_timezone()  // idk if i have this the right way
			end

			print("remote file date: "..os.date("%c",format_gitdate(commitdate)))

			print("local file date: "..os.date("%c",file.Time(filename,"GAME")))
		 
		 end 
	end)
end)








