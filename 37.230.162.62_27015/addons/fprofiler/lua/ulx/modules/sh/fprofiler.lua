local CATEGORY_NAME = "FProfiler"

function ulx.fprofiler_start_frame( ply )
	timer.Simple(FrameTime()*2, FProfiler.stop)
	FProfiler.start()
	DarkRP.notify(ply, 0, 4, "Готово!")
end
local com = ulx.command( CATEGORY_NAME, "ulx fp_stframe", ulx.fprofiler_start_frame, "!stframe" )
com:defaultAccess( ULib.ACCESS_SUPERADMIN )
com:help("Запустить FProfiler на тик")

function ulx.fprofiler_continue_frame( ply )
	timer.Simple(FrameTime()*2, FProfiler.stop)
	FProfiler.continueProfiling()
	DarkRP.notify(ply, 0, 4, "Готово!")
end

com = ulx.command( CATEGORY_NAME, "ulx fp_ctframe", ulx.fprofiler_continue_frame, "!ctframe" )
com:defaultAccess( ULib.ACCESS_SUPERADMIN )
com:help("Продолжить FProfiler на тик")
