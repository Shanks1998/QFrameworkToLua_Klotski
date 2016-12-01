--
-- Author: Your Name
-- Date: 2016-10-29 00:25:47
--

FRAMEWORK_INITED = false

if not FRAMEWORK_INITED then
	require "Framework.Define" 
	require "Framework.Utility"
	require "Framework.MsgDispatcher"
	require "Framework.Function"
	require "Framework.FSM"	
	FRAMEWORK_INITED = true
end 