



--local RepoOwner, RepoName  = "nrlulz", "ACF"
local RepoOwner, RepoName  = "generalwrex", "TestRepo"


function Test()

	local repourl = "https://api.github.com/repos/"..RepoOwner.."/"..RepoName.."/commits?per_page=1"

	http.Fetch( repourl, function(repojson) 
	local repo =  util.JSONToTable(repojson)[1] 

		--local repo = util.JSONToTable(file.Read("repotest.txt","DATA"))[1] 
		local commiturl      = repo.url
		
		http.Fetch( commiturl, function(commitjson) 
		local latestcommit = util.JSONToTable(commitjson) 
		
			--local latestcommit = util.JSONToTable(file.Read("committest.txt","DATA")) 
				
			local filename   = latestcommit.files[1].filename
			local commitdate = latestcommit.commit.committer.date
			local message    = latestcommit.commit.message
				
				
				// gets the time zone of the player
			local function get_timezone()
				local now = os.time()
				return os.difftime(now, os.time(os.date("!*t", now)))
			end

					// turns a git date into os.time() seconds then applys the players timezone to it
			local function format_gitdate(gitdate)
				local dt = string.Explode("T",gitdate)
				local edate = string.Explode("-",dt[1])
				local etime = string.Explode(":",dt[2])
				local time = os.time({year=edate[1],
					month=edate[2],day=edate[3],hour=etime[1],
					min =etime[2],
					sec = string.sub(etime[3],1,2)})
				return time+get_timezone()  
			end


			
			local Remote = format_gitdate(commitdate)
			local Local  = file.Time(filename,"GAME")
			
			if Remote > Local then
				print(RepoName.." is: Out Of Date")
			elseif Remote <= Local then
				print(RepoName.." is: Up To Date")	
			end
			
			print("File used for comparison: "..filename)
			print("remote file date: "..os.date("%c",format_gitdate(commitdate)))
			print("local file date: "..os.date("%c",file.Time(filename,"GAME")))
			print("Commit Message: "..message)
			
			end, print)	
	end, print)	

end
Test()




/* 
https://api.github.com/repos/generalwrex/testrepo/commits?per_page=1

JSON Data
[
  {
    "sha": "3b51c16e05527fdd8a88c816add690c880606e8a",
    "commit": {
      "author": {
        "name": "generalwrex",
        "email": "bjdroot@gmail.com",
        "date": "2013-08-08T01:04:52Z"
      },
      "committer": {
        "name": "generalwrex",
        "email": "bjdroot@gmail.com",
        "date": "2013-08-08T01:04:52Z"
      },
      "message": "added in repotest.lua starting the time comparison",
      "tree": {
        "sha": "cf941923ca4072f33876d78d8f487ee4a623c614",
        "url": "https://api.github.com/repos/generalwrex/testrepo/git/trees/cf941923ca4072f33876d78d8f487ee4a623c614"
      },
      "url": "https://api.github.com/repos/generalwrex/testrepo/git/commits/3b51c16e05527fdd8a88c816add690c880606e8a",
      "comment_count": 0
    },
    "url": "https://api.github.com/repos/generalwrex/testrepo/commits/3b51c16e05527fdd8a88c816add690c880606e8a",
    "html_url": "https://github.com/generalwrex/testrepo/commit/3b51c16e05527fdd8a88c816add690c880606e8a",
    "comments_url": "https://api.github.com/repos/generalwrex/testrepo/commits/3b51c16e05527fdd8a88c816add690c880606e8a/comments",
    "author": {
      "login": "generalwrex",
      "id": 1731139,
      "avatar_url": "https://secure.gravatar.com/avatar/42f9e17f4bdc22cd77129b35396873b3?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
      "gravatar_id": "42f9e17f4bdc22cd77129b35396873b3",
      "url": "https://api.github.com/users/generalwrex",
      "html_url": "https://github.com/generalwrex",
      "followers_url": "https://api.github.com/users/generalwrex/followers",
      "following_url": "https://api.github.com/users/generalwrex/following{/other_user}",
      "gists_url": "https://api.github.com/users/generalwrex/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/generalwrex/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/generalwrex/subscriptions",
      "organizations_url": "https://api.github.com/users/generalwrex/orgs",
      "repos_url": "https://api.github.com/users/generalwrex/repos",
      "events_url": "https://api.github.com/users/generalwrex/events{/privacy}",
      "received_events_url": "https://api.github.com/users/generalwrex/received_events",
      "type": "User"
    },
    "committer": {
      "login": "generalwrex",
      "id": 1731139,
      "avatar_url": "https://secure.gravatar.com/avatar/42f9e17f4bdc22cd77129b35396873b3?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
      "gravatar_id": "42f9e17f4bdc22cd77129b35396873b3",
      "url": "https://api.github.com/users/generalwrex",
      "html_url": "https://github.com/generalwrex",
      "followers_url": "https://api.github.com/users/generalwrex/followers",
      "following_url": "https://api.github.com/users/generalwrex/following{/other_user}",
      "gists_url": "https://api.github.com/users/generalwrex/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/generalwrex/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/generalwrex/subscriptions",
      "organizations_url": "https://api.github.com/users/generalwrex/orgs",
      "repos_url": "https://api.github.com/users/generalwrex/repos",
      "events_url": "https://api.github.com/users/generalwrex/events{/privacy}",
      "received_events_url": "https://api.github.com/users/generalwrex/received_events",
      "type": "User"
    },
    "parents": [
      {
        "sha": "f6aec914684e93164859cd47b2b19ad9d1f5b909",
        "url": "https://api.github.com/repos/generalwrex/testrepo/commits/f6aec914684e93164859cd47b2b19ad9d1f5b909",
        "html_url": "https://github.com/generalwrex/testrepo/commit/f6aec914684e93164859cd47b2b19ad9d1f5b909"
      }
    ]
  }
]

*/

