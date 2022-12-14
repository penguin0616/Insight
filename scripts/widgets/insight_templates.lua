-- This file largely does not fall under Insight's license. 
--local AccountItemFrame = require "widgets/redux/accountitemframe"
--local Grid = require "widgets/grid"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Menu = require "widgets/menu"
local NineSlice = require "widgets/dst/nineslice"
--local NumericSpinner = require "widgets/numericspinner"
--local Spinner = require "widgets/spinner"
local Text = require "widgets/text"
local TextEdit = require "widgets/textedit"
--local TrueScrollList = require "widgets/truescrolllist"
local UIAnim = require "widgets/uianim"
local Button = require "widgets/button"
local Widget = require "widgets/widget"

require("constants")
--require("skinsutils")
require("stringutil")

local TEMPLATES = {}

function TEMPLATES.ScreenRoot(name)
    local root = Widget(name or "root")
    root:SetVAnchor(ANCHOR_MIDDLE)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    return root
end

----------------
----------------
-- BACKGROUND --
----------------
----------------

local function MakeStretchedFullscreenBackground(bg)
    bg:SetVRegPoint(ANCHOR_MIDDLE)
    bg:SetHRegPoint(ANCHOR_MIDDLE)
    bg:SetVAnchor(ANCHOR_MIDDLE)
    bg:SetHAnchor(ANCHOR_MIDDLE)
    bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    return bg
end

-- Grey-bounded dialog with grey border (nine-slice)
-- title (optional) is anchored to top.
-- buttons (optional) are anchored to bottom.
-- Almost exact copy of CurlyWindow.
function TEMPLATES.RectangleWindow(atlas, sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text)
    local w = NineSlice(atlas)
    w.top = w:AddCrown("crown_top_fg.tex", ANCHOR_MIDDLE, ANCHOR_TOP, 0, 4)

    -- Background overlaps behind and foreground overlaps in front.
    w.bottom = w:AddCrown("crown_bottom_fg.tex", ANCHOR_MIDDLE, ANCHOR_BOTTOM, 0, -4)
    w.bottom:MoveToFront()

    -- Ensure we're within the bounds of looking good and fitting on screen.
    sizeX = math.clamp(sizeX or 200, 90, 1190)
    sizeY = math.clamp(sizeY or 200, 50, 620)
    w:SetSize(sizeX, sizeY)
    w:SetScale(0.7, 0.7)

    if title_text then
        w.title = w.top:AddChild(Text(HEADERFONT, 40, title_text, UICOLOURS.GOLD_SELECTED))
        w.title:SetPosition(0, -50)
        w.title:SetRegionSize(600, 50)
        w.title:SetHAlign(ANCHOR_MIDDLE)
        if JapaneseOnPS4() then
            w.title:SetSize(40)
        end
    end

    if bottom_buttons then
        -- If plain text widgets are passed in, then Menu will use this style.
        -- Otherwise, the style is ignored. Use appropriate style for the
        -- amount of space for buttons. Different styles require different
        -- spacing.
        local style = "carny_long"
        if button_spacing == nil then
            -- 1,2,3,4 buttons can be big at 210,420,630,840 widths.
            local space_per_button = sizeX / #bottom_buttons
            local has_space_for_big_buttons = space_per_button > 209
            if has_space_for_big_buttons then
                style = "carny_xlong"
                button_spacing = 320
            else
                button_spacing = 230
            end
        end
        local button_height = -30 -- cover bottom crown

        -- Does text need to be smaller than 30 for JapaneseOnPS4()?
        w.actions = w.bottom:AddChild(Menu(bottom_buttons, button_spacing, true, style, nil, 30))
        w.actions:SetPosition(-(button_spacing*(#bottom_buttons-1))/2, button_height)

        w.focus_forward = w.actions
    end

    if body_text then
        w.body = w:AddChild(Text(CHATFONT, 28, body_text, UICOLOURS.WHITE))
        w.body:EnableWordWrap(true)
        w.body:SetPosition(0, -20)
        local height_reduction = 0
        if bottom_buttons then
            height_reduction = 30
        end
        w.body:SetRegionSize(sizeX, sizeY - height_reduction)
        w.body:SetVAlign(ANCHOR_MIDDLE)
    end

    w.SetBackgroundTint = function(self, r,g,b,a)
        for i=4,5 do
            self.elements[i]:SetTint(r,g,b,a)
        end
        self.mid_center:SetTint(r,g,b,a)
    end

    w.HideBackground = function(self)
        for i=4,5 do
            self.elements[i]:Hide()
        end
        self.mid_center:Hide()
    end

    w.InsertWidget = function(self, widget)
		w:AddChild(widget)
		for i=1,3 do
            self.elements[i]:MoveToFront()
        end
        for i=6,8 do
            self.elements[i]:MoveToFront()
        end
        w.bottom:MoveToFront()
		return widget
    end

    -- Default to our standard brown.
    local r,g,b = unpack(UICOLOURS.BROWN_DARK)
    w:SetBackgroundTint(r,g,b,0.6)

    return w
end

local normal_list_item_bg_tint = { 1,1,1,0.5 }
local function GetListItemPrefix(row_width, row_height)
    local prefix = "listitem_thick" -- 320 / 90 = 3.6
    local ratio = row_width / row_height
    if ratio > 6 then
        -- Longer texture will look better at this aspect ratio.
        prefix = "serverlist_listitem" -- 1220.0 / 50 = 24.4
    end
    return prefix
end

-- A list item backing that shows focus.
--
-- May want to call OnWidgetFocus if using with TrueScrollList or
-- ScrollingGrid:
--   row:SetOnGainFocus(function() self.scroll_list:OnWidgetFocus(row) end)
function TEMPLATES.ListItemBackground(row_width, row_height, onclick_fn)
    local prefix = GetListItemPrefix(row_width, row_height)
    local focus_list_item_bg_tint  = { 1,1,1,0.7 }

    local row = ImageButton("images/dst/frontend_redux.xml",
        prefix .."_normal.tex", -- normal
        nil, -- focus
        nil,
        nil,
        prefix .."_selected.tex" -- selected
        )
    row:ForceImageSize(row_width,row_height)
    row:SetImageNormalColour(  unpack(normal_list_item_bg_tint))
    row:SetImageFocusColour(   unpack(focus_list_item_bg_tint))
    row:SetImageSelectedColour(unpack(normal_list_item_bg_tint))
    row:SetImageDisabledColour(unpack(normal_list_item_bg_tint))
    row.scale_on_focus = false
    row.move_on_click = false

    if onclick_fn then
        row:SetOnClick(onclick_fn)
        -- FocusOverlay caused incorrect scaling on morgue screen, but it
        -- wasn't clickable. Related?
        row:UseFocusOverlay(prefix .."_hover.tex")
    else
        row:SetHelpTextMessage("") -- doesn't respond to clicks
    end
    return row
end

return TEMPLATES