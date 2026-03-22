local function AdvDupe2_ReceiveFile(len, ply)

	net.ReadStream(nil, function(data)
		AdvDupe2.RemoveProgressBar()

		if not data then
			AdvDupe2.Notify("File was not saved!", NOTIFY_ERROR, 5)

			return
		end

		local path = AdvDupe2.GetFilename(AdvDupe2.SavePath)
		local dupefile = file.Open(path, "wb", "DATA")

		if not dupefile then
			AdvDupe2.Notify("File was not saved!", NOTIFY_ERROR, 5)
			return
		end

		dupefile:Write(data)
		dupefile:Close()

		if not file.Exists(path, "DATA") then
			AdvDupe2.Notify("File does not exist", NOTIFY_ERROR)
			return
		end

		local readFile = file.Open(path, "rb", "DATA")
		if not readFile then
			AdvDupe2.Notify("File could not be read", NOTIFY_ERROR)
			return
		end

		local readData = readFile:Read(readFile:Size())
		readFile:Close()
		local success, dupe, info, moreinfo = AdvDupe2.Decode(readData)

		if not success then
			AdvDupe2.Notify("File could not be read: " .. dupe, NOTIFY_ERROR)
			return
		end

		local filename = string.StripExtension(string.GetFileFromFilename(path))
		AdvDupe2.FileBrowser.Browser.pnlCanvas.ActionNode:AddFile(filename)
		AdvDupe2.FileBrowser.Browser.pnlCanvas:Sort(AdvDupe2.FileBrowser.Browser.pnlCanvas.ActionNode)

		AdvDupe2.Notify("File successfully saved!", NOTIFY_GENERIC, 5)
	end)
end
net.Receive("AdvDupe2_ReceiveFile", AdvDupe2_ReceiveFile)

local uploading = nil
function AdvDupe2.UploadFile(ReadPath, ReadArea)
	if uploading then
		AdvDupe2.Notify("Already opening file, please wait.", NOTIFY_ERROR)
		return
	end

	local can, res = hook.Run("AdvDupe2_CanUploadFile", LocalPlayer())
	if can == false then
		local text = res or "You doesn't have permission for this."
		AdvDupe2.Notify(text, NOTIFY_ERROR)
		return false
	end

	if ReadArea == 0 then
		ReadPath = AdvDupe2.DataFolder .. "/" .. ReadPath .. ".txt"
	elseif ReadArea == 1 then
		ReadPath = AdvDupe2.DataFolder .. "/-Public-/" .. ReadPath .. ".txt"
	else
		ReadPath = "adv_duplicator/" .. ReadPath .. ".txt"
	end

	if not file.Exists(ReadPath, "DATA") then
		AdvDupe2.Notify("File does not exist", NOTIFY_ERROR)

		return
	end

	local read = file.Read(ReadPath)

	if not read then
		AdvDupe2.Notify("File could not be read", NOTIFY_ERROR)

		return
	end

	local name = string.Explode("/", ReadPath)
	name = name[#name]
	name = string.sub(name, 1, #name - 4)
	local success, dupe, info, moreinfo = AdvDupe2.Decode(read)

	if success then
		net.Start("AdvDupe2_ReceiveFile")
		net.WriteString(name)

		uploading = net.WriteStream(read, function()
			uploading = nil
			AdvDupe2.File = nil
			AdvDupe2.RemoveProgressBar()
		end)

		net.SendToServer()
		AdvDupe2.LoadGhosts(dupe, info, moreinfo, name)
	else
		AdvDupe2.Notify("File could not be decoded. (" .. dupe .. ") Upload Canceled.", NOTIFY_ERROR)
	end
end

hook.Add("AdvDupe2_CanUploadFile", "adv2dupe2.Permission", function(ply)
	if not AdvDupe2.plyJobs[ply:Team()] then
		return false
	end
end)