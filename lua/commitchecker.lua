--[[
	CommitChecker, WIP By Bubbus with concept by General Wrex.
	
	Create a new instance of GitChecker with the function:
		GitChecker(repo, tofetch, commitcount)
		Args;
			repo	String
				The github repo to fetch from
			tofetch	String
				The SHA of an existing commit to fetch.
			commitcount	Number
				The number of latest commits to fetch.
		Return;
			ret	Table
				commit	Table
					The resulting commit data of the tofetch argument
				commits	Table
					The resulting commit data of the commitcount argument
			
	Setter-functions also exist to facilitate reuse of GitChecker objects.
	
	Fetch your data by using GitChecker:Execute().  Execute uses synchronized coroutines and will take a while to complete.
	It's therefore recommended to use this function in an asynchronous coroutine so Lua isn't blocked.

]]--


local GitPage = "https://github.com/%s"
local GitLatest = "https://api.github.com/repos/%s/commits?per_page=%i"
local GitCommit = "https://api.github.com/repos/%s/commits/%s"




-- Creating the GitChecker prototype.
GitChecker = GitChecker or {}
local this = GitChecker
setmetatable(this, {__call = 
	function(self, repo, commit, commitcount) 
		if self ~= this then return end
		local ret = {repo = repo, tofetch = commit, commits = commitcount}
		setmetatable(ret, {__index = this})
		return ret
	end}
)




--[[
	Fetch JSON formatted data from the url, convert to Lua table, return with success code.
	Args;
		url	String
			The url to fetch JSON from
	Yield;
		success	Boolean
			true if retrieval was successful, else false
		JSON	Table/Boolean
			Table if retrieval was successful, else false
]]--
local function GitFetcher(url)
	local success, failed, returnedJSON = false, false
	http.Fetch( url,
		function(json)
			success = true
			returnedJSON = json
		end,
		
		function()
			failed = true
		end
	)
	
	while not (success or failed) do
		coroutine.wait(0.1)
		print("Waiting for", url)
	end
	
	print(url, "has", (failed and "NOT" or ""), "delivered!")
	
	coroutine.yield(success, success and util.JSONToTable(returnedJSON))
end




--[[
	Set the repo to fetch from
]]--
function this.SetRepo(repo)
	this.repo = repo or error("Tried to set GitChecker to a nil repo.")
end


--[[
	Set the amount of latest commits to fetch
]]--
function this.SetCommitCount(ct)
	this.commits = ct or error("Tried to set GitChecker to retrieve nil latest-commits.")
end


--[[
	Set a specific commit to fetch
]]--
function this.SetFetchCommit(commit)
	this.tofetch = commit or error("Tried to set GitChecker to retrieve nil specified commits.")
end




--[[
	Fetch the data stored in the GitChecker instance.  Execute uses synchronized coroutines and will take a while to complete.
	It's therefore recommended to use this function in an asynchronous coroutine so Lua isn't blocked.
	Args;
		repo	String
			The github repo to fetch from
		tofetch	String
			The SHA of an existing commit to fetch.
		commitcount	Number
			The number of latest commits to fetch.
	Return;
		ret	Table
			commit	Table
				The resulting commit data of the tofetch argument
			commits	Table
				The resulting commit data of the commitcount argument
]]--
function this.Execute()
	if not this.repo then error("This checker instance does not have a repo to check.") return end
	
	local url, co, ret
	
	
	if commits and type(commits) == "number" and commits > 0 then
		url = string.format(GitLatest, repo, commits)
		co = coroutine.create(GitFetcher(url))
		
		success, json = coroutine.resume(co)
	
		if success then
			ret = {commits = json}
		end
	end
	
	
	if tofetch and type(tofetch) == "string" then
		url = string.format(GitCommit, repo, tofetch)
		co = coroutine.create(GitFetcher(url))
		
		success, json = coroutine.resume(co)
		
		if success then
			ret = ret or {}
			ret.commit = json
		end
	end
	
	return ret
end