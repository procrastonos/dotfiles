---------------
-- xmonad.hs --
--- by DaeS ---
---------------

-- Import -------------------------------------------------
import XMonad                         -- XMonad
import XMonad.Hooks.DynamicLog        -- Xmobar 
import qualified XMonad.StackSet as W -- Keys
import qualified Data.Map as M        -- Keys
import Data.Monoid
import Data.Ratio ((%))
import System.Exit                    -- Exit

import XMonad.Util.Themes

import XMonad.Layout.ResizableTile    -- Rezise 
import XMonad.Layout.Tabbed           -- Tabs for Windows
import XMonad.Layout.Grid             -- Grid
import XMonad.Layout.Renamed          -- Rename Layouts
import XMonad.Layout.IM               -- IM-Layout
import XMonad.Layout.NoBorders		  -- turn off borders for full layout
import XMonad.Layout.PerWorkspace	  -- Assign Layot per Workspace
import XMonad.Layout.SubLayouts       -- Sub layouts
import XMonad.Layout.Simplest         -- Simple Layout
import XMonad.Layout.WindowNavigation -- Windows navigaton -- not really needed

import XMonad.Hooks.UrgencyHook       -- Urgent
import XMonad.Hooks.InsertPosition    -- Focus windows
import XMonad.Hooks.ManageHelpers     -- Helper functions
import XMonad.Hooks.ManageDocks       -- App workspace
import XMonad.Hooks.SetWMName
 
import XMonad.Actions.GridSelect      -- Grid
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.WindowBringer
-----------------------------------------------------------


-- Main -------------------------------------------------------
main =  do
	spawn "/usr/bin/feh --bg-max ~/mm/image/wp/arch-dark.png"
	spawn "xsetroot -cursor_name left_ptr -bg gray"
	spawn "llk"
--	spawn "compton -cfFb -i 0.8 -t 0.7 -r 5 -I 0.02 -D 10"
	
	xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig
---------------------------------------------------------------

-- Bar ---------
myBar = "xmobar"
---------------

-- Tab Theme
myTabConfig = defaultTheme { inactiveBorderColor = "#333344"
						   , activeBorderColor = "#556655" }

-- Custom Bar ---------------------------------------------------------
-- previeous colors
-- ppCurrent #6587a8
-- ppTitle	 #afafaf
myPP = xmobarPP { ppCurrent = xmobarColor "#6587a8" "" . wrap "›" "‹"
                , ppUrgent 	= xmobarColor "#fab20c" "" . wrap "[" "]"
                , ppTitle	= shorten 60
                , ppSep 	= xmobarColor "#6587a8" "" " » "
                , ppLayout  = xmobarColor "#a83030" ""
				, ppVisible = xmobarColor "#6587b8" "" . wrap "-" "-"
}
-----------------------------------------------------------------------

-- Main Conf --------------------------------------------
-- previous colors
-- normalBorderColor  #262728
-- focusedBorderColor #404040
myConfig = defaultConfig 
                         { terminal 			= "lilyterm"
                         , borderWidth 			= 2
--                       , normalBorderColor  	= "#262728"
--                       , normalBorderColor  	= "#161719"
                         , normalBorderColor  	= "#000000"
                         , focusedBorderColor 	= "#ca4418"
--                       , focusedBorderColor 	= "#6587a8"
                         , modMask 				= mod1Mask
                         , keys 				= myKeys
                         , layoutHook 			= myLayout
                         , manageHook 			= myManage
                         , workspaces 			= myWorkspaces
--						 , focusFollowsMouse 	= True
						 , mouseBindings		= myMouseBindings
--					     , handleEventHook		= myEventHook		-- myEventHook = mempty
--						 , logHook				= myLogHook			-- myLogHook = return ()
--						 , startupHook			= myStartupHook
						 , startupHook			= setWMName "LG3D" 
}
---------------------------------------------------------

-- Workspaces ----------------------------------------------------------------------------------------
myWorkspaces = ["1:web", "2:term", "3:code", "4:hdd", "5:other", "6:work", "7:mail", "8:media", "9:im", "0:tmp"]
------------------------------------------------------------------------------------------------------


