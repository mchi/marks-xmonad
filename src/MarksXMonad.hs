module MarksXMonad where

import           Data.Ratio                       ((%))
import           RIO
import qualified RIO.Map                          as M
import           XMonad
import           XMonad.Actions.Plane
import           XMonad.Actions.Submap
import           XMonad.Actions.UpdatePointer
import           XMonad.Config.Xfce
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.AutoMaster
import           XMonad.Layout.Circle
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Grid
import           XMonad.Layout.IM
import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace       (onWorkspace)
import           XMonad.Layout.Reflect            (reflectHoriz, reflectVert)
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns
import           XMonad.Prompt
import           XMonad.Prompt.Shell
import qualified XMonad.StackSet                  as W
import           XMonad.Util.CustomKeys
import           XMonad.Util.EZConfig

{-
  Xmonad configuration variables. These settings control some of the
  simpler parts of xmonad's behavior and are straightforward to tweak.
-}
myModMask = mod1Mask

myFocusedBorderColor = "#CC7832" -- orange is "#CC7832"; yellow is "#BBB529"

myNormalBorderColor = "#333333" -- color of inactive border

myBorderWidth = 1 -- width of border around windows

myTerminal = "xfce4-terminal" -- which terminal software to use

{-
  Xmobar configuration variables. These settings control the appearance
  of text which xmonad is sending to xmobar via the DynamicLog hook.
-}
myTitleColor = "#eeeeee" -- color of window title

myTitleLength = 80 -- truncate window title to this length

myCurrentWSColor = "#e6744c" -- color of active workspace

myVisibleWSColor = "#c185a7" -- color of inactive workspace

myUrgentWSColor = "#cc0000" -- color of workspace with 'urgent' window

myCurrentWSLeft = "[" -- wrap active workspace with these

myCurrentWSRight = "]"

myVisibleWSLeft = "(" -- wrap inactive workspace with these

myVisibleWSRight = ")"

myUrgentWSLeft = "{" -- wrap urgent workspace with these

myUrgentWSRight = "}"

{-
  Workspace configuration. Here you can change the names of your
  workspaces. Note that they are organized in a grid corresponding
  to the layout of the number pad.

  This central organizational concept of this configuration is that
  the workspaces correspond to keys on the number pad, and that they
  are organized in a grid which also matches the layout of the number pad.
  So, I don't recommend changing the number of workspaces unless you are
  prepared to delve into the workspace navigation keybindings section
  as well.
-}
myWorkspaces = ["1", "2", "3", "4"]

startupWorkspace = "1" -- which workspace do you want to be on after launch?
  -- Full layout makes every window full screen. When you toggle the
  -- active window, it will bring the active window to the front.
  --  ||| (desktopLayoutModifiers $ getMiddleColumnSaneDefault 2 0.15 defaultThreeColumn)
  -- Full layout makes every window full screen. When you toggle the
  -- active window, it will bring the active window to the front.
  -- Circle layout places the master window in the center of the screen.
  -- Remaining windows appear in a circle around it
  -- ||| Circle
  -- Grid layout tries to equally distribute windows in the available
  -- space, increasing the number of columns and rows as necessary.
  -- Master window is at top left.

-- Define group of default layouts used on most screens, in the
-- order they will appear.
-- "smartBorders" modifier makes it so the borders on windows only
-- appear if there is more than one visible window.
-- "avoidStruts" modifier makes it so that the layout provides
-- space for the status bar at the top of the screen.
--defaultLayouts = smartBorders(avoidStruts(
---  ||| noBorders Full
---  ||| Grid))
default4kLayouts =
    smartBorders . avoidStruts . desktopLayoutModifiers $
    ((reflectVert . Mirror) (ResizableTall 1 (3 / 100) (3 / 4) []) |||
     (ResizableTall 1 (3 / 100) (1 / 2) []) ||| Grid ||| noBorders Full)

-- Here we combine our default layouts with our specific, workspace-locked
-- layouts.
myLayouts = default4kLayouts

myKeyBindings =
    [ ((myModMask .|. shiftMask, xK_M), windows W.swapMaster)
    , ((myModMask, xK_b), sendMessage ToggleStruts)
    , ((myModMask, xK_a), sendMessage MirrorShrink)
    , ((myModMask, xK_z), sendMessage MirrorExpand)
    , ((myModMask, xK_u), focusUrgent)
    , ((0, 0x1008FF12), spawn "amixer -D pulse set Master toggle")
    , ((0, 0x1008FF11), spawn "amixer -q set Master 10%-")
    , ((0, 0x1008FF13), spawn "amixer -q set Master 10%+")
    , ((myModMask .|. shiftMask, xK_g), spawn "google-chrome")
    , ((myModMask .|. controlMask, xK_x), shellPrompt def)
    ]
--
--swapWorkspaces:: W.Workspace i l a -> X ()
--swapWorkspaces targetWorkspace = do
--  screen <- gets (listToMaybe . W.visible . windowset)
--  whenJust screen $ windows . W.greedyView . W.tag . W.workspace
--
--    , ((myModMask, xK_p), spawn "dmenu_run -b")

myWorkspaceOrder = [0, 1, 2, 3, 4]

myKeys
 =
    myKeyBindings ++
    [ ( (m .|. myModMask, key)
      , screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_d, xK_w, xK_e, xK_r, xK_t] myWorkspaceOrder
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (W.greedyView, controlMask)]
    ] ++
    -- repeat for number keys
    [ ( (m .|. myModMask, key)
      , screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_1, xK_3, xK_4, xK_5, xK_0] myWorkspaceOrder
         -- was [0..] *** change to match your screen order ***
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]

myRemovedKeys =
    ["M-" ++ [n] | n <- ['1' .. '9']] ++ ["M-S-" ++ [n] | n <- ['1' .. '9']]

myLogHook = updatePointer (0.5, 0.5) (0, 0)

{-
  Here we actually stitch together all the configuration settings
  and run xmonad. We also spawn an instance of xmobar and pipe
  content into it via the logHook.
-}
runMarksXMonad = do
    xmonad $
        withUrgencyHook NoUrgencyHook $
        xfceConfig
            { focusedBorderColor = myFocusedBorderColor
            , normalBorderColor = myNormalBorderColor
            , terminal = myTerminal
            , borderWidth = myBorderWidth
            , layoutHook = myLayouts
            , workspaces = myWorkspaces
            , modMask = myModMask
            , logHook = dynamicLog >> myLogHook
            , focusFollowsMouse = False
            , handleEventHook = fullscreenEventHook
            , manageHook = manageHook def <+> manageDocks
            } `removeKeys`
        [(mod1Mask, xK_Return)] -- Defer to IntelliJ muscle memory
         `removeKeysP`
        myRemovedKeys `additionalKeys`
        myKeys
