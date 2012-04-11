--[[----------------------------------------------------------------------------------------
	[sBuff is a simple Ace3 Addon to dispaly player auras]

	Copyright (C) 2012, Share

	This program is free software; you can redistribute it and/or modify it
	under the terms of the GNU General Public License as published
	by the Free Software Foundation; either version 3 of the License,
	or (at your option) any later version.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with this program;
	if not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------------------]]
--NOTE: addon based on http://www.wowinterface.com/forums/showthread.php?t=36117
--check for more infos about SecureAuraHeaderTemplate

sBuff = LibStub("AceAddon-3.0"):NewAddon("sBuff", "AceEvent-3.0");

local _G = getfenv(0);	

local sBuffFrame, headerBuffs, headerDebuffs;

---simple header button interator
--find and return active header button children
local function button_interator(header)
	local i = 1;
	local children = {};
	local child = header:GetAttribute("Child"..i);
	
	while child do
		if child:IsShown() then
			children[i] = child;
			--children[#children + 1] = child;
		end
		i = i + 1;
		child = header:GetAttribute("Child"..i);
	end
	
	return children;
end

---interator for temp enchant buttons (only!)
local function tempEnchant_interator(header)
	local tempEnchants = {};
	for i = 1, 3 do
		tempEnchants[i] = header:GetAttribute("tempEnchant"..i);
	end
	return tempEnchants;
end

---add the aura caster/owner to the aura tooltip
--after adding a line call GameTooltip:Show()
--using the unit class color
function sBuff:tooltip_auraOwner(index, filter)
	local unit = select(8, UnitAura("player", index, filter));
	--we have to return a emtpy table, cause we use unpack(...) later
	if not unit then 
		return {}; 
	end
	local unit_name = UnitName(unit);
	local unit_class = select(2, UnitClass(unit));
	local color = RAID_CLASS_COLORS[unit_class]; 								
	return {unit_name, color.r, color.g, color.b, true};
end

function sBuff:OnInitialize()
	--Anchor for the headers
	--sBuffFrame = CreateFrame("Frame", "sBuffFrame", UIParent);
	--sBuffFrame:SetPoint("CENTER", 0, 0);
	
	--initialize the secure aura headers with Blizzards SecureAuraHeaderTemplate
	headerBuffs = CreateFrame("Frame","sBuff_HeaderBuffs", UIParent, "SecureAuraHeaderTemplate");
	headerDebuffs = CreateFrame("Frame","sBuff_HeaderDebuffs", UIParent, "SecureAuraHeaderTemplate");
end

function sBuff:OnEnable()
	local s = sBuffSettings;
	
	--set attributes
  sBuff:SetHeaderAttributes(headerBuffs, true);
  sBuff:SetHeaderAttributes(headerDebuffs, false);
	
	--set anchors
	headerBuffs:SetPoint(unpack(sBuffSettings.buffAnchor));
	headerDebuffs:SetPoint(unpack(sBuffSettings.debuffAnchor));

	--hide blizzard auras
  BuffFrame:UnregisterEvent("UNIT_AURA");
  BuffFrame:Hide();
  TemporaryEnchantFrame:Hide();
  ConsolidatedBuffs:Hide();
  
  --GM ticket
  --TODO rewrite from scratch, this implementation sucks
  if s.GMTicketMoveEnable then
  	if TicketStatusFrame then
	  	TicketStatusFrame:ClearAllPoints();
	  	TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", s.GMTicketBuffAnchor[4], -5);
	  	
	  	TicketStatusFrame:SetScript("OnShow", function(self) 
	  		headerBuffs:SetPoint(unpack(sBuffSettings.GMTicketBuffAnchor));
				headerDebuffs:SetPoint(unpack(sBuffSettings.GMTicketDebuffAnchor));
	  	end);
	  	
	  	TicketStatusFrame:SetScript("OnHide", function(self) 
	  		if( not GMChatStatusFrame or not GMChatStatusFrame:IsShown() ) then
	        headerBuffs:SetPoint(unpack(sBuffSettings.buffAnchor));
					headerDebuffs:SetPoint(unpack(sBuffSettings.debuffAnchor));
	    	end
	  	end);
  	end
  		
  	if GMChatStatusFrame then
  		GMChatStatusFrame:ClearAllPoints();
  		GMChatStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", s.GMTicketBuffAnchor[4], -5);
  	end
  	--GMChatStatusFrame 72
  	--GMChatStatusFrame 290
  	
  	--self:RegisterEvent("UPDATE_TICKET");
  	--self:RegisterEvent("GMSURVEY_DISPLAY");
  	--self:RegisterEvent("GMRESPONSE_RECEIVED");
  end
end

function sBuff:OnDisable()
	--not implemented
end

---set the attributes for the SecureAuraHeaderTemplate
--check AuraButtonTemplate.xml
function sBuff:SetHeaderAttributes(header, isBuff)
	local function a(...) 
		header:SetAttribute(...);
	end
	local s = sBuffSettings;
	local b = isBuff;

	local x, y = ((b and s.buffHorizontalSpacing or s.debuffHorizontalSpacing) + s.buttonWidth), ((b and s.buffVerticalSpacing or s.debuffVerticalSpacing) + s.buttonHeight);
	
	--xOffset, yOffset, wrapXOffset, wrapYOffset
	local growDir = {	["LEFTUP"] 		= {-x, 0, 0, y},
										["LEFTDOWN"]	= {-x, 0, 0, -y},
										["RIGHTUP"] 	= {x, 0, 0, y},
										["RIGHTDOWN"] = {x, 0, 0, -y},
										["UPLEFT"] 		= {0, y, -x, 0},
										["UPRIGHT"] 	= {0, y, x, 0},
										["DOWNLEFT"] 	= {0, -y, -x, 0},
										["DOWNRIGHT"] = {0, -y, x, 0},										
	} 

	local gDir = growDir[b and s.buffGrowDirection or s.debuffGrowDirection];
	
	header.filter = b and "HELPFUL" or "HARMFUL";
	
	--Every time an attribute is change the Blizzard function updates the entire header,
	--unless the "_ignore" attribute is set
	local oldIgnore = header:GetAttribute("_ignore");
	a("_ignore", "attributeChanges");

	-- same as in C (a < b) ? a : b;
	-- in lua a < b and a or b;
	a("unit", "player");
	a("filter", header.filter);
	a("template", b and s.buffTemplate or s.debuffTemplate); 
	a("minWidth", 100);
	a("minHeight", 100);
		
	-- anchor, spacing, offset
	a("point", b and s.buffAnchor[1] or s.debuffAnchor[1]); 
	a("xOffset", gDir[1]);
	a("yOffset", gDir[2]);
	a("wrapAfter", b and s.buffWrapAfter or s.debuffWrapAfter);
	a("wrapXOffset", gDir[3]);
	a("wrapYOffset", gDir[4]);
	a("maxWraps", b and s.buffMaxWraps or s.debuffMaxWraps);
	
	--a("xOffset", b and s.buffXOffset or s.debuffXOffset);
	--a("yOffset", b and s.buffYOffset or s.debuffYOffset);
	--a("wrapXOffset", b and s.buffWrapXOffset or s.debuffWrapXOffset);
	--a("wrapYOffset", b and s.buffWrapYOffset or s.debuffWrapYOffset);

	-- sorting
	a("sortMethod", b and s.buffSortMethod or s.debuffSortMethod); 
	a("sortDir", b and s.buffSortDir or s.debuffSortDir);
	
	if b and s.showWeaponEnch then
 		a("includeWeapons", 1);
  	a("weaponTemplate", s.buffTemplate);
  end
	
	--reverse the "_ignore" attribute
	a("_ignore", oldIgnore);
	a("_update", header:GetAttribute("_update"));
	
	--attach functions
	function header:GetChildren() 
		return button_interator(self);
	end
	
	if isBuff then
		function header:GetTempEnchants()
			return tempEnchant_interator(self);
		end
	end
	
	header:SetScale(b and s.buffScale or s.debuffScale);

	--Blizzard updates the aura header anytime it is shown, it receives a UNIT_AURA event
	header:RegisterEvent("PLAYER_ENTERING_WORLD");
	header:RegisterEvent("UNIT_INVENTORY_CHANGED");
	
	--OnEvent(self, "event", ...)
	header:HookScript("OnEvent", function(...) sBuff:UpdateHeader(...) end);

	header:Show();
	header.NumUpdates = 0;
end

---Create all sub frames for a button object
--including textures, fontStrings
--iconTex, borderTex, glossTex, durationText, CountText
function sBuff:CreateAuraFrames(button, filter)
	local s = sBuffSettings;
	local i, j = s.borderThickness, s.borderThickness/button:GetSize();
	local b = (filter == "HELPFUL");
	
	local function c(level)
		local c = CreateFrame("Frame", nil, button);
		c:SetAllPoints(button);
		c:SetFrameLevel(level);
		return c;
	end

	local function t(frame, layer, texture, color)
		local t = frame:CreateTexture(nil, layer);
		t:SetAllPoints(button);
		t:SetTexture(texture);
		t:SetVertexColor(unpack(color));
		return t;
	end

	local function f(frame, font, color, size, style)
		local f = frame:CreateFontString(nil, "OVERLAY");
		f:SetFontObject(GameFontNormalSmall);
		f:SetTextColor(unpack(color));
		f:SetFont(font, size, style);
		return f;
	end

	--icon
	button.icon = c(1);
	button.icon.texture = button.icon:CreateTexture(nil, "BACKGROUND");
  button.icon.texture:SetPoint("TOPLEFT", i, -i)
  button.icon.texture:SetPoint("BOTTOMRIGHT", -i, i)
  button.icon.texture:SetTexCoord(j, 1-j, j, 1-j)
	
	--border
	if s.borderEnable then
		button.border = c(2);
		--border coloring depending on filter
		button.border.texture = t(button.border, "BORDER", s.borderTexture, b and s.borderBuffColor or s.borderDebuffColor);
	end
	
	--gloss
	if s.glossEnable then
		button.gloss = c(3);
		button.gloss.texture = t(button.gloss, "BORDER", s.glossTexture, s.glossColor);
	end

	--text
	if s.textDurationEnable or s.textStackEnable then
		button.text = c(8)
		
		--duration
		if s.textDurationEnable then
			button.text.duration = f(button.text, s.textDurationFont, s.textDurationFontColor, s.textDurationFontSize, s.textDurationFontStyle);
			button.text.duration:SetPoint("TOP", button.text, "BOTTOM", s.textDurationXOffset, s.textDurationYOffset);
		end

		--stack count
		if s.textStackEnable then
			button.text.stack = f(button.text, s.textStackFont, s.textStackFontColor, s.textStackFontSize, s.textStackFontStyle);
			button.text.stack:SetPoint("BOTTOMRIGHT", button.text, "BOTTOMRIGHT", s.textStackXOffset, s.textStackYOffset);
		end
	end
	
	button.filter = filter;
	button.lastUpdate = 0;
	button.hasActiveToolTip = false;
	button.frequency = b and s.buffTextDurationUpdateFrequency or s.debuffTextDurationUpdateFrequency;
	button.created = true;
end

---update the aura header
--special treatement for weaponTempEnchants
function sBuff:UpdateHeader(header, event, unit)
	if unit ~= "player" and unit ~= "vehicle" and unit ~= nil then 
		return; 
	end
	header.NumUpdates = header.NumUpdates + 1;
	local UpdateID = header.NumUpdates;

	--TODO
	--workaround: currently the blizzard secureAuraHeaders do not monitor this event.
	--when applying a posion right after the loading screen, TempEnchants dont get updated correctly,
	--the UNIT_AURA event is NOT called when applying posions
	--in the name of memory usage this workaround is currently only enabled for rogues,
	--even though there is other tempEnchants
	if event == "UNIT_INVENTORY_CHANGED" and select(2,UnitClass("player")) == "ROGUE" then
		SecureAuraHeader_Update(header);
	end
	
	local s = sBuffSettings;
	for _, button in pairs(header:GetChildren()) do
		--stop update, if a new instance of this function is called, before the current update is finished
		if UpdateID < header.NumUpdates then
			--this should never happen 
			--print("DEBUG_forceQuitUpdate");
			return;
		end
		--create sub frames if needed
		if not button.created then
			sBuff:CreateAuraFrames(button, header.filter);
		end
		sBuff:UpdateAuraFrames(button);
		sBuff:UpdateAuraTime(button);
	end
	
	if header.filter == "HELPFUL" then
		--hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo();
		local weaponEnchantInfo = { GetWeaponEnchantInfo() };
		local weaponSlot = {"MainHandSlot", "SecondaryHandSlot", "RangedSlot"};
		
		for i, button in pairs(header:GetTempEnchants()) do
			--create sub frames if needed
			if not button.created then
				sBuff:CreateAuraFrames(button, header.filter);
			end
			
			-- does the weapon have an enchant
			if weaponEnchantInfo[1 + 3*(i-1)] then
				button.isTempEnchant = true;
				button.TempIndex = i;
				button.slot = weaponSlot[i];
				button.slotID = GetInventorySlotInfo(button.slot);
				sBuff:UpdateAuraFrames(button);
				sBuff:UpdateAuraTime(button);
			else
				--sBuff:UpdateAuraTime() condition is duration > 0, wep enchants do always have positive duration.
				--as a result the OnUpdate Script would never be removed
				button:SetScript("OnUpdate", nil);
				button.isTempEnchant = false;
				button.TempIndex = 0;
				button.slot = nil;
				button.slotID = nil;
			end
		end
	end
end

---update the frames
--set aura icon
--show gloss/texts if available
function sBuff:UpdateAuraFrames(button)
	local s = sBuffSettings;
	local name, icon, count;
	
	if not button.isTempEnchant then
		name,_,icon,count,_,_,_,_,_,_,_,_,_,value1 = UnitAura("player", button:GetID(), button.filter);
	else
		name = true;
		icon = GetInventoryItemTexture("player", button.slotID);
		count = 0;
	end
	
	if name then
		if button.icon then
			button.icon.texture:SetTexture(icon);
			button.icon:Show();
			button.icon.texture:Show();
		end
		if button.gloss.texture then
			button.gloss:Show();
			button.gloss.texture:Show();
		end
		if button.text.stack then
			if count > 0 then
				button.text.stack:SetText(count);
				button.text:Show();
				button.text.stack:Show();
			else
				button.text.stack:SetText("");
				button.text.stack:Hide();
				
				--handle special spells
				if value1 then
					--use the stack count to display the amount healing absorbed by Necrotic Strike
					if name == "Necrotic Strike" then
						button.text.stack:SetText((math.ceil(value1/1000)).."k");
						button.text.stack:Show();
					end
				end
			end
		end
	end
end

---update the time remaining
--set/remove OnUpdate Script
function sBuff:UpdateAuraTime(button)
	local s = sBuffSettings;
	
	if not s.textDurationEnable then
		return;
	end
	local b = ( button.filter == "HELPFUL" );
	
	local duration;
	
	if not button.isTempEnchant then
		 duration = select(6,UnitAura("player", button:GetID(), button.filter));
	else
		--everything > 0 does it
		duration = 1;
	end 
	
	--sometimes when entering/leaveing a zone (arena) UnitAura returns a nil value.
	if duration then 
		if duration > 0 then
			--OnUpdate(self, elapsed)
			button:SetScript("OnUpdate", function(...) sBuff:UpdateAuraTimeRemaining(...); end);
			button.text:Show();
			button.text.duration:Show();
			--force update
			sBuff:UpdateAuraTimeRemaining(button, b and s.buffTextDurationUpdateFrequency or s.debuffTextDurationUpdateFrequency);
		else 
			button:SetScript("OnUpdate", nil)
			button.text.duration:SetText("");
			--DEBUG
			--button.text.duration:Hide();
		end
	end
end

---update the remaining time on a button
--change update frequency if needed
--change duration text color
function sBuff:UpdateAuraTimeRemaining(button, elapsed)
	if button.lastUpdate < button.frequency then
		button.lastUpdate = button.lastUpdate + elapsed;
		return;
	end
	
	local s = sBuffSettings;
	local b = ( button.filter == "HELPFUL" );
	local timeRemaining;
	local n; --DEBUG
	--get time remaining on the aura
	if not button.isTempEnchant then
		--TODO change to select 7
		local name,_,_,_,_,_, eTime = UnitAura("player", button:GetID(), button.filter);
		n = name; --DUBUG
		if eTime then
			timeRemaining = eTime - GetTime();
		end
	else
		timeRemaining = select((2 + 3*(button.TempIndex-1)), GetWeaponEnchantInfo()) / 1000;
	end
	
	--[[
	if timeRemaining < 0 then
		--DEBUG
		local down, up, lagHome, lagWorld = GetNetStats();
		print("DEBUG_timeRemaining_<")
		print(timeRemaining)
		print(button:GetID())
		print(button.filter)
		print(n)
		--print(lagHome)
		--print(lagWorld)
		--TODO force reload
	end
	--]]
	
	if timeRemaining then
		
		--change frequency
		if timeRemaining <= s.showMiliSecs then
			button.frequency = 0.1;
		else
			button.frequency = b and s.buffTextDurationUpdateFrequency or s.debuffTextDurationUpdateFrequency;
		end
		
		--change text color on time remaining
		if timeRemaining <= s.textDurationFontColorChangeAtTime then
			button.text.duration:SetTextColor(unpack(s.textDurationFontColorExpireSoon));
		else
			button.text.duration:SetTextColor(unpack(s.textDurationFontColor));
		end
		
		--set time remaining text
		button.text.duration:SetText(sBuff:FormatTime(timeRemaining));
		button.lastUpdate = 0;
	end
	
	--update tooltip
	if button.hasActiveToolTip then
		sBuff:UpdateAuraToolTip(button);
	end
	
end

---Update the aura frame tooltip
function sBuff:UpdateAuraToolTip(button)
	GameTooltip:SetOwner(button, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetFrameLevel(button:GetFrameLevel() + 2);
	local s = button.slotID or 0;
	if s == 16 or s == 17 or s == 18 then
		GameTooltip:SetInventoryItem("player", s);
	else
		GameTooltip:SetUnitAura("player", button:GetID(), button.filter);
		if sBuffSettings.tooltipShowAuraOwner and button.filter == "HELPFUL" then
			GameTooltip:AddLine(unpack(sBuff:tooltip_auraOwner(button:GetID(), button.filter)));
		end
	end
	GameTooltip:Show();
end

---formate the time remaining for UpdateAuraTimeRemaining()
function sBuff:FormatTime(time)
	local s = sBuffSettings;
	local ftime

	if time < s.showMiliSecs then
		--show time in Miliseconds
		ftime = math.floor(10*time)/10;
		--make sure the number doesn't 'dance'
		if ftime*10 % 10 == 0 then
			ftime = ftime..".0";
		end
		return ftime.." s";
	elseif time < s.showSecs then
		--show time in seceonds
		ftime = math.floor(time);
		return ftime.." s"
	elseif time < s.showMins then
		--show time in minutes
		ftime = math.floor(time / 60);
		return ftime.." m"
	elseif time < s.showHours then
		--show time in hours
		ftime = math.floor(time / (60*60));
		return ftime.." h"
	else
		--show time in days
		ftime = math.floor(time / (24*3600));
		return ftime.." d"
	end
end


--TODO
--[[
local function GMTicketHandler()
	local s = sBuffSettings;
	
	if TicketStatusFrame:IsShown() then
		--use first GMTICKET anchor
	else
		--use normal anchor
	end
end

--not needed atm
--function sBuff:UPDATE_TICKET(event, arg1) end

function sBuff:GMSURVEY_DISPLAY(event, arg1, arg2	)
	print("GMSURVEY_DISPLAY")
	print(arg1)
	print(arg2)
end

function sBuff:GMRESPONSE_RECEIVED(event, arg1, arg2	)
	print("GMRESPONSE_RECEIVED")
	--print(arg1)
	--print(arg2)
end
--]]

--/script ChatFrame1:SetFont(ChatFrame1:GetFont(), 8)
--/script TicketStatusFrame:SetScript("OnShow", function() print("huhu") end);