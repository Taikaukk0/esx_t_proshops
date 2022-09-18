function _(str, ...)  -- Translate string
	if Cfg.Localization[str] ~= nil then
		return string.format(Cfg.Localization[str], ...)
	else
		return 'Translation [' .. str .. '] does not exist'
	end
end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub('^%l', string.upper))
end