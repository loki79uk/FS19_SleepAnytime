-- ============================================================= --
-- SLEEP ANYTIME MOD
-- ============================================================= --
SleepAnytime = {};

addModEventListener(SleepAnytime);

function SleepAnytime:SleepManagerStartSleep(superFunc, hours, noEventSend)
	if g_currentMission:getIsServer() then
		local sleepHours = hours - 1
		local currentTime = g_currentMission.environment.dayTime / 3600000
		local timeHours = math.floor(currentTime)
		local timeMinutes = math.floor((currentTime - timeHours) * 60)
		local sleepTime = ((((sleepHours*60)-timeMinutes)*60*1000) / SleepManager.SLEEPING_TIME_SCALE)
		local timeForHalfFrameAt60Fps = 500/60 --to minimise time overshoot
		self.wakeUpTime = g_time + sleepTime - timeForHalfFrameAt60Fps
		self.startTimeScale = g_currentMission.missionInfo.timeScale
		g_currentMission:setTimeScale(SleepManager.SLEEPING_TIME_SCALE)
		self.isSleeping = true
	end
	local camera = self:getCamera()
	if camera ~= 0 then
		setCamera(camera)
	end
	g_currentMission.isPlayerFrozen = true
	StartSleepStateEvent.sendEvent(hours, noEventSend)
end

function SleepAnytime:SleepManagerShowDialog(superFunc)
	local message1 = g_i18n:getText("message_TIME_NOW").." "..g_currentMission.hud.gameInfoDisplay.timeText
	local message2 = g_i18n:getText("message_SLEEP_UNTIL")

	g_gui:showSleepDialog({
		text = message1..".  "..message2,
		callback = self.sleepDialogYesNo,
		target = self,
		maxDuration = 24
	})
end

function SleepAnytime:sleepDialogUpdateOptions(superFunc)
	self.durations = {}
	
	local currentTime = g_currentMission.environment.dayTime / 3600000
	local currentHour = math.floor(currentTime)
	for i = currentHour+1, 23 do
		table.insert(self.durations, string.format("%02d:%02d", i, 0))
	end
	for i = 0, currentHour do
		table.insert(self.durations, string.format("%02d:%02d", i, 0))
	end
	--table.insert(self.durations, string.format("%02d:%02d (%.1fh)", i, 0, i-currentTime))

	self.durationElement:setTexts(self.durations)
end

function SleepAnytime:loadMap(name)
	--print("Load Mod: 'Sleep Anytime'")
	SleepManager.startSleep = Utils.overwrittenFunction(SleepManager.startSleep, SleepAnytime.SleepManagerStartSleep)
	SleepManager.showDialog = Utils.overwrittenFunction(SleepManager.showDialog, SleepAnytime.SleepManagerShowDialog)
	SleepDialog.updateOptions = Utils.overwrittenFunction(SleepDialog.updateOptions, SleepAnytime.sleepDialogUpdateOptions)
	
	self.initialised = false
end

function SleepAnytime:deleteMap()
end

function SleepAnytime:mouseEvent(posX, posY, isDown, isUp, button)
end

function SleepAnytime:keyEvent(unicode, sym, modifier, isDown)
end

function SleepAnytime:draw()
end

function SleepAnytime:update(dt)
	if not self.initialised then

		self.initialised = true
	end
end