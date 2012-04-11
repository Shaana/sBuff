sBuffSettings = {

	---Header
	
	--scale the header frames (including all children frames)
	--@value: > 0
	buffScale = 0.875,
	debuffScale = 0.875,
	
	--header frame anchors
	--check wowwiki.com for detailed information
	--@value: {point, relativeFrame, relativePoint, ofsx, ofsy}
	buffAnchor = {"TOPRIGHT", UIParent, "TOPRIGHT", -15, -15},
	debuffAnchor = {"TOPRIGHT", UIParent, "TOPRIGHT", -15, -266},
	
	--aura grow direction
	--f.e the first part of "LEFTDOWN" describes the button grow direction (here "LEFT"),
	--the second part (here "DOWN") describes the wrap direction
	--@value: "LEFTUP", "LEFTDOWN", "RIGHTUP", "RIGHTDOWN", "UPLEFT", "UPRIGHT", "DOWNLEFT", "DOWNRIGHT"
	buffGrowDirection = "LEFTDOWN",			
	debuffGrowDirection = "LEFTDOWN",
	
	--spacing between buttons
	--value in pixels
	--@value: positive integer
	buffHorizontalSpacing = 10,
	debuffHorizontalSpacing = 10,
	
	buffVerticalSpacing = 28,
	debuffVerticalSpacing = 28,
	
	--max number of aura buttons per row
	--@value: positive integer
	buffWrapAfter = 12, 			
	debuffWrapAfter = 12,
	
	--max number of rows
	--@value: positive integer
	buffMaxWraps = 3,
	debuffMaxWraps = 5,
		
	--methodes to sort the aura buttons
	--@value "INDEX", "NAME", "TIME"
	buffSortMethod = "TIME",			
	debuffSortMethod = "TIME",
		
	--sort direction,
	--"+": highest value is on the right side, "-": reversed
	--@value "+", "-"
	buffSortDir = "-", 						
	debuffSortDir = "-",
	
	--temporary weapons enchants (like rogue posions)
	--even on the ptr 4.2 still not properly working
	--@value: true, false
	showWeaponEnch = true,
	

	---Border
	
	--show/hide aura border
	--@value: true, false
	borderEnable = true,
	
	--border color
	--number between 0 and 1
	--@value: {r, g, b[, alpha]}
	borderBuffColor = {0.4, 0.4, 0.4, 1}, 
	borderDebuffColor = {0.8, 0, 0, 1}, 
	
	--border texture
	--choose between 
	--@value: "..\\Border", "..\\BorderThin", 
	borderTexture = "Interface\\AddOns\\sBuff\\textures\\BorderThin",
	
	--border thickness
	--5 works for the two mentioned border textures
	--value in pixel
	--@value: positive integer
	borderThickness = 5, 
	
	
	---Gloss
	
	--show/hide aura gloss
	--@value: true, false
	glossEnable = true,
	
	--gloss color
	--number between 0 and 1
	--@value: {r, g, b[, alpha]}
	glossColor = {0.2, 0.2, 0.2, 1},
	
	--gloss texture
	--choose between 
	--@value: "..\\Gloss", "..\\GlossThin", 
	glossTexture = "Interface\\AddOns\\sBuff\\textures\\GlossThin",
	
	---Text
		--Duration
		
		--show/hide time remaining 
		--@value: true, false
		textDurationEnable = true,
		
		--font to be used
		--@value: "Fonts\\FRIZQT__.TTF",	"Fonts\\ARIALN.TTF", "Fonts\\skurri.ttf", "Fonts\\MORPHEUS.ttf"
		textDurationFont = "Fonts\\FRIZQT__.TTF",
		
		--font size
		--@value: > 0
		textDurationFontSize = 16,
		
		--font style 
		--@value: nil, "OUTLINE", "THICKOUTLINE"
		textDurationFontStyle = nil,
		
		--font color
		--@value: {r, g, b[, alpha]}
		textDurationFontColor = {1.0, 1.0, 0.35, 1},
		
		--change the duration font color, if the time remaining on the aura falls below this value
		--@value: >=0
		textDurationFontColorChangeAtTime = 30,
		
		--font color, if time remainng is below textDurationFontColorChangeAtTime
		--@value: {r, g, b[, alpha]}
		textDurationFontColorExpireSoon = {1.0, 1.0, 1.0, 1},
		
		--duration text update frequency
		--update the text every 'value' seconds (0 means update it after every frame, with 60 fps -> 60 times a second)
		--low values use higher system performance, high values might lead to nonlinear duration texts
		--in seconds
		--@value: >= 0
		buffTextDurationUpdateFrequency = 0.5,
		debuffTextDurationUpdateFrequency	= 0.5,			
		
		--text position
		--@value: integer
		textDurationXOffset = 2, 		--horizontal
		textDurationYOffset = 0, 		--vertical

			--time formate
			--if the remaining time falls below this 'value' the time formate changes to miliseconds, seconds, minutes or hours
			--@value: >= 0
			showMiliSecs = 2,					--show in mili seconds
			showSecs = 60,						--show in seconds
			showMins = 60*60, 				--show in minutes
			showHours = 24*60*60, 		--show hours
		
		
		--StackCount
		
		--check describtion/@value above
		textStackEnable = true,
		textStackFont = "Fonts\\FRIZQT__.TTF",
		textStackFontSize = 18,
		textStackFontStyle = "OUTLINE",
		textStackFontColor = {1.0, 1.0, 1.0, 1},
		textStackXOffset = -6,
		textStackYOffset = 8,

	---Tooltip
	
	--add an extra line to the helpful aura (buffs) button Tooltip including the aura owner/caster
	--@value: true, false
	tooltipShowAuraOwner = true,								
	
	---GM ticket
	
	--allow to move aura anchors and GMTicketFrame anchors
	--@value: true, false
	GMTicketMoveEnable = true,
	
	--change the aura header anchers when the client has an active GM ticket.
	--@value: {point, relativeFrame, relativePoint, ofsx, ofsy}
	GMTicketBuffAnchor = {"TOPRIGHT", UIParent, "TOPRIGHT", -15, -73},
	GMTicketDebuffAnchor = {"TOPRIGHT", UIParent, "TOPRIGHT", -15, -324},
	
	--DO NOT CHANGE !
	buffTemplate = "sBuffButtonTemplate",
	debuffTemplate = "sDebuffButtonTemplate",
	
	buttonHeight = 56,
	buttonWidth = 56,
};