-- Layouts --------------------------------------------------------------------
myLayout = windowNavigation $ onWorkspace "9:im" (myIMGrid ||| myTab) $ 
           myTall ||| myMTall ||| myFull ||| myTab ||| myGrid
             where
               rt 		= ResizableTall 1 (3/100) (55/100) []
               myFull	= renamed [Replace "full"]		$ (noBorders Full)
               myGrid 	= renamed [Replace "grid"] 		$ (smartBorders Grid)
               myTab 	= renamed [Replace "tabbed"] 	$ (smartBorders $ (tabbed shrinkText (theme wfarrTheme)))
--             mySimpleTab 	= renamed [Replace "tabbed"] 	$ (tabbed shrinkText (theme wfarrTheme))
--             myIMGrid = renamed [Replace "im-grid"] 	$ (smartBorders $ (gridIM (1%7) (And (Resource "main") (ClassName "psi"))))
               myIMGrid = renamed [Replace "im-grid"] 	$ (smartBorders $ (gridIM (1%7) (ClassName "Pidgin" `And` Role "buddy_list")))
               myTall 	= renamed [Replace "tall"] 		$ (smartBorders $ (subLayout [0,1,2] (Simplest) $ rt))
               myMTall 	= renamed [Replace "mirror"] 	$ (smartBorders $ (subLayout [0,1,2] (Simplest) $ Mirror rt))
			    
-------------------------------------------------------------------------------

-- Manage --------------------------------------------------------------
myManage = composeAll [ isFullscreen            	--> doFullFloat
                      , className =? "Gimp-2.6" 	--> doFloat
                      , className =? "qiv" 			--> doFloat
                      , className =? "MPlayer"  	--> doFloat
                      , className =? "mupdf" 		--> doFloat
                      , className =? "surf"     	--> doShift "1:web"
                      , className =? "Firefox"  	--> doShift "1:web"
                      , className =? "Gimp-2.8" 	--> doShift "6:work"
                      , className =? "claws-mail"	--> doShift "7:mail"
                      , className =? "pidgin"   	--> doShift "9:im"
                      , className =? "Mumble" 		--> doShift "9:im"
					  , className =? "psi"			--> doShift "9:im"
                      ]
-------------------------------------------------------------------------

-- Custom Tab----------------------------------------------
tabTheme = defaultTheme { decoHeight = 14
                        , activeColor = "#303030"
                        , activeBorderColor = "#404040"
                        , activeTextColor = "#050505"
                        , inactiveTextColor = "#454545"
                        , inactiveColor = "#252525"
                        , inactiveBorderColor = "#404040"
                        }
-----------------------------------------------------------

-- Grid -------------------------------------------
myGSConfig = defaultGSConfig { gs_cellwidth = 120 }
---------------------------------------------------

-- Keys ------------------------------------------------------------
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_z)

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
--------------------------------------------------------------------
-- Launch and Kill 
--------------------------------------------------------------------------------------------------------------------------------------------------------
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. controlMask, xK_Return), spawn "lilyterm -e dchroot -d")
--  , ((modm .|. controlMask, xK_Return), spawn "urxvt -name LURxvt")
    , ((0 ,                0x1008ff33), spawn "xfe")
    , ((0 ,                0x1008ff18), spawn "xfe")
    , ((0 ,                0x1008ff32), spawn "urxvt -e ncmpcpp")
    , ((0 ,                0x1008ff81), spawn "urxvt -e ncmpcpp")
    , ((0 ,                0x1008ff19), spawn "claws-mail")
    , ((0 ,                0x1008ff2a), spawn "oblogout")
    , ((0 ,                0x1008ff2f), spawn "pm-suspend")
    , ((modm,               xK_BackSpace), spawn "dmenu_run -fn 'snap-7' -nb '#151515' -nf '#919191' -sb '#151515' -sf '#c98f0a'")
    , ((modm .|. shiftMask, xK_adiaeresis     ), kill)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Print -----------------------------------------------------------------------------------
    , ((0,                     0xff61), spawn "scrot -e 'mv $f ~/tmp/scrot/ 2>/dev/null'")
--  , ((0,                  xK_Print ), spawn "scrot -e 'mv $f ~/tmp/scrot/ 2>/dev/null'")
--------------------------------------------------------------------------------------------

