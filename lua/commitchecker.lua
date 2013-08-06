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
		local ret = {repo = repo, tofetch = commit, commits = commitcount, fetchregistry = {}}
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
	local success, json
	http.Fetch(url,
		function(retdata, len)
			print(url, "has delivered!")
			success = true
			json = util.JSONToTable(retdata)
		end,
		function()
			print(url, "has NOT delivered!")
			success = false
		end
	)
		
	return 
		function()
			return success, json
		end
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
	Fetch the data stored in the GitChecker instance.  Execute will return the status code and parsed JSON to the callback when received.
	The callback may be called multiple times, depending on the configuration of the object.
	If using the latest-commits feature, the callback should be prepared to receive multiple commits in the same table.
	Args;
		callback	Function
			The function to be called upon fetch success.
	Return (to callback);
		status	Boolean
			True if fetch was successful, else false
		commitdata	Table
			The resulting commit data from the fetch.
]]--
function this:Execute(callback)
	local repo = self.repo
	if not repo then error("This checker instance does not have a repo to check.") return end
	
	local commits, tofetch, fetchreg = self.commits, self.tofetch, self.fetchregistry
	local url
	
	if commits and type(commits) == "number" and commits > 0 then
		url = string.format(GitLatest, repo, commits)
		fetchreg[#fetchreg + 1] = {GitFetcher(url), callback}
	end
	
	if tofetch and type(tofetch) == "table" then
		for _, v in pairs(tofetch) do
			url = string.format(GitCommit, repo, v)
			fetchreg[#fetchreg + 1] = {GitFetcher(url), callback}
		end
	end
	
	
	local timerid = "GitCommit" .. tostring(self)
	if not timer.Exists(timerid) then
		timer.Create(timerid, 0.1, 0, 
			function()
				for k, poller in pairs(fetchreg) do
					local success, json = poller[1]() -- poller
					if success ~= nil then
						print("Found that the url has", (success and "" or "NOT"), "delivered!")
						poller[2](success, json) -- callback
						fetchreg[k] = nil
					end
				end
				
				if table.Count(fetchreg) == 0 then
					timer.Remove(timerid)
				end
			end
		)
	end
	
	return ret
end