/*
https://api.github.com/repos/generalwrex/testrepo/commits/3b51c16e05527fdd8a88c816add690c880606e8a
Commit JSON
{
  "sha": "3b51c16e05527fdd8a88c816add690c880606e8a",
  "commit": {
    "author": {
      "name": "generalwrex",
      "email": "bjdroot@gmail.com",
      "date": "2013-08-08T01:04:52Z"
    },
    "committer": {
      "name": "generalwrex",
      "email": "bjdroot@gmail.com",
      "date": "2013-08-08T01:04:52Z"
    },
    "message": "added in repotest.lua starting the time comparison",
    "tree": {
      "sha": "cf941923ca4072f33876d78d8f487ee4a623c614",
      "url": "https://api.github.com/repos/generalwrex/testrepo/git/trees/cf941923ca4072f33876d78d8f487ee4a623c614"
    },
    "url": "https://api.github.com/repos/generalwrex/testrepo/git/commits/3b51c16e05527fdd8a88c816add690c880606e8a",
    "comment_count": 0
  },
  "url": "https://api.github.com/repos/generalwrex/testrepo/commits/3b51c16e05527fdd8a88c816add690c880606e8a",
  "html_url": "https://github.com/generalwrex/testrepo/commit/3b51c16e05527fdd8a88c816add690c880606e8a",
  "comments_url": "https://api.github.com/repos/generalwrex/testrepo/commits/3b51c16e05527fdd8a88c816add690c880606e8a/comments",
  "author": {
    "login": "generalwrex",
    "id": 1731139,
    "avatar_url": "https://secure.gravatar.com/avatar/42f9e17f4bdc22cd77129b35396873b3?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
    "gravatar_id": "42f9e17f4bdc22cd77129b35396873b3",
    "url": "https://api.github.com/users/generalwrex",
    "html_url": "https://github.com/generalwrex",
    "followers_url": "https://api.github.com/users/generalwrex/followers",
    "following_url": "https://api.github.com/users/generalwrex/following{/other_user}",
    "gists_url": "https://api.github.com/users/generalwrex/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/generalwrex/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/generalwrex/subscriptions",
    "organizations_url": "https://api.github.com/users/generalwrex/orgs",
    "repos_url": "https://api.github.com/users/generalwrex/repos",
    "events_url": "https://api.github.com/users/generalwrex/events{/privacy}",
    "received_events_url": "https://api.github.com/users/generalwrex/received_events",
    "type": "User"
  },
  "committer": {
    "login": "generalwrex",
    "id": 1731139,
    "avatar_url": "https://secure.gravatar.com/avatar/42f9e17f4bdc22cd77129b35396873b3?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
    "gravatar_id": "42f9e17f4bdc22cd77129b35396873b3",
    "url": "https://api.github.com/users/generalwrex",
    "html_url": "https://github.com/generalwrex",
    "followers_url": "https://api.github.com/users/generalwrex/followers",
    "following_url": "https://api.github.com/users/generalwrex/following{/other_user}",
    "gists_url": "https://api.github.com/users/generalwrex/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/generalwrex/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/generalwrex/subscriptions",
    "organizations_url": "https://api.github.com/users/generalwrex/orgs",
    "repos_url": "https://api.github.com/users/generalwrex/repos",
    "events_url": "https://api.github.com/users/generalwrex/events{/privacy}",
    "received_events_url": "https://api.github.com/users/generalwrex/received_events",
    "type": "User"
  },
  "parents": [
    {
      "sha": "f6aec914684e93164859cd47b2b19ad9d1f5b909",
      "url": "https://api.github.com/repos/generalwrex/testrepo/commits/f6aec914684e93164859cd47b2b19ad9d1f5b909",
      "html_url": "https://github.com/generalwrex/testrepo/commit/f6aec914684e93164859cd47b2b19ad9d1f5b909"
    }
  ],
  "stats": {
    "total": 51,
    "additions": 51,
    "deletions": 0
  },
  "files": [
    {
      "sha": "ed70e755b1bb4700925627d454e40adcf885b56b",
      "filename": "lua/autorun/repotest.lua",
      "status": "added",
      "additions": 51,
      "deletions": 0,
      "changes": 51,
      "blob_url": "https://github.com/generalwrex/testrepo/blob/3b51c16e05527fdd8a88c816add690c880606e8a/lua/autorun/repotest.lua",
      "raw_url": "https://github.com/generalwrex/testrepo/raw/3b51c16e05527fdd8a88c816add690c880606e8a/lua/autorun/repotest.lua",
      "contents_url": "https://api.github.com/repos/generalwrex/testrepo/contents/lua/autorun/repotest.lua?ref=3b51c16e05527fdd8a88c816add690c880606e8a",
      "patch": "@@ -0,0 +1,51 @@\n+include(\"commitchecker.lua\")\n+\n+concommand.Add( \"testrepo\", function(ply, cmd, args, str)\n+\n+\tif not args[1] then return end\n+\t\n+\tprint(args[1])\n+\t\n+\tlocal checker = GitChecker(args[1], nil, 1)\t\n+\tPrintTable(checker)\n+\t\n+\tchecker:Execute(function(success, json)\n+\t\n+\t\t if json then \n+\t\t \n+\t\t\tlocal filename = json[\"files\"][1][\"filename\"]\n+\t\t\tlocal commitdate = json[\"commit\"][\"committer\"][\"date\"]\n+\t\t\t\n+\t\t\t// supposed to get a time zone of the local players pc, i have no idea if im using it right!! check it over! on line 34\n+\t\t\tlocal function get_timezone()\n+\t\t\t\tlocal now = os.time()\n+\t\t\t\treturn os.difftime(now, os.time(os.date(\"!*t\", now)))\n+\t\t\tend\n+\n+\t\t\t// turns a git date into os.time() seconds\n+\t\t\tlocal function format_gitdate(gitdate)\n+\t\t\t\tlocal dt = string.Explode(\"T\",gitdate)\n+\t\t\t\tlocal edate = string.Explode(\"-\",dt[1])\n+\t\t\t\tlocal etime = string.Explode(\":\",dt[2])\n+\t\t\t\tlocal time = os.time({year=edate[1],\n+\t\t\t\t\tmonth=edate[2],day=edate[3],hour=etime[1],\n+\t\t\t\t\tmin =etime[2],\n+\t\t\t\t\tsec = string.sub(etime[3],1,2)})\n+\t\t\t\treturn time+get_timezone()  // idk if i have this the right way\n+\t\t\tend\n+\n+\t\t\tprint(\"remote file date: \"..os.date(\"%c\",format_gitdate(commitdate)))\n+\n+\t\t\tprint(\"local file date: \"..os.date(\"%c\",file.Time(filename,\"GAME\")))\n+\t\t \n+\t\t end \n+\tend)\n+end)\n+\n+\n+\n+\n+\n+\n+\n+"
    }
  ]
}
*/