-- Vol ----------------------------------------------------------------
    , ((0 ,                0x1008ff13), spawn "amixer sset Master 5%+")
    , ((0 ,                0x1008ff11), spawn "amixer sset Master 5%-")
    , ((0 ,                0x1008ff12), spawn "amixer sset Master toggle")
    , ((shiftMask,         0x1008ff13), spawn "mpc -h 192.168.178.35 -P passwd volume +5")
    , ((shiftMask,         0x1008ff11), spawn "mpc -h 192.168.178.35 -P passwd volume -5")
    , ((shiftMask,         0x1008ff12), spawn "mpc -h 192.168.178.35 -P passwd volume 0")
-----------------------------------------------------------------------

-- Mpd ----------------------------------------------------
-- TODO: find out media keys, configure with global mpc variable
    , ((0 ,                0x1008ff14), spawn "mpc -h 192.168.178.35 -P passwd toggle")
    , ((0 ,                0x1008ff15), spawn "mpc -h 192.168.178.35 -P passwd stop")
    , ((0 ,                0x1008ff16), spawn "mpc -h 192.168.178.35 -P passwd prev")
    , ((0 ,                0x1008ff17), spawn "mpc -h 192.168.178.35 -P passwd next")
    , ((shiftMask,         0x1008ff14), spawn "mpc -P passwd toggle")
    , ((shiftMask,         0x1008ff15), spawn "mpc -P passwd stop")
    , ((shiftMask,         0x1008ff16), spawn "mpc -P passwd prev")
    , ((shiftMask,         0x1008ff17), spawn "mpc -P passwd next")
-----------------------------------------------------------

-- Grid --------------------------------------------------------
    , ((modm,               xK_g     ), goToSelected myGSConfig)
----------------------------------------------------------------

-- Layouts ----------------------------------------------------------------
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
---------------------------------------------------------------------------


-- Sub Layout ------------------------------------------------------------
    , ((modm .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    , ((modm .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    , ((modm .|. controlMask, xK_Down), sendMessage $ pullGroup D)
--
    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
--
    , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
    , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')
-------------------------------------------------------------------------
-- Resize viewed windows to the correct size ---
    , ((modm,               xK_j     ), refresh)
------------------------------------------------
-- Move focus ---------------------------------------------------------
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)
    , ((modm,               xK_n     ), windows W.focusDown)
    , ((modm,               xK_r     ), windows W.focusUp  )
    , ((modm,               xK_m     ), windows W.focusMaster)
    , ((modm,               xK_w     ), withFocused $ windows . W.sink)
-----------------------------------------------------------------------
-- Swap focused ---------------------------------------------
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_Down  ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_n     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_Up    ), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_r     ), windows W.swapUp    )
-------------------------------------------------------------
-- Resizing -------------------- --------------------------------
    , ((modm,               xK_Left  ), sendMessage Shrink)
    , ((modm,               xK_s     ), sendMessage Shrink)
    , ((modm,               xK_Right ), sendMessage Expand)
    , ((modm,               xK_t     ), sendMessage Expand)
    , ((modm,               xK_Down  ), sendMessage MirrorShrink)
    , ((modm,               xK_b	 ), sendMessage MirrorShrink)
    , ((modm,               xK_Up    ), sendMessage MirrorExpand)
    , ((modm,               xK_h     ), sendMessage MirrorExpand)
-----------------------------------------------------------------
-- Increment/Deincrement the number of windows in the master area ----
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
----------------------------------------------------------------------
-- Quit/Restart xmonad --------------------------------------------------------------
    , ((modm .|. shiftMask, xK_x     ), io (exitWith ExitSuccess))
    , ((modm, 				xK_x     ), spawn "xmonad --recompile; xmonad --restart")
    ]
-------------------------------------------------------------------------------------
-- Move client to workspace -----------------------------------
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

	++
	[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
		| (key, sc) <- zip [xK_v, xK_l, xK_c] [0..]
		, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

---------------------------------------------------------------

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

	-- mod-button1, Set the window to floating mode and move by dragging
	[ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
									   >> windows W.shiftMaster))

	-- mod-button2, Raise the window to the top of the stack
	, ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

	-- mod-button3, Set the window to floating mode and resize by dragging
	, ((modm, button3), (\w -> focus w >> mouseResizeWindow w
									   >> windows W.shiftMaster))

	-- you may also bind events to the mouse scroll wheel (button4 and button5)
